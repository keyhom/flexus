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

package flexus.utils
{

import flash.utils.Endian;

/**
 * Contains reusable methods for operations pertaining
 * to int values.
 */
public class IntUtil
{

	//--------------------------------------------------------------------------
	//
	//  Class properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// hexChars 
	//----------------------------------

	/** String for quick lookup of a hex character based on index */
	static private var hexChars:String = "0123456789abcdef";

	//--------------------------------------------------------------------------
	//
	//  Class methods 
	//
	//--------------------------------------------------------------------------

	/**
	 * Rotates x left n bits
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	static public function rol(x:int, n:int):int
	{
		return (x << n) | (x >>> (32 - n));
	}

	/**
	 * Rotates x right n bits
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	static public function ror(x:int, n:int):uint
	{
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
	 *		hex representation of n ( minus the leading "0x" )
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	static public function toHex(n:int, bigEndian:Boolean = false):String
	{
		var s:String = "";

		if (bigEndian)
		{
			for (var i:int = 0; i < 4; i++)
			{
				s += hexChars.charAt((n >> ((3 - i) * 8 + 4)) & 0xF) + hexChars.
					charAt((n >> ((3 - i) * 8)) & 0xF);
			}
		}
		else
		{
			for (var x:int = 0; x < 4; x++)
			{
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
