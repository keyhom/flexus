//------------------------------------------------------------------------------
//
//   PureArt Archetype. Make any work easier. 
// 
//   Copyright (C) 2011  pureart.org 
// 
//   This program is free software: you can redistribute it and/or modify 
//   it under the terms of the GNU General Public License as published by 
//   the Free Software Foundation, either version 3 of the License, or 
//   (at your option) any later version. 
// 
//   This program is distributed in the hope that it will be useful, 
//   but WITHOUT ANY WARRANTY; without even the implied warranty of 
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
//   GNU General Public License for more details. 
// 
//   You should have received a copy of the GNU General Public License 
//   along with this program.  If not, see <http://www.gnu.org/licenses/>. 
//
//------------------------------------------------------------------------------

package flexus.io
{

import flash.utils.ByteArray;
import flash.utils.Endian;

import flexus.utils.IntUtil;

/**
 *  The abstract buffer with byte array.
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ByteBuffer
{

	//--------------------------------------------------------------------------
	//
	//  Class methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param array
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public function wrap(array:ByteArray):ByteBuffer
	{
		const buf:ByteBuffer = new ByteBuffer;
		buf._array = array;
		return buf;
	}

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function ByteBuffer()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// array 
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the array property.
	 */
	private var _array:ByteArray = new ByteArray;

	/**
	 *  Byte array as native implementation.
	 *
	 *  @see flash.utils.ByteArray
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get array():ByteArray
	{
		return _array;
	}

	//----------------------------------
	// hasRemaining 
	//----------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get hasRemaining():Boolean
	{
		return remaining > 0;
	}

	//----------------------------------
	// isBigEndian 
	//----------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get isBigEndian():Boolean
	{
		return array.endian == Endian.BIG_ENDIAN;
	}

	//----------------------------------
	// limit 
	//----------------------------------

	/**
	 *  The current limit index of the <code>Buffer</code>.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get limit():uint
	{
		return array.length;
	}

	/**
	 *  @private
	 */
	public function set limit(value:uint):void
	{
		array.length = value;
	}

	//----------------------------------
	// markValue 
	//----------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get markValue():int
	{
		return _mark;
	}

	//----------------------------------
	// order 
	//----------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get order():String
	{
		return array.endian;
	}

	/**
	 *  @private
	 */
	public function set order(value:String):void
	{
		if (!value)
			value = Endian.BIG_ENDIAN;
		array.endian = value;
	}

	//----------------------------------
	// position 
	//----------------------------------

	/**
	 *  The current position index of the <code>Buffer</code>.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get position():uint
	{
		return array.position;
	}

	/**
	 *  @private
	 */
	public function set position(value:uint):void
	{
		array.position = value;
	}

	//----------------------------------
	// remaining 
	//----------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get remaining():uint
	{
		return limit - position;
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden properties
	//
	//--------------------------------------------------------------------------

	private var _mark:int = -1;

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function clear():ByteBuffer
	{
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
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion Flex 3
	 */
	public function free():void {
		_array = null;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function compact():ByteBuffer
	{
		const bytes:ByteArray = new ByteArray;
		bytes.endian = array.endian;
		bytes.writeBytes(array, position, remaining);
		_array.clear();
		_array = bytes;
		return this;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function flip():ByteBuffer
	{
		this.limit = this.position;
		this.position = 0;
		return this;
	}

	/*
	 *  For reader
	 */

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get():int
	{
		return array.readByte();
	}

	/**
	 *
	 *  @param pos
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getAt(pos:uint):int
	{
		var oldPos:uint = position;
		position = pos;
		var b:int = get();
		position = oldPos;
		return b;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getBoolean():Boolean
	{
		return array.readBoolean();
	}

	/**
	 *
	 *  @param pos
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getBooleanAt(pos:uint):Boolean
	{
		var oldPos:uint = position;
		position = pos;
		var b:Boolean = getBoolean();
		position = oldPos;
		return b;
	}

	/**
	 *
	 *  @param length
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getBytes(length:uint):ByteArray
	{
		var b:ByteArray = new ByteArray;

		if (length > 0)
		{
			array.readBytes(b, 0, length);
		}
		return b;
	}

	/**
	 *
	 *  @param pos
	 *  @param length
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getBytesAt(pos:uint, length:uint):ByteArray
	{
		var p:uint = position;
		position = pos;
		var b:ByteArray = getBytes(length);
		position = p;
		return b;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getInt():int
	{
		return array.readInt();
	}

	/**
	 *
	 *  @param pos
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getIntAt(pos:uint):int
	{
		var oldPos:uint = position;
		position = pos;
		var i:int = getInt();
		position = oldPos;
		return i;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getFloat():Number
	{
		return array.readFloat();
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getFloatAt(pos:uint):Number
	{
		var oldPos:uint = position;
		position = pos;
		var i:Number = getFloat();
		position = oldPos;
		return i;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getDouble():Number
	{
		return array.readDouble();
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getDoubleAt(pos:uint):Number
	{
		var oldPos:uint = position;
		position = pos;
		var i:Number = getDouble();
		position= oldPos;
		return i;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getLong():Number
	{
		var a1:int, a2:int;

		if (isBigEndian)
		{
			a1 = getInt();
			a2 = getInt();
		}
		else
		{
			a2 = getInt();
			a1 = getInt();
		}

		return a1 << 32 | a2;
	}

	/**
	 *
	 *  @param pos
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getLongAt(pos:uint):Number
	{
		var p:uint = position;
		position = pos;
		var n:Number = getLong();
		position = p;
		return n;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getObject():Object
	{
		return array.readObject();
	}

	/**
	 *
	 *  @param pos
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getObjectAt(pos:uint):Object
	{
		var p:uint = position;
		position = pos;
		var o:Object = getObject();
		position = p;
		return o;
	}

	/**
	 *
	 *  @param prefixLength
	 *  @param charset
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getPrefixString(prefixLength:uint = 2, charset:String = 'utf-8'):String
	{
		var l:uint = 0;

		switch (prefixLength)
		{
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

		if (l > 0)
		{
			if (charset.toLowerCase() == 'utf-8')
				return array.readUTFBytes(l);
			else
			{
				return array.readMultiByte(l, charset);
			}
		}

		return null;
	}

	/**
	 *
	 *  @param pos
	 *  @param prefixLength
	 *  @param charset
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getPrefixStringAt(pos:uint, prefixLength:uint = 2, charset:String =
									  "utf-8"):String
	{
		var p:uint = position;
		position = pos;
		var s:String = getPrefixString(prefixLength, charset);
		position = p;
		return s;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getShort():int
	{
		return array.readShort();
	}

	/**
	 *
	 *  @param pos
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getShortAt(pos:uint):int
	{
		var oldPos:uint = position;
		position = pos;
		var s:int = getShort();
		position = oldPos;
		return s;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getUnsigned():int
	{
		return array.readUnsignedByte();
	}

	/**
	 *
	 *  @param pos
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getUnsignedAt(pos:uint):int
	{
		var p:uint = position;
		position = pos;
		var u:int = getUnsigned();
		position = p;
		return u;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getUnsignedInt():uint
	{
		return array.readUnsignedInt();
	}

	/**
	 *
	 *  @param pos
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getUnsignedIntAt(pos:uint):uint
	{
		var p:uint = position;
		position = pos;
		var ui:uint = getUnsignedInt();
		position = p;
		return ui;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getUnsignedShort():int
	{
		return array.readUnsignedShort();
	}

	/**
	 *
	 *  @param pos
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getUnsignedShortAt(pos:uint):int
	{
		var p:uint = position;
		position = pos;
		var s:int = getUnsignedShort();
		position = p;
		return s;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function mark():ByteBuffer
	{
		_mark = position;
		return this;
	}


	/*
	 *  For writer
	 */

	/**
	 *
	 *  @param byte
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function put(byte:*):void
	{
		if (byte is Number)
			array.writeByte(byte);
		else if (byte is ByteArray)
			array.writeBytes(byte, 0, byte.length);
		else if (byte is Boolean)
			array.writeBoolean(byte);
		else if (byte is String)
			array.writeUTFBytes(byte);
		else if (byte is ByteBuffer) {
			const b:ByteBuffer = ByteBuffer(byte);
			array.writeBytes(b.getBytes(b.remaining));
		}
		else if (byte is Object)
			array.writeObject(byte);
	}

	/**
	 *
	 *  @param pos
	 *  @param byte
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function putAt(pos:uint, byte:*):void
	{
		var p:uint = position;
		position = pos;
		put(byte);
		position = p;
	}

	/**
	 *
	 *  @param value
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function putInt(value:uint):void
	{
		array.writeInt(value);
	}

	/**
	 *
	 *  @param pos
	 *  @param value
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function putIntAt(pos:uint, value:uint):void
	{
		var p:uint = position;
		position = pos;
		putInt(value);
		position = p;
	}

	/**
	 *
	 *  @param value
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function putLong(value:Number):void
	{
		if (value)
		{
			var hex:String = value.toString(16);
			var pn:int = 16 - hex.length;
			var ps:String = '';

			for (var i:int = 0; i < pn; i++)
			{
				ps += '0';
			}

			hex = ps + hex;

			i = 0;

			for (var n:int = hex.length; i < n; i += 2)
			{
				var c:String = hex.charAt(i) + hex.charAt(i + 1);
				array.writeByte(parseInt(c, 16));
			}
		}
	}

	/**
	 *
	 *  @param pos
	 *  @param value
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function putLongAt(pos:uint, value:Number):void
	{
		var p:uint = position;
		position = pos;
		putLong(value);
		position = p;
	}

	/**
	 *
	 *  @param value
	 *  @param prefixLength
	 *  @param charset
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function putPrefixString(value:String, prefixLength:uint = 2, charset:String =
									'utf-8'):void
	{
		var b:ByteArray = new ByteArray;
		b.endian = array.endian;

		if(value)
			b.writeUTFBytes(value);

		var count:uint = b.length;

		switch (prefixLength)
		{
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

	/**
	 *
	 *  @param value
	 *  @param pos
	 *  @param prefixLength
	 *  @param charset
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function putPrefixStringAt(value:String, pos:uint, prefixLength:uint =
									  2, charset:String = 'utf-8'):void
	{
		var p:uint = position;
		position = pos;
		putPrefixString(value, prefixLength, charset);
		position = p;
	}

	/**
	 *
	 *  @param short
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function putShort(short:int):void
	{
		array.writeShort(short);
	}

	/**
	 *
	 *  @param pos
	 *  @param short
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function putShortAt(pos:uint, short:int):void
	{
		var p:uint = position;
		position = pos;
		putShort(short);
		position = p;
	}

	/**
	 *
	 *  @param value
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function putDouble(value:Number):void
	{
		array.writeDouble(value);
	}

	/**
	 *  @param pos
	 *  @param value
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function putDoubleAt(pos:uint, value:Number):void
	{
		var p:uint = position;
		position = pos;
		putDouble(value);
		position = p;
	}

	/**
	 *  @param value
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function putFloat(value:Number):void
	{
		array.writeFloat(value);
	}

	/**
	 *  @param pos
	 *  @param value
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function putFloatAt(pos:uint, value:Number):void
	{
		var p:uint = position;
		position = pos;
		putFloat(value);
		position = p;
	}

	/**
	 *
	 *  @param value
	 *  @param charSet
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function putString(value:String, charSet:String = 'utf-8'):void
	{
		array.writeMultiByte(value, charSet);
	}

	/**
	 *
	 *  @param pos
	 *  @param value
	 *  @param charSet
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function putStringAt(pos:uint, value:String, charSet:String = 'utf-8'):void
	{
		var p:uint = position;
		position = pos;
		array.writeMultiByte(value, charSet);
		position = p;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function reset():ByteBuffer
	{
		if (_mark >= 0)
		{
			position = markValue;
		}
		return this;
	}

	public function slice():ByteBuffer
	{
		const b:ByteBuffer = new ByteBuffer;
		const pos:uint = position;
		b.array.writeBytes(array, position, limit - position);
		b.position = 0;
		position = pos;
		return b;
	}

	public function toString(limit:uint = 25):String
	{
		return "ByteBuffer [pos=" + position + ", lim=" + limit + ", hexdump=" +
			toHexString(array, limit) + "]";
	}

	static public function toHexString(bytes:ByteArray, limit:uint = 25):String
	{
		if (bytes)
		{
			var s:String = '';

			var pos:uint = bytes.position;

			var len:uint = Math.min(bytes.length, limit);

			for (var i:int = 0; i < len; i++)
			{
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
}
}

