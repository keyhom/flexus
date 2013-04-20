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

import mx.formatters.DateFormatter;
import mx.utils.Base64Encoder;

/**
 * Web Services Security Username Token
 *
 * Implementation based on algorithm description at
 * http://www.oasis-open.org/committees/wss/documents/WSS-Username-02-0223-merged.pdf
 */
public class WSSEUsernameToken {

    /**
     * Generates a WSSE Username Token.
     *
     * @param username The username
     * @param password The password
     * @param nonce A cryptographically random nonce (if null, the nonce
     * will be generated)
     * @param timestamp The time at which the token is generated (if null,
     * the time will be set to the moment of execution)
     * @return The generated token
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function getUsernameToken(username:String, password:String, nonce:String = null, timestamp:Date =
            null):String {
        if (nonce == null) {
            nonce = generateNonce();
        }
        nonce = base64Encode(nonce);

        var created:String = generateTimestamp(timestamp);

        var password64:String = getBase64Digest(nonce, created, password);

        var token:String = new String("UsernameToken Username=\"");
        token += username + "\", " + "PasswordDigest=\"" + password64 + "\", " +
                "Nonce=\"" + nonce + "\", " + "Created=\"" + created + "\"";
        return token;
    }

    static internal function base64Encode(s:String):String {
        var encoder:Base64Encoder = new Base64Encoder();
        encoder.encode(s);
        return encoder.flush();
    }

    static internal function generateTimestamp(timestamp:Date):String {
        if (timestamp == null) {
            timestamp = new Date();
        }
        var dateFormatter:DateFormatter = new DateFormatter();
        dateFormatter.formatString = "YYYY-MM-DDTJJ:NN:SS"
        return dateFormatter.format(timestamp) + "Z";
    }

    static internal function getBase64Digest(nonce:String, created:String, password:String):String {
        return SHA1.hashToBase64(nonce + created + password);
    }

    static private function generateNonce():String {
        // Math.random returns a Number between 0 and 1.  We don't want our
        // nonce to contain invalid characters (e.g. the period) so we
        // strip them out before returning the result.
        var s:String = Math.random().toString();
        return s.replace(".", "");
    }
}
}
