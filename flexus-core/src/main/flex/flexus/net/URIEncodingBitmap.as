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
 * This class implements an efficient lookup table for URI
 * character escaping.  This class is only needed if you
 * create a derived class of URI to handle custom URI
 * syntax.  This class is used internally by URI.
 *
 * @langversion ActionScript 3.0
 * @playerversion Flash 9.0*
 */
public class URIEncodingBitmap extends ByteArray
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 * Constructor.  Creates an encoding bitmap using the given
	 * string of characters as the set of characters that need
	 * to be URI escaped.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 */
	public function URIEncodingBitmap(charsToEscape:String):void
	{
		var i:int;
		var data:ByteArray = new ByteArray();

		// Initialize our 128 bits (16 bytes) to zero
		for (i = 0; i < 16; i++)
			this.writeByte(0);

		data.writeUTFBytes(charsToEscape);
		data.position = 0;

		while (data.bytesAvailable)
		{
			var c:int = data.readByte();

			if (c > 0x7f)
				continue; // only escape low bytes

			var enc:int;
			this.position = (c >> 3);
			enc = this.readByte();
			enc |= 1 << (c & 0x7);
			this.position = (c >> 3);
			this.writeByte(enc);
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 * Based on the data table contained in this object, check
	 * if the given character should be escaped.
	 *
	 * @param char	the character to be escaped.  Only the first
	 * character in the string is used.  Any other characters
	 * are ignored.
	 *
	 * @return	the integer value of the raw UTF8 character.  For
	 * example, if '%' is given, the return value is 37 (0x25).
	 * If the character given does not need to be escaped, the
	 * return value is zero.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 */
	public function ShouldEscape(char:String):int
	{
		var data:ByteArray = new ByteArray();
		var c:int, mask:int;

		// write the character into a ByteArray so
		// we can pull it out as a raw byte value.
		data.writeUTFBytes(char);
		data.position = 0;
		c = data.readByte();

		if (c & 0x80)
		{
			// don't escape high byte characters.  It can make international
			// URI's unreadable.  We just want to escape characters that would
			// make URI syntax ambiguous.
			return 0;
		}
		else if ((c < 0x1f) || (c == 0x7f))
		{
			// control characters must be escaped.
			return c;
		}

		this.position = (c >> 3);
		mask = this.readByte();

		if (mask & (1 << (c & 0x7)))
		{
			// we need to escape this, return the numeric value
			// of the character
			return c;
		}
		else
		{
			return 0;
		}
	}
}
}
