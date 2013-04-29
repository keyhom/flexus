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

package flexus.io {

import flash.utils.ByteArray;
import flash.utils.Endian;

/**
 * The abstract buffer with byte array.
 *
 * @version $Revision$
 * @author keyhom (keyhom.@gmail.com)
 */
public class ByteBuffer {

    static public function wrap(array:ByteArray):ByteBuffer {
        const buf:ByteBuffer = new ByteBuffer;
        buf._array = array;
        return buf;
    }

    static public function toHexString(bytes:ByteArray, limit:uint = 25):String {
        if (bytes) {
            var s:String = '';

            const pos:uint = bytes.position;
            const len:uint = Math.min(bytes.length, limit);

            for (var i:int = 0; i < len; i++) {
                var b:int = bytes.readByte();
                var s1:String = (b & 0xFF).toString(16).toUpperCase();

                if (s1.length == 1)
                    s1 = '0' + s1;
                s += ' ' + s1;
            }

            bytes.position = pos;

            if (len < bytes.length)
                s += ' ...';

            return s;
        }

        return '';
    }

    /**
     * Creates a ByteBuffer instance.
     */
    public function ByteBuffer() {
    }

    private var _mark:int = -1;

    /**
     *  @private
     *  Storage for the array property.
     */
    private var _array:ByteArray = new ByteArray;

    /**
     *  Byte array as native implementation.
     *
     *  @see flash.utils.ByteArray
     */
    public function get array():ByteArray {
        return _array;
    }

    public function get hasRemaining():Boolean {
        return remaining > 0;
    }

    public function get isBigEndian():Boolean {
        return array.endian == Endian.BIG_ENDIAN;
    }

    /**
     *  The current limit index of the <code>Buffer</code>.
     */
    public function get limit():uint {
        return array.length;
    }

    /**
     *  @private
     */
    public function set limit(value:uint):void {
        array.length = value;
    }

    public function get markValue():int {
        return _mark;
    }

    public function get order():String {
        return array.endian;
    }

    /**
     *  @private
     */
    public function set order(value:String):void {
        if (!value)
            value = Endian.BIG_ENDIAN;
        array.endian = value;
    }

    /**
     * The current position index of the <code>Buffer</code>.
     */
    public function get position():uint {
        return array.position;
    }

    /**
     *  @private
     */
    public function set position(value:uint):void {
        array.position = value;
    }

    public function get remaining():uint {
        return limit - position;
    }

    public function clear():ByteBuffer {
        array.clear();
        limit = position = 0;
        _mark = -1;
        return this;
    }

    /**
     * Free the buffer.
     * <font color="red">
     * Makes sure don't doing any action after the <code>free</code> method was called.
     * </font>
     */
    public function free():void {
        _array = null;
    }

    public function compact():ByteBuffer {
        const bytes:ByteArray = new ByteArray;
        bytes.endian = array.endian;
        bytes.writeBytes(array, position, remaining);
        _array.clear();
        _array = bytes;
        return this;
    }

    public function flip():ByteBuffer {
        this.limit = this.position;
        this.position = 0;
        return this;
    }

    public function get():int {
        return array.readByte();
    }

    public function getAt(pos:uint):int {
        var oldPos:uint = position;
        position = pos;
        var b:int = get();
        position = oldPos;
        return b;
    }

    public function getBoolean():Boolean {
        return array.readBoolean();
    }

    public function getBooleanAt(pos:uint):Boolean {
        var oldPos:uint = position;
        position = pos;
        var b:Boolean = getBoolean();
        position = oldPos;
        return b;
    }

    public function getBytes(length:uint):ByteArray {
        var b:ByteArray = new ByteArray;

        if (length > 0) {
            array.readBytes(b, 0, length);
        }
        return b;
    }

    public function getBytesAt(pos:uint, length:uint):ByteArray {
        var p:uint = position;
        position = pos;
        var b:ByteArray = getBytes(length);
        position = p;
        return b;
    }

    public function getInt():int {
        return array.readInt();
    }

    public function getIntAt(pos:uint):int {
        var oldPos:uint = position;
        position = pos;
        var i:int = getInt();
        position = oldPos;
        return i;
    }

    public function getFloat():Number {
        return array.readFloat();
    }

    public function getFloatAt(pos:uint):Number {
        var oldPos:uint = position;
        position = pos;
        var i:Number = getFloat();
        position = oldPos;
        return i;
    }

    public function getDouble():Number {
        return array.readDouble();
    }

    public function getDoubleAt(pos:uint):Number {
        var oldPos:uint = position;
        position = pos;
        var i:Number = getDouble();
        position = oldPos;
        return i;
    }

    public function getLong():Number {
        var a1:int, a2:int;

        if (isBigEndian) {
            a1 = getInt();
            a2 = getInt();
        }
        else {
            a2 = getInt();
            a1 = getInt();
        }

        return a1 << 32 | a2;
    }

    public function getLongAt(pos:uint):Number {
        var p:uint = position;
        position = pos;
        var n:Number = getLong();
        position = p;
        return n;
    }

    public function getObject():Object {
        return array.readObject();
    }

    public function getObjectAt(pos:uint):Object {
        var p:uint = position;
        position = pos;
        var o:Object = getObject();
        position = p;
        return o;
    }

    public function getString(length:uint = 0, charset:String = 'utf-8'):String {
        if (!length) {
            length = remaining;
        }
        return _array.readMultiByte(length, charset);
    }

    public function getPrefixString(prefixLength:uint = 2, charset:String = 'utf-8'):String {
        var l:uint = 0;

        switch (prefixLength) {
            case 4:
                l = getUnsignedInt();
                break;
            case 1:
                l = getUnsigned();
                break;
            case 2:
                if (charset.toLowerCase() == 'utf-8')
                    return array.readUTF();
                else
                    l = getUnsignedShort();
                break;
        }

        if (l > 0) {
            if (charset.toLowerCase() == 'utf-8')
                return array.readUTFBytes(l);
            else {
                return array.readMultiByte(l, charset);
            }
        }

        return null;
    }

    public function getPrefixStringAt(pos:uint, prefixLength:uint = 2, charset:String =
            "utf-8"):String {
        var p:uint = position;
        position = pos;
        var s:String = getPrefixString(prefixLength, charset);
        position = p;
        return s;
    }

    public function getShort():int {
        return array.readShort();
    }

    public function getShortAt(pos:uint):int {
        var oldPos:uint = position;
        position = pos;
        var s:int = getShort();
        position = oldPos;
        return s;
    }

    public function getUnsigned():int {
        return array.readUnsignedByte();
    }

    public function getUnsignedAt(pos:uint):int {
        var p:uint = position;
        position = pos;
        var u:int = getUnsigned();
        position = p;
        return u;
    }

    public function getUnsignedInt():uint {
        return array.readUnsignedInt();
    }

    public function getUnsignedIntAt(pos:uint):uint {
        var p:uint = position;
        position = pos;
        var ui:uint = getUnsignedInt();
        position = p;
        return ui;
    }

    public function getUnsignedShort():int {
        return array.readUnsignedShort();
    }

    public function getUnsignedShortAt(pos:uint):int {
        var p:uint = position;
        position = pos;
        var s:int = getUnsignedShort();
        position = p;
        return s;
    }

    public function mark():ByteBuffer {
        _mark = position;
        return this;
    }

    public function put(b:*):void {
        if (b is Number)
            array.writeByte(b);
        else if (b is ByteArray)
            array.writeBytes(b, 0, b.length);
        else if (b is Boolean)
            array.writeBoolean(b);
        else if (b is String)
            array.writeUTFBytes(b);
        else if (b is ByteBuffer) {
            const bb:ByteBuffer = ByteBuffer(b);
            array.writeBytes(bb.getBytes(bb.remaining));
        }
        else if (b is Object)
            array.writeObject(b);
    }

    public function putAt(pos:uint, b:*):void {
        var p:uint = position;
        position = pos;
        put(b);
        position = p;
    }

    public function putInt(value:uint):void {
        array.writeInt(value);
    }

    public function putIntAt(pos:uint, value:uint):void {
        var p:uint = position;
        position = pos;
        putInt(value);
        position = p;
    }

    public function putLong(value:Number):void {
        if (value) {
            var hex:String = value.toString(16);
            var pn:int = 16 - hex.length;
            var ps:String = '';

            for (var i:int = 0; i < pn; i++) {
                ps += '0';
            }

            hex = ps + hex;

            i = 0;

            for (var n:int = hex.length; i < n; i += 2) {
                var c:String = hex.charAt(i) + hex.charAt(i + 1);
                array.writeByte(parseInt(c, 16));
            }
        }
    }

    public function putLongAt(pos:uint, value:Number):void {
        var p:uint = position;
        position = pos;
        putLong(value);
        position = p;
    }

    public function putPrefixString(value:String, prefixLength:uint = 2, charset:String =
            'utf-8'):void {
        const b:ByteArray = new ByteArray;
        b.endian = array.endian;

        if (value)
            b.writeUTFBytes(value);

        const count:uint = b.length;

        switch (prefixLength) {
            case 1:
                put(count);
                break;
            case 2:
                putShort(count);
                break;
            case 4:
                putInt(count);
                break;
        }

        if (count > 0)
            array.writeUTFBytes(value);
    }

    public function putPrefixStringAt(value:String, pos:uint, prefixLength:uint =
            2, charset:String = 'utf-8'):void {
        var p:uint = position;
        position = pos;
        putPrefixString(value, prefixLength, charset);
        position = p;
    }

    public function putShort(value:int):void {
        array.writeShort(value);
    }

    public function putShortAt(pos:uint, value:int):void {
        var p:uint = position;
        position = pos;
        putShort(value);
        position = p;
    }

    public function putDouble(value:Number):void {
        array.writeDouble(value);
    }

    public function putDoubleAt(pos:uint, value:Number):void {
        var p:uint = position;
        position = pos;
        putDouble(value);
        position = p;
    }

    public function putFloat(value:Number):void {
        array.writeFloat(value);
    }

    public function putFloatAt(pos:uint, value:Number):void {
        var p:uint = position;
        position = pos;
        putFloat(value);
        position = p;
    }

    public function putString(value:String, charSet:String = 'utf-8'):void {
        array.writeMultiByte(value, charSet);
    }

    public function putStringAt(pos:uint, value:String, charSet:String = 'utf-8'):void {
        var p:uint = position;
        position = pos;
        array.writeMultiByte(value, charSet);
        position = p;
    }

    public function reset():ByteBuffer {
        if (_mark >= 0) {
            position = markValue;
        }
        return this;
    }

    public function slice():ByteBuffer {
        const b:ByteBuffer = new ByteBuffer;
        const pos:uint = position;
        b.array.writeBytes(array, position, limit - position);
        b.position = 0;
        position = pos;
        return b;
    }

    public function toString(limit:uint = 25):String {
        return "ByteBuffer [pos=" + position + ", lim=" + limit + ", hexdump=" +
                toHexString(array, limit) + "]";
    }
}
}
// vim:ft=actionscript
