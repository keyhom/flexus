/*
 * Copyright (c) 2013 keyhom.c@gmail.com.
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from
 * the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose
 * excluding commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 *     1. The origin of this software must not be misrepresented; you must not
 *     claim that you wrote the original software. If you use this software
 *     in a product, an acknowledgment in the product documentation would be
 *     appreciated but is not required.
 *
 *     2. Altered source versions must be plainly marked as such, and must not
 *     be misrepresented as being the original software.
 *
 *     3. This notice may not be removed or altered from any source
 *     distribution.
 */

package flexus.xwork.filters.codec {

import flash.utils.getQualifiedClassName;

import flexus.core.xwork.XworkLogTarget;
import flexus.core.xwork.filterChain.IoFilter;
import flexus.core.xwork.filterChain.IoFilterChain;
import flexus.core.xwork.filterChain.NextFilter;
import flexus.core.xwork.session.IoSession;
import flexus.io.ByteBuffer;
import flexus.utils.IQueue;

import mx.logging.ILogger;
import mx.logging.LogLogger;

/**
 * @author keyhom
 */
public class ProtocolCodecFilter extends IoFilter {

    /**
     * @private
     */
    static private const logger:ILogger = XworkLogTarget.addLogger(new LogLogger('CODEC'));
    static private const DECODER:String = "__decoder__";
    static private const DECODER_OUT:String = "__decoder_out__";
    static private const ENCODER:String = "__encoder__";
    static private const ENCODER_OUT:String = "__encoder_out__";

    /**
     * Creates a ProtocolCodecFilter instance..
     */
    public function ProtocolCodecFilter(factory:ProtocolCodecFactory) {
        super();

        if (factory == null) {
            throw new ArgumentError("factory");
        }
        this.factory = factory;
    }

    public var factory:ProtocolCodecFactory;

    override public function filterWrite(nextFilter:NextFilter, session:IoSession, message:Object):void {
        // Bypass the encoding if the message is contained in a IoBuffer,
        // as it has already been encoded before
        if ((message is ByteBuffer)) {
            nextFilter.filterWrite(session, message);
            return;
        }

        // Get the encoder in the session
        var encoder:ProtocolEncoder = factory.getEncoder(session);

        var encoderOut:ProtocolEncoderOutput = getEncoderOut(session, nextFilter,
                message);

        if (encoder == null) {
            throw new Error("The encoder is null for the session " + session);
        }

        if (encoderOut == null) {
            throw new Error("The encoderOut is null for the session " + session);
        }

        try {
            // Now we can try to encode the response
            encoder.encode(session, message, encoderOut);

            // Send it directly
            var bufferQueue:IQueue = (ProtocolEncoderOutput(encoderOut)).messageQueue;

            // Write all the encoded messages now
            while (!bufferQueue.empty) {
                var encodedMessage:Object = bufferQueue.poll();

                if (!encodedMessage)
                    continue;

                // Flush only when the buffer has remaining.
                if (!(encodedMessage is ByteBuffer) || (ByteBuffer(encodedMessage)).
                        hasRemaining) {
//					var encodedWriteRequest:WriteRequest = new EncodedWriteRequest(encodedMessage,
//																				   null);
                    nextFilter.filterWrite(session, encodedMessage);
                }
            }

            // Call the next filter
            nextFilter.filterWrite(session, message);
        }
        catch (t:Error) {
            throw t;
        }
    }

    override public function messageRecieved(nextFilter:NextFilter, session:IoSession, message:Object):void {
        if (!(message is ByteBuffer)) {
            nextFilter.messageRecieved(session, message);
            return;
        }

        const in1:ByteBuffer = ByteBuffer(message);
        const decoder:ProtocolDecoder = factory.getDecoder(session);
        const decoderOut:ProtocolDecoderOutput = getDecoderOut(session, nextFilter);

        // Loop until we don't have anymore byte in the buffer,
        // or until the decoder throws an unrecoverable exception or
        // can't decoder a message, because there are not enough
        // data in the buffer
        while (in1.hasRemaining) {
            const oldPos:int = in1.position;

            try {
                // Call the decoder with the read bytes
                decoder.decode(session, in1, decoderOut);
                // Finish decoding if no exception was thrown.
                decoderOut.flush(nextFilter, session);
            }
            catch (t:Error) {
                // log the buffer hex dump.
                var curPos:int = in1.position;
                in1.position = oldPos;
                logger.error(in1.toString(Math.max(in1.remaining, 25)), t);
                in1.position = curPos;

                // Fire the exceptionCaught event.
                decoderOut.flush(nextFilter, session);
                nextFilter.exceptionCaught(session, t);

                // Retry only if the type of the caught exception is
                // recoverable and the buffer position has changed.
                // We check buffer position additionally to prevent an
                // infinite loop.

//				if (t is EOFError) {
//					in1.position = oldPos;
//					continue;
//				}

                if (curPos == oldPos) {
                    break;
                }
            }
        }
    }

    override public function messageSent(nextFilter:NextFilter, session:IoSession, message:Object):void {
        nextFilter.messageSent(session, message);
    }

    override public function onPostRemove(parent:IoFilterChain, name:String, nextFilter:NextFilter):void {
        // Clean everything
        disposeCodec(parent.session);
    }

    override public function onPreAdd(parent:IoFilterChain, name:String, nextFilter:NextFilter):void {
        if (parent.contains(this)) {
            throw new ArgumentError("You can't add the same filter instance more than once.  Create another instance and add it.");
        }
    }

    override public function sessionClosed(nextFilter:NextFilter, session:IoSession):void {
        // Call finishDecode() first when a connection is closed.
        var decoder:ProtocolDecoder = factory.getDecoder(session);
        var decoderOut:ProtocolDecoderOutput = getDecoderOut(session, nextFilter);

        try {
            decoder.finishDecode(session, decoderOut);
        }
        catch (t:Error) {
            throw t;
        }
        finally {
            // Dispose everything
            disposeCodec(session);
            decoderOut.flush(nextFilter, session);
        }

        // Call the next filter
        nextFilter.sessionClosed(session);
    }

    /**
     * Get the encoder instance from a given session.
     *
     * @param session The associated session we will get the encoder from
     * @return The encoder instance, if any
     */
    public function getEncoder(session:IoSession):ProtocolEncoder {
        return session.getAttribute(ENCODER) as ProtocolEncoder;
    }

    //----------- Helper methods ---------------------------------------------

    /**
     * Dispose the encoder, decoder, and the callback for the decoded
     * messages.
     */
    private function disposeCodec(session:IoSession):void {
        // We just remove the two instances of encoder/decoder to release resources
        // from the session
        disposeEncoder(session);
        disposeDecoder(session);

        // We also remove the callback
        disposeDecoderOut(session);
    }

    /**
     * Dispose the decoder, removing its instance from the
     * session's attributes, and calling the associated
     * dispose method.
     */
    private function disposeDecoder(session:IoSession):void {
        var decoder:ProtocolDecoder = ProtocolDecoder(session.removeAttribute(DECODER));

        if (decoder == null) {
            return;
        }

        try {
            decoder.dispose(session);
        }
        catch (t:Error) {
            logger.warn("Failed to dispose: {0} ( {1} ).", getQualifiedClassName(decoder),
                    decoder);
        }
    }

    /**
     * Remove the decoder callback from the session's attributes.
     */
    private function disposeDecoderOut(session:IoSession):void {
        session.removeAttribute(DECODER_OUT);
    }

    /**
     * Dispose the encoder, removing its instance from the
     * session's attributes, and calling the associated
     * dispose method.
     */
    private function disposeEncoder(session:IoSession):void {
        var encoder:ProtocolEncoder = session.removeAttribute(ENCODER) as ProtocolEncoder;

        if (encoder == null) {
            return;
        }

        try {
            encoder.dispose(session);
        }
        catch (t:Error) {
            logger.warn("Failed to dispose: {0} ( {1} ).", getQualifiedClassName(encoder),
                    encoder);
        }
    }

    /**
     * Return a reference to the decoder callback. If it's not already created
     * and stored into the session, we create a new instance.
     */
    private function getDecoderOut(session:IoSession, nextFilter:NextFilter):ProtocolDecoderOutput {
        var out:ProtocolDecoderOutput = ProtocolDecoderOutput(session.getAttribute(DECODER_OUT));

        if (out == null) {
            // Create a new instance, and stores it into the session
            out = new ProtocolDecoderOutputImpl();
            session.setAttribute(DECODER_OUT, out);
        }

        return out;
    }

    private function getEncoderOut(session:IoSession, nextFilter:NextFilter, messsage:Object):ProtocolEncoderOutput {
        var out:ProtocolEncoderOutput = ProtocolEncoderOutput(session.getAttribute(ENCODER_OUT));

        if (out == null) {
            // Create a new instance, and stores it into the session
            out = new ProtocolEncoderOutputImpl(session, nextFilter, messsage);
            session.setAttribute(ENCODER_OUT, out);
        }

        return out;
    }
}
}

import flexus.core.xwork.filterChain.NextFilter;
import flexus.core.xwork.session.IoSession;
import flexus.io.ByteBuffer;
import flexus.utils.IQueue;
import flexus.xwork.filters.codec.ProtocolDecoderOutput;
import flexus.xwork.filters.codec.ProtocolEncoderOutput;

class ProtocolEncoderOutputImpl extends ProtocolEncoderOutput {

    /**
     * Creates a ProtocolEncoderOutputImpl instance.
     */
    public function ProtocolEncoderOutputImpl(session:IoSession, nextFilter:NextFilter, message:Object) {
        super();
        this.session = session;
        this.nextFilter = nextFilter;
        this.message = message;
    }

    private var nextFilter:NextFilter;

    private var session:IoSession;

    private var message:Object;

    override public function flush():Object {
        var bufferQueue:IQueue = messageQueue;
        var future:Object = null;

        while (!bufferQueue.empty) {
            var encodedMessage:Object = bufferQueue.poll();

            // Flush only when the buffer has remaining.
            if (!(encodedMessage is ByteBuffer) || ByteBuffer(encodedMessage).
                    hasRemaining) {
//				future = new DefaultWriteFuture(session);
//				nextFilter.filterWrite(session, new EncodedWriteRequest(encodedMessage,
//																		future));
                nextFilter.filterWrite(session, encodedMessage);
            }
        }

//		if (future == null)
//		{
//			future = DefaultWriteFuture.newNotWrittenFuture(session, new Error("NothingWrittenException: " +
//																			   message));
//		}

        return future;
    }
}

class ProtocolDecoderOutputImpl extends ProtocolDecoderOutput {

    /**
     * Creates a ProtocolDecoderOutputImpl instance.
     */
    public function ProtocolDecoderOutputImpl() {
        super();
    }

    override public function flush(nextFilter:NextFilter, session:IoSession):void {
        while (!messageQueue.empty) {
            nextFilter.messageRecieved(session, messageQueue.poll());
        }
    }
}
