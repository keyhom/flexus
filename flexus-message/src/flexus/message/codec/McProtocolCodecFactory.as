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

import flexus.core.xwork.service.IoHandler;
import flexus.core.xwork.session.IoSession;
import flexus.xwork.filters.codec.ProtocolCodecFactory;
import flexus.xwork.filters.codec.ProtocolDecoder;
import flexus.xwork.filters.codec.ProtocolEncoder;

/**
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class McProtocolCodecFactory extends IoHandler implements ProtocolCodecFactory {

    /**
     * Creates a McProtocolCodecFactory instance.
     */
    public function McProtocolCodecFactory() {
        super();
        this._decoder = new McProtocolCodecDecoder;
        this._encoder = new McProtocolCodecEncoder;
    }

    /**
     * @private
     * Decoder.
     */
    private var _decoder:ProtocolDecoder;

    /**
     * @private
     * encoder.
     */
    private var _encoder:ProtocolEncoder;

    /**
     * @private
     */
    private var _endian:String = Endian.BIG_ENDIAN;

    /**
     * Byte array order.
     */
    public function get order():String {
        return this._endian;
    }

    /**
     * @private
     */
    public function set order(value:String):void {
        this._endian = value;
    }

    /**
     * Retrieves the decoder.
     *
     * @param session The associated IoSession.
     */
    public function getDecoder(session:IoSession):ProtocolDecoder {
        session.setAttribute(Endian, order);
        return _decoder;
    }

    /**
     * Retrieves the encoder.
     *
     * @param session The associated IoSession.
     */
    public function getEncoder(session:IoSession):ProtocolEncoder {
        session.setAttribute(Endian, order);
        return _encoder;
    }
}
}
// vim:ft=actionscript
