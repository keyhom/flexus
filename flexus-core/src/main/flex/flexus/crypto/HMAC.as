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

package flexus.crypto {

import flash.utils.ByteArray;
import flash.utils.Endian;
import flash.utils.describeType;

/**
 * Keyed-Hashing for Message Authentication
 * Implementation based on algorithm description at
 * http://www.faqs.org/rfcs/rfc2104.html
 */
public class HMAC {

    /**
     * Performs the HMAC hash algorithm using byte arrays.
     *
     * @param secret The secret key
     * @param message The message to hash
     * @param algorithm Hash object to use
     * @return A string containing the hash value of message
     * @langversion ActionScript 3.0
     * @playerversion Flash 8.5
     * @tiptext
     */
    static public function hash(secret:String, message:String, algorithm:Object =
            null):String {
        var text:ByteArray = new ByteArray();
        var k_secret:ByteArray = new ByteArray();

        text.writeUTFBytes(message);
        k_secret.writeUTFBytes(secret);

        return hashBytes(k_secret, text, algorithm);
    }

    /**
     * Performs the HMAC hash algorithm using string.
     *
     * @param secret The secret key
     * @param message The message to hash
     * @param algorithm Hash object to use
     * @return A string containing the hash value of message
     * @langversion ActionScript 3.0
     * @playerversion Flash 8.5
     * @tiptext
     */
    static public function hashBytes(secret:ByteArray, message:ByteArray, algorithm:Object =
            null):String {
        var ipad:ByteArray = new ByteArray();
        var opad:ByteArray = new ByteArray();
        var endian:String = Endian.BIG_ENDIAN;

        if (algorithm == null) {
            algorithm = MD5;
        }

        if (describeType(algorithm).@name.toString() == "com.adobe.crypto::MD5") {
            endian = Endian.LITTLE_ENDIAN;
        }

        if (secret.length > 64) {
            algorithm.hashBytes(secret);
            secret = new ByteArray();
            secret.endian = endian;

            while (algorithm.digest.bytesAvailable != 0) {
                secret.writeInt(algorithm.digest.readInt());
            }
        }

        secret.length = 64
        secret.position = 0;
        for (var x:int = 0; x < 64; x++) {
            var byte:int = secret.readByte();
            ipad.writeByte(0x36 ^ byte);
            opad.writeByte(0x5c ^ byte);
        }

        ipad.writeBytes(message);
        algorithm.hashBytes(ipad);
        var tmp:ByteArray = new ByteArray();
        tmp.endian = endian;

        while (algorithm.digest.bytesAvailable != 0) {
            tmp.writeInt(algorithm.digest.readInt());
        }
        tmp.position = 0;

        while (tmp.bytesAvailable != 0) {
            opad.writeByte(tmp.readUnsignedByte());
        }
        return algorithm.hashBytes(opad);
    }
}
}
