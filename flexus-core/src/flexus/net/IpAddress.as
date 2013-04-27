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
 * @author keyhom
 */
public class IpAddress {

    static public const IP_REGEXP:RegExp = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;

    static public function bytes2IpStr(value:ByteArray):String {
        var str:String = '';
        str += value.readUnsignedByte() + '.';
        str += value.readUnsignedByte() + '.';
        str += value.readUnsignedByte() + '.';
        str += value.readUnsignedByte();
        value.position = 0;
        return str;
    }

    static public function bytes2Long(value:ByteArray):Number {
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

    static public function isValid(value:String):Boolean {
        return IP_REGEXP.test(value);
    }

    static public function long2Bytes(value:Number):ByteArray {
        var b:ByteArray = new ByteArray;
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

    static public function toBytes(value:String):ByteArray {
        var b:ByteArray = new ByteArray;

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
     * Creates an IpAddress instance.
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

    private var _bytes:ByteArray;

    /**
     * The IP address as the byte array.
     *
     * @return The IP address
     */
    public function get bytes():ByteArray {
        return _bytes;
    }

    public function toNumber():Number {
        return bytes2Long(bytes);
    }

    public function toString():String {
        return bytes2IpStr(bytes);
    }
}
}
