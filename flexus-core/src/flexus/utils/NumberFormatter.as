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
 *    Class that contains static utility methods for formatting Numbers
 *
 *    @langversion ActionScript 3.0
 *    @playerversion Flash 9.0
 *    @tiptext
 *
 *    @see #mx.formatters.NumberFormatter
 */
public class NumberFormatter {

    /**
     * Formats a number to include a leading zero if it is a single digit
     * between -1 and 10.
     *
     * @param n The number that will be formatted
     *
     * @return A string with single digits between -1 and 10 padded with a
     * leading zero.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function addLeadingZero(n:Number):String {
        var out:String = String(n);

        if (n < 10 && n > -1) {
            out = "0" + out;
        }

        return out;
    }
}
}
