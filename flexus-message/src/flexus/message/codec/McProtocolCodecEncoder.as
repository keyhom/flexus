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
import flexus.message.IoMessageInfo;
import flexus.xwork.filters.codec.ProtocolEncoder;
import flexus.xwork.filters.codec.ProtocolEncoderOutput;

/**
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class McProtocolCodecEncoder extends ProtocolEncoder {

    /**
     * Creates a McProtocolCodecEncoder instance.
     */
    public function McProtocolCodecEncoder() {
        super();
    }

    /**
     * @inheritDoc
     */
    override public function encode(session:IoSession, message:Object, out:ProtocolEncoderOutput):void {
        if (message is IoMessageInfo) {
            var info:IoMessageInfo = IoMessageInfo(message);
            var buf:ByteBuffer = new ByteBuffer;

            if (session.containsAttribute(Endian)) {
                const endian:String = session.getAttribute(Endian) as String;
                if (endian) {
                    buf.order = endian;
                }
            }

            var req:Request = new Request(IoMessage.ENCODE, false, false, buf);
            info.message.dispatchEvent(req);

            if (buf.remaining)
                out.write(buf);
        }
    }
}
}
// vim:ft=actionscript
