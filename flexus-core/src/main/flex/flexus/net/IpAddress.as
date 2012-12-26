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

package flexus.net
{

import flash.utils.ByteArray;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class IpAddress
{
	//----------------------------------
	// IP_REGEXP 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const IP_REGEXP:RegExp = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;

	//--------------------------------------------------------------------------
	//
	//  Class methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param value
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public function bytes2IpStr(value:ByteArray):String
	{
		var str:String = '';
		str += value.readUnsignedByte() + '.';
		str += value.readUnsignedByte() + '.';
		str += value.readUnsignedByte() + '.';
		str += value.readUnsignedByte();
		value.position = 0;
		return str;
	}

	/**
	 *
	 *  @param value
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public function bytes2Long(value:ByteArray):Number
	{
		if (value && value.length >= 4)
		{
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
	 *
	 *  @param value
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public function isValid(value:String):Boolean
	{
		return IP_REGEXP.test(value);
	}

	/**
	 *
	 *  @param value
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public function long2Bytes(value:Number):ByteArray
	{
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

	/**
	 *
	 *  @param value
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public function toBytes(value:String):ByteArray
	{
		var b:ByteArray = new ByteArray;

		if (isValid(value))
		{
			var matches:Array = value.match(IP_REGEXP);

			if (matches.length == 5)
			{
				for (var i:int = 1, c:int = 5; i < c; i++)
				{
					var num:int = parseInt(matches[i]);
					b.writeByte(num);
				}
			}
			b.position = 0;
		}
		return b;
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
	public function IpAddress(value:* = null)
	{
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

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// bytes 
	//----------------------------------

	private var _bytes:ByteArray;

	/**
	 *  Retrieves the ip address as the byte array.
	 *
	 *  @return ip address
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get bytes():ByteArray
	{
		return _bytes;
	}

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
	public function toNumber():Number
	{
		return bytes2Long(bytes);
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
	public function toString():String
	{
		return bytes2IpStr(bytes);
	}
}
}
