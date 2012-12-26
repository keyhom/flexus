//------------------------------------------------------------------------------
//
//   PureArt Archetype. Make any work easier. 
// 
//   Copyright (C) 2011  pureart.org 
// 
//   This program is free software: you can redistribute it and/or modify 
//   it under the terms of the GNU General Public License as published by 
//   the Free Software Foundation, either version 3 of the License, or 
//   (at your option) any later version. 
// 
//   This program is distributed in the hope that it will be useful, 
//   but WITHOUT ANY WARRANTY; without even the implied warranty of 
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
//   GNU General Public License for more details. 
// 
//   You should have received a copy of the GNU General Public License 
//   along with this program.  If not, see <http://www.gnu.org/licenses/>. 
//
//------------------------------------------------------------------------------

package flexus.xwork.filters.codec
{

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
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ProtocolCodecFilter extends IoFilter
{

	static private const logger:ILogger = XworkLogTarget.addLogger(new LogLogger('CODEC'));

	//--------------------------------------------------------------------------
	//
	//  Class properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// DECODER 
	//----------------------------------

	static private const DECODER:String = "__decoder__";

	//----------------------------------
	// DECODER_OUT 
	//----------------------------------

	static private const DECODER_OUT:String = "__decoder_out__";

	//----------------------------------
	// ENCODER 
	//----------------------------------

	static private const ENCODER:String = "__encoder__";

	//----------------------------------
	// ENCODER_OUT 
	//----------------------------------

	static private const ENCODER_OUT:String = "__encoder_out__";

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param factory
	 *  @throws ArgumentError
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function ProtocolCodecFilter(factory:ProtocolCodecFactory)
	{
		super();

		if (factory == null)
		{
			throw new ArgumentError("factory");
		}
		this.factory = factory;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// factory 
	//----------------------------------

	/**
	 *  @private
	 */
	public var factory:ProtocolCodecFactory;

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override public function filterWrite(nextFilter:NextFilter, session:IoSession,
										 message:Object):void
	{
		// Bypass the encoding if the message is contained in a IoBuffer,
		// as it has already been encoded before
		if ((message is ByteBuffer))
		{
			nextFilter.filterWrite(session, message);
			return;
		}

		// Get the encoder in the session
		var encoder:ProtocolEncoder = factory.getEncoder(session);

		var encoderOut:ProtocolEncoderOutput = getEncoderOut(session, nextFilter,
															 message);

		if (encoder == null)
		{
			throw new Error("The encoder is null for the session " + session);
		}

		if (encoderOut == null)
		{
			throw new Error("The encoderOut is null for the session " + session);
		}

		try
		{
			// Now we can try to encode the response
			encoder.encode(session, message, encoderOut);

			// Send it directly
			var bufferQueue:IQueue = (ProtocolEncoderOutput(encoderOut)).messageQueue;

			// Write all the encoded messages now
			while (!bufferQueue.empty)
			{
				var encodedMessage:Object = bufferQueue.poll();

				// Flush only when the buffer has remaining.
				if (!(encodedMessage is ByteBuffer) || (ByteBuffer(encodedMessage)).
					hasRemaining)
				{
//					var encodedWriteRequest:WriteRequest = new EncodedWriteRequest(encodedMessage,
//																				   null);
					nextFilter.filterWrite(session, encodedMessage);
				}
			}

			// Call the next filter
			nextFilter.filterWrite(session, message);
		}
		catch (t:Error)
		{
			throw t;
		}
	}

	override public function messageRecieved(nextFilter:NextFilter, session:IoSession,
											 message:Object):void
	{
		if (!(message is ByteBuffer))
		{
			nextFilter.messageRecieved(session, message);
			return;
		}

		var in1:ByteBuffer = ByteBuffer(message);
		var decoder:ProtocolDecoder = factory.getDecoder(session);
		var decoderOut:ProtocolDecoderOutput = getDecoderOut(session, nextFilter);

		// Loop until we don't have anymore byte in the buffer,
		// or until the decoder throws an unrecoverable exception or 
		// can't decoder a message, because there are not enough 
		// data in the buffer
		while (in1.hasRemaining)
		{
			var oldPos:int = in1.position;

			try
			{
				// Call the decoder with the read bytes
				decoder.decode(session, in1, decoderOut);
				// Finish decoding if no exception was thrown.
				decoderOut.flush(nextFilter, session);
			}
			catch (t:Error)
			{
				// Fire the exceptionCaught event.
				decoderOut.flush(nextFilter, session);
				nextFilter.exceptionCaught(session, t);

					// Retry only if the type of the caught exception is
					// recoverable and the buffer position has changed.
					// We check buffer position additionally to prevent an
					// infinite loop.
			}
		}
	}

	override public function messageSent(nextFilter:NextFilter, session:IoSession,
										 message:Object):void
	{
		nextFilter.messageSent(session, message);
	}

	override public function onPostRemove(parent:IoFilterChain, name:String,
										  nextFilter:NextFilter):void
	{
		// Clean everything
		disposeCodec(parent.session);
	}

	override public function onPreAdd(parent:IoFilterChain, name:String, nextFilter:NextFilter):void
	{
		if (parent.contains(this))
		{
			throw new ArgumentError("You can't add the same filter instance more than once.  Create another instance and add it.");
		}
	}

	override public function sessionClosed(nextFilter:NextFilter, session:IoSession):void
	{
		// Call finishDecode() first when a connection is closed.
		var decoder:ProtocolDecoder = factory.getDecoder(session);
		var decoderOut:ProtocolDecoderOutput = getDecoderOut(session, nextFilter);

		try
		{
			decoder.finishDecode(session, decoderOut);
		}
		catch (t:Error)
		{
			throw t;
		}
		finally
		{
			// Dispose everything
			disposeCodec(session);
			decoderOut.flush(nextFilter, session);
		}

		// Call the next filter
		nextFilter.sessionClosed(session);
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 * Get the encoder instance from a given session.
	 *
	 * @param session The associated session we will get the encoder from
	 * @return The encoder instance, if any
	 */
	public function getEncoder(session:IoSession):ProtocolEncoder
	{
		return session.getAttribute(ENCODER) as ProtocolEncoder;
	}

	//----------- Helper methods ---------------------------------------------
	/**
	 * Dispose the encoder, decoder, and the callback for the decoded
	 * messages.
	 */
	private function disposeCodec(session:IoSession):void
	{
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
	private function disposeDecoder(session:IoSession):void
	{
		var decoder:ProtocolDecoder = ProtocolDecoder(session.removeAttribute(DECODER));

		if (decoder == null)
		{
			return;
		}

		try
		{
			decoder.dispose(session);
		}
		catch (t:Error)
		{
			logger.warn("Failed to dispose: {0} ( {1} ).", getQualifiedClassName(decoder),
						decoder);
		}
	}

	/**
	 * Remove the decoder callback from the session's attributes.
	 */
	private function disposeDecoderOut(session:IoSession):void
	{
		session.removeAttribute(DECODER_OUT);
	}

	/**
	 * Dispose the encoder, removing its instance from the
	 * session's attributes, and calling the associated
	 * dispose method.
	 */
	private function disposeEncoder(session:IoSession):void
	{
		var encoder:ProtocolEncoder = session.removeAttribute(ENCODER) as ProtocolEncoder;

		if (encoder == null)
		{
			return;
		}

		try
		{
			encoder.dispose(session);
		}
		catch (t:Error)
		{
			logger.warn("Failed to dispose: {0} ( {1} ).", getQualifiedClassName(encoder),
						encoder);
		}
	}

	/**
	 * Return a reference to the decoder callback. If it's not already created
	 * and stored into the session, we create a new instance.
	 */
	private function getDecoderOut(session:IoSession, nextFilter:NextFilter):ProtocolDecoderOutput
	{
		var out:ProtocolDecoderOutput = ProtocolDecoderOutput(session.getAttribute(DECODER_OUT));

		if (out == null)
		{
			// Create a new instance, and stores it into the session
			out = new ProtocolDecoderOutputImpl();
			session.setAttribute(DECODER_OUT, out);
		}

		return out;
	}

	/**
	 *
	 *  @param session
	 *  @param nextFilter
	 *  @param writeRequest
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function getEncoderOut(session:IoSession, nextFilter:NextFilter,
								   messsage:Object):ProtocolEncoderOutput
	{
		var out:ProtocolEncoderOutput = ProtocolEncoderOutput(session.getAttribute(ENCODER_OUT));

		if (out == null)
		{
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
import flexus.xwork.filters.codec.ProtocolEncoder;
import flexus.xwork.filters.codec.ProtocolEncoderOutput;

/**
 *  @private
 */
class ProtocolEncoderOutputImpl extends ProtocolEncoderOutput
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 * 
	 *  @param session
	 *  @param nextFilter
	 *  @param writeRequest
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function ProtocolEncoderOutputImpl(session:IoSession, nextFilter:NextFilter,
											  message:Object)
	{
		super();
		this.session = session;
		this.nextFilter = nextFilter;
		this.message = message;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// nextFilter 
	//----------------------------------

	private var nextFilter:NextFilter;

	//----------------------------------
	// session 
	//----------------------------------

	private var session:IoSession;

	//----------------------------------
	// writeRequest 
	//----------------------------------

	private var message:Object;

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override public function flush():Object
	{
		var bufferQueue:IQueue = messageQueue;
		var future:Object = null;

		while (!bufferQueue.empty)
		{
			var encodedMessage:Object = bufferQueue.poll();

			// Flush only when the buffer has remaining.
			if (!(encodedMessage is ByteBuffer) || ByteBuffer(encodedMessage).
				hasRemaining)
			{
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

/**
 *  @private
 */
class ProtocolDecoderOutputImpl extends ProtocolDecoderOutput
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function ProtocolDecoderOutputImpl()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override public function flush(nextFilter:NextFilter, session:IoSession):void
	{

		while (!messageQueue.empty)
		{
			nextFilter.messageRecieved(session, messageQueue.poll());
		}
	}
}
