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

/**
 * @author keyhom
 */
public class SimpleProtocolCodecFactory implements ProtocolCodecFactory {

    /**
     * Creates a SimpleProtocolCodecFactory instance.
     *
     * @param encoder The encoder.
     * @param decoder The decoder.
     */
    public function SimpleProtocolCodecFactory(encoder:ProtocolEncoder, decoder:ProtocolDecoder) {
        super();

        if (encoder == null)
            throw new ArgumentError("encoder");

        if (decoder == null)
            throw new ArgumentError("decoder");

        this._decoder = decoder;
        this._encoder = encoder;
    }

    private var _decoder:ProtocolDecoder;
    private var _encoder:ProtocolEncoder;

    public function getDecoder(session:IoSession):ProtocolDecoder {
        return _decoder;
    }

    public function getEncoder(session:IoSession):ProtocolEncoder {
        return _encoder;
    }
}
}
