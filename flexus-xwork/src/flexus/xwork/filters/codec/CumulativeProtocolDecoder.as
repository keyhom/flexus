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

import flexus.core.xwork.session.IoSession;
import flexus.errors.IllegalStateError;
import flexus.io.ByteBuffer;

/**
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class CumulativeProtocolDecoder extends ProtocolDecoder {

    /**
     * @private
     */
    static private const BUFFER:String = "__buffer";

    /**
     * Creates a CumulativeProtocolDecoder instance.
     */
    public function CumulativeProtocolDecoder() {
        super();
    }

    /**
     * Cumulative content of <tt>in</tt> into internal buffer and forwards
     * decoding request to #doDecode(IoSession, IoBuffer, ProtocolDecoderOutput).
     * <tt>doDecode()</tt> is invoked repeatedly until it returns <tt>false</tt>
     * and the cumulative buffer is compacted after decoding ends.
     *
     * @throws IllegalStateException if your <tt>doDecode()</tt> returned
     *                               <tt>true</tt> not consuming the cumulative buffer.
     */
    override public function decode(session:IoSession, in1:ByteBuffer, out:ProtocolDecoderOutput):void {
        var usingSessionBuffer:Boolean = true;
        var buf:ByteBuffer = ByteBuffer(session.getAttribute(BUFFER));

        // If we have a session buffer, append data to that; otherwise
        // use the buffer read from the network directly.
        if (buf != null) {
            var appended:Boolean = false;
            try {
                buf.put(in1);
                in1.position = in1.limit;
                appended = true;
            }
            catch (e:Error) {
            }

            if (appended) {
                buf.flip();
            } else {
                // Reallocate the buffer if append operation failed due to
                // derivation or EOF, etc.
                buf.flip();
                const newBuf:ByteBuffer = new ByteBuffer();
                newBuf.order = buf.order;
                newBuf.put(buf);
                newBuf.put(in1);
                newBuf.flip();
                buf = newBuf;

                // Update the session buffer.
                session.setAttribute(BUFFER, buf);
            }
        }
        else {
            buf = in1;
            usingSessionBuffer = false;
        }

        var decoded:Boolean;

        for (; ;) {
            const oldPos:int = buf.position;
            decoded = doDecode(session, buf, out);

            if (decoded) {
                if (buf.position == oldPos) {
                    throw new IllegalStateError("doDecode() can't return true when buffer is not consumed.");
                }

                if (!buf.hasRemaining) {
                    break;
                }
            }
            else {
                break;
            }
        }

        // if there is any data left that cannot be decoded, we store
        // it in a buffer in the session and next time this decoder is
        // invoked the session buffer gets appended to
        if (buf.hasRemaining) {
            if (usingSessionBuffer) {
                buf.compact();
            }
            else {
                storeRemainingInSession(buf, session);
            }
        }
        else {
            if (usingSessionBuffer) {
                removeSessionBuffer(session);
            }
        }
    }

    override public function dispose(session:IoSession):void {
        removeSessionBuffer(session);
    }

    protected function doDecode(session:IoSession, buf:ByteBuffer, out:ProtocolDecoderOutput):Boolean {
        return true;
    }

    private function removeSessionBuffer(session:IoSession):void {
        const buf:ByteBuffer = session.removeAttribute(BUFFER) as ByteBuffer;
        if (buf) {
            buf.clear();
        }
    }

    private function storeRemainingInSession(buf:ByteBuffer, session:IoSession):void {
        // compact the decoded part in buffer.
        const remainingBuf:ByteBuffer = new ByteBuffer;
        remainingBuf.order = buf.order;
        remainingBuf.put(buf);
        buf.position = buf.limit;
        session.setAttribute(BUFFER, remainingBuf);
    }
}
}
