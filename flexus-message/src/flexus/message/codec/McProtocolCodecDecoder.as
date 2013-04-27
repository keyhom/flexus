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

package flexus.message.codec {

import flash.utils.Endian;

import flexus.core.xwork.session.IoSession;
import flexus.events.Request;
import flexus.io.ByteBuffer;
import flexus.message.IoMessage;
import flexus.xwork.filters.codec.CumulativeProtocolDecoder;
import flexus.xwork.filters.codec.ProtocolDecoderOutput;

/**
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class McProtocolCodecDecoder extends CumulativeProtocolDecoder {

    /**
     * Creates a McProtocolCodecDecoder instance.
     */
    public function McProtocolCodecDecoder() {
        super();
    }

    /**
     * @inheritDoc
     */
    override protected function doDecode(session:IoSession, inb:ByteBuffer, out:ProtocolDecoderOutput):Boolean {

        if (session.containsAttribute(Endian)) {
            var endian:String = session.getAttribute(Endian) as String;
            if (endian) {
                inb.order = endian;
            }
        }

        var flag:Boolean = true;
        var size:int = 0;

        // loop to decoded all of the supplied buffer util the buffer decline to continue.
        while (inb.remaining >= 4 && inb.remaining >= inb.getIntAt(inb.position)) {

            size = inb.getIntAt(inb.position);

            if (size == 0) {
                // something illegal bytes received. close the connection imme.
                try {
                    session.close();
                    break;
                } finally {
                    trace("Illegal packet size determined, closed the connection now.");
                }
            }

            var buf:ByteBuffer = inb.slice();
            buf.order = inb.order;
            inb.position += size;

            try {
                const req:Request = new Request(IoMessage.DECODE, false, false, buf);
                out.write(req);
            } catch (t:Error) {
            }

            flag = false;
        }

        return !flag;
    }
}
}
// vim:ft=actionscript
