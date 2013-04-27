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

import flash.utils.Dictionary;

/**
 * Utilities for Dictionary.
 *
 * @version $Revision$
 * @author keyhom
 */
public class DictionaryUtil {

    /**
     * Returns an Array of all keys within the specified dictionary.
     *
     * @param d The Dictionary instance whose keys will be returned.
     *
     * @return Array of keys contained within the Dictionary
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function getKeys(d:Dictionary):Array {
        var a:Array = new Array();

        for (var key:Object in d) {
            a.push(key);
        }

        return a;
    }

    /**
     * Returns an Array of all values within the specified dictionary.
     *
     * @param d The Dictionary instance whose values will be returned.
     *
     * @return Array of values contained within the Dictionary
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function getValues(d:Dictionary):Array {
        var a:Array = new Array();

        for each (var value:Object in d) {
            a.push(value);
        }

        return a;
    }
}
}
