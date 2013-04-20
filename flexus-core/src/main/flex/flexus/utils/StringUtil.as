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
 * Class that contains static utility methods for manipulating Strings.
 *
 * @langversion ActionScript 3.0
 * @playerversion Flash 9.0
 * @tiptext
 */
public class StringUtil {

    /**
     * Determines whether the specified string begins with the spcified prefix.
     *
     * @param input The string that the prefix will be checked against.
     *
     * @param prefix The prefix that will be tested against the string.
     *
     * @returns True if the string starts with the prefix, false if it does not.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function beginsWith(input:String, prefix:String):Boolean {
        return (prefix == input.substring(0, prefix.length));
    }

    /**
     * Determines whether the specified string ends with the specified suffix.
     *
     * @param input The string that the suffix will be checked against.
     *
     * @param suffix The suffix that will be tested against the string.
     *
     * @returns True if the string ends with the suffix, false if it does not.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function endsWith(input:String, suffix:String):Boolean {
        return (suffix == input.substring(input.length - suffix.length));
    }

    /**
     * Specifies whether the specified string is either non-null, or contains
     * characters (i.e. length is greater that 0)
     *
     * @param s The string which is being checked for a value
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function isEmpty(s:String):Boolean {
        //todo: this needs a unit test
        return (s == null || s.length == 0);
    }

    /**
     * Removes whitespace from the front of the specified string.
     *
     * @param input The String whose beginning whitespace will will be removed.
     *
     * @returns A String with whitespace removed from the begining
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function ltrim(input:String):String {
        var size:Number = input.length;
        for (var i:Number = 0; i < size; i++) {
            if (input.charCodeAt(i) > 32) {
                return input.substring(i);
            }
        }
        return "";
    }

    /**
     * Removes all instances of the remove string in the input string.
     *
     * @param input The string that will be checked for instances of remove
     * string
     *
     * @param remove The string that will be removed from the input string.
     *
     * @returns A String with the remove string removed.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function remove(input:String, remove:String):String {
        return StringUtil.replace(input, remove, "");
    }

    /**
     * Replaces all instances of the replace string in the input string
     * with the replaceWith string.
     *
     * @param input The string that instances of replace string will be
     * replaces with removeWith string.
     *
     * @param replace The string that will be replaced by instances of
     * the replaceWith string.
     *
     * @param replaceWith The string that will replace instances of replace
     * string.
     *
     * @returns A new String with the replace string replaced with the
     * replaceWith string.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function replace(input:String, replace:String, replaceWith:String):String {
        return input.split(replace).join(replaceWith);
    }

    /**
     * Removes whitespace from the end of the specified string.
     *
     * @param input The String whose ending whitespace will will be removed.
     *
     * @returns A String with whitespace removed from the end
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function rtrim(input:String):String {
        var size:Number = input.length;
        for (var i:Number = size; i > 0; i--) {
            if (input.charCodeAt(i - 1) > 32) {
                return input.substring(0, i);
            }
        }

        return "";
    }

    /**
     * Does a case insensitive compare or two strings and returns true if
     * they are equal.
     *
     * @param s1 The first string to compare.
     *
     * @param s2 The second string to compare.
     *
     * @param caseSensitive True if case sensitive, false otherwise.
     *
     * @returns A boolean value indicating whether the strings' values are
     * equal in a case sensitive compare.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function stringsAreEqual(s1:String, s2:String, caseSensitive:Boolean):Boolean {
        if (caseSensitive) {
            return (s1 == s2);
        }
        else {
            return (s1.toUpperCase() == s2.toUpperCase());
        }
    }

    /**
     * Removes whitespace from the front and the end of the specified
     * string.
     *
     * @param input The String whose beginning and ending whitespace will
     * will be removed.
     *
     * @returns A String with whitespace removed from the begining and end
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     * @tiptext
     */
    static public function trim(input:String):String {
        return StringUtil.ltrim(StringUtil.rtrim(input));
    }
}
}
