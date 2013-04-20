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

package flexus.utils {

/**
 * Contains reusable methods for operations pertaining
 * to int values.
 */
public class IntUtil {

    /** String for quick lookup of a hex character based on index */
    static private var hexChars:String = "0123456789abcdef";

    /**
     * Rotates x left n bits
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function rol(x:int, n:int):int {
        return (x << n) | (x >>> (32 - n));
    }

    /**
     * Rotates x right n bits
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function ror(x:int, n:int):uint {
        var nn:int = 32 - n;
        return (x << nn) | (x >>> (32 - nn));
    }

    /**
     * Outputs the hex value of a int, allowing the developer to specify
     * the endinaness in the process.  Hex output is lowercase.
     *
     * @param n The int value to output as hex
     * @param bigEndian Flag to output the int as big or little endian
     * @return A string of length 8 corresponding to the
     *        hex representation of n ( minus the leading "0x" )
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function toHex(n:int, bigEndian:Boolean = false):String {
        var s:String = "";

        if (bigEndian) {
            for (var i:int = 0; i < 4; i++) {
                s += hexChars.charAt((n >> ((3 - i) * 8 + 4)) & 0xF) + hexChars.
                        charAt((n >> ((3 - i) * 8)) & 0xF);
            }
        }
        else {
            for (var x:int = 0; x < 4; x++) {
                s += hexChars.charAt((n >> (x * 8 + 4)) & 0xF) + hexChars.charAt((n >>
                        (x *
                                8)) &
                        0xF);
            }
        }

        return s;
    }
}
}
