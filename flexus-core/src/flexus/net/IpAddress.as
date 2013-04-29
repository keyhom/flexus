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

package flexus.net {

import flash.utils.ByteArray;

/**
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class IpAddress {

    /** @private */
    private static const IP_REGEXP:RegExp = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;

    /**
     * Converts the supplied ip <code>value</code> from ByteArray to String.
     *
     * @param value IP bytes.
     * @return IP string.
     */
    public static function bytes2IpStr(value:ByteArray):String {
        var str:String = '';
        str += value.readUnsignedByte() + '.';
        str += value.readUnsignedByte() + '.';
        str += value.readUnsignedByte() + '.';
        str += value.readUnsignedByte();
        value.position -= 4;
        return str;
    }

    /**
     * Converts the supplied IP <code>value</code> from ByteArray to Number.
     *
     * @param value IP bytes.
     * @return IP long value.
     */
    public static function bytes2Long(value:ByteArray):Number {
        if (value && value.length >= 4) {
            var num:Number = 0;
            value.position = 3;
            num += (value.readUnsignedByte());
            value.position--;
            num += (value.readUnsignedByte() << 8);
            value.position--;
            num += (value.readUnsignedByte() << 16);
            value.position--;
            num += (value.readUnsignedByte() << 24);
            value.position = 0;
            return (num & 0xFFFFFFFF);
        }

        return 0;
    }

    /**
     * Converts the supplied IP <code>value</code> from Number to ByteArray.
     *
     * @param value IP long value.
     * @return IP bytes.
     */
    public static function long2Bytes(value:Number):ByteArray {
        const b:ByteArray = new ByteArray;
        b.length = 4;
        b.position = 3;
        b.writeByte((value & 0xFF));
        b.position = 2;
        b.writeByte(((value >> 8) & 0xFF));
        b.position = 1;
        b.writeByte(((value >> 16) & 0xFF));
        b.position = 0;
        b.writeByte(((value >> 24) & 0xFF));
        return b;
    }

    /**
     * Converts the supplied IP <code>value</code> from String to ByteArray.
     *
     * @param value IP string.
     * @return IP bytes.
     */
    public static function toBytes(value:String):ByteArray {
        const b:ByteArray = new ByteArray;

        if (isValid(value)) {
            var matches:Array = value.match(IP_REGEXP);

            if (matches.length == 5) {
                for (var i:int = 1, c:int = 5; i < c; i++) {
                    var num:int = parseInt(matches[i]);
                    b.writeByte(num);
                }
            }
            b.position = 0;
        }
        return b;
    }

    /**
     * Determines if the  supplied <code>value</code> was a valid IP string.
     *
     * @param value IP string.
     * @return True if the IP string was valid, false otherwise.
     */
    public static function isValid(value:String):Boolean {
        return IP_REGEXP.test(value);
    }

    /**
     * Creates an IpAddress instance.
     *
     * @param value The value of IP, can be any of string, bytes, long.
     */
    public function IpAddress(value:* = null) {
        if (value is String)
            _bytes = toBytes(String(value));
        else if (value is Number)
            _bytes = long2Bytes(Number(value));
        else if (value is ByteArray)
            _bytes = ByteArray(value);
        else
            _bytes = new ByteArray;

        _bytes.length = 4;
    }

    /** @private */
    private var _bytes:ByteArray;

    /**
     * The IP address as the byte array.
     *
     * @return The IP address
     */
    public function get bytes():ByteArray {
        return _bytes;
    }

    /**
     * Converts this IP to a number.
     *
     * @return The value of Number.
     */
    public function toNumber():Number {
        return bytes2Long(bytes);
    }

    /**
     * @private
     */
    public function toString():String {
        return bytes2IpStr(bytes);
    }

}
}
// vim:ft=actionscript
