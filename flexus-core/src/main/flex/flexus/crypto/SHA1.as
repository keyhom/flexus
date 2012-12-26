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

package flexus.crypto
{

import flash.utils.ByteArray;
import mx.utils.Base64Encoder;
import flexus.utils.IntUtil;

/**
 *  US Secure Hash Algorithm 1 (SHA1)
 *
 *  Implementation based on algorithm description at
 *  http://www.faqs.org/rfcs/rfc3174.html
 */
public class SHA1
{

	//--------------------------------------------------------------------------
	//
	//  Class properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// digest 
	//----------------------------------

	static public var digest:ByteArray;

	//--------------------------------------------------------------------------
	//
	//  Class methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Performs the SHA1 hash algorithm on a string.
	 *
	 *  @param s		The string to hash
	 *  @return			A string containing the hash value of s
	 *  @langversion	ActionScript 3.0
	 *  @playerversion	9.0
	 *  @tiptext
	 */
	static public function hash(s:String):String
	{
		var blocks:Array = createBlocksFromString(s);
		var byteArray:ByteArray = hashBlocks(blocks);

		return IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.
																		readInt(),
																		true) +
			IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.
																	 readInt(),
																	 true) +
			IntUtil.toHex(byteArray.readInt(), true);
	}

	/**
	 *  Performs the SHA1 hash algorithm on a ByteArray.
	 *
	 *  @param data		The ByteArray data to hash
	 *  @return			A string containing the hash value of data
	 *  @langversion	ActionScript 3.0
	 *  @playerversion	9.0
	 */
	static public function hashBytes(data:ByteArray):String
	{
		var blocks:Array = SHA1.createBlocksFromByteArray(data);
		var byteArray:ByteArray = hashBlocks(blocks);

		return IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.
																		readInt(),
																		true) +
			IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.
																	 readInt(),
																	 true) +
			IntUtil.toHex(byteArray.readInt(), true);
	}

	/**
	 *  Performs the SHA1 hash algorithm on a string, then does
	 *  Base64 encoding on the result.
	 *
	 *  @param s		The string to hash
	 *  @return			The base64 encoded hash value of s
	 *  @langversion	ActionScript 3.0
	 *  @playerversion	9.0
	 *  @tiptext
	 */
	static public function hashToBase64(s:String):String
	{
		var blocks:Array = SHA1.createBlocksFromString(s);
		var byteArray:ByteArray = hashBlocks(blocks);

		// ByteArray.toString() returns the contents as a UTF-8 string,
		// which we can't use because certain byte sequences might trigger
		// a UTF-8 conversion.  Instead, we convert the bytes to characters
		// one by one.
		var charsInByteArray:String = "";
		byteArray.position = 0;
		for (var j:int = 0; j < byteArray.length; j++)
		{
			var byte:uint = byteArray.readUnsignedByte();
			charsInByteArray += String.fromCharCode(byte);
		}

		var encoder:Base64Encoder = new Base64Encoder();
		encoder.encode(charsInByteArray);
		return encoder.flush();
	}

	/**
	 *  Converts a ByteArray to a sequence of 16-word blocks
	 *  that we'll do the processing on.  Appends padding
	 *  and length in the process.
	 *
	 *  @param data		The data to split into blocks
	 *  @return			An array containing the blocks into which data was split
	 */
	static private function createBlocksFromByteArray(data:ByteArray):Array
	{
		var oldPosition:int = data.position;
		data.position = 0;

		var blocks:Array = new Array();
		var len:int = data.length * 8;
		var mask:int = 0xFF; // ignore hi byte of characters > 0xFF
		for (var i:int = 0; i < len; i += 8)
		{
			blocks[i >> 5] |= (data.readByte() & mask) << (24 - i % 32);
		}

		// append padding and length
		blocks[len >> 5] |= 0x80 << (24 - len % 32);
		blocks[(((len + 64) >> 9) << 4) + 15] = len;

		data.position = oldPosition;

		return blocks;
	}

	/**
	 *  Converts a string to a sequence of 16-word blocks
	 *  that we'll do the processing on.  Appends padding
	 *  and length in the process.
	 *
	 *  @param s	The string to split into blocks
	 *  @return		An array containing the blocks that s was split into.
	 */
	static private function createBlocksFromString(s:String):Array
	{
		var blocks:Array = new Array();
		var len:int = s.length * 8;
		var mask:int = 0xFF; // ignore hi byte of characters > 0xFF
		for (var i:int = 0; i < len; i += 8)
		{
			blocks[i >> 5] |= (s.charCodeAt(i / 8) & mask) << (24 - i % 32);
		}

		// append padding and length
		blocks[len >> 5] |= 0x80 << (24 - len % 32);
		blocks[(((len + 64) >> 9) << 4) + 15] = len;
		return blocks;
	}

	static private function hashBlocks(blocks:Array):ByteArray
	{
		// initialize the h's
		var h0:int = 0x67452301;
		var h1:int = 0xefcdab89;
		var h2:int = 0x98badcfe;
		var h3:int = 0x10325476;
		var h4:int = 0xc3d2e1f0;

		var len:int = blocks.length;
		var w:Array = new Array(80);
		var temp:int;

		// loop over all of the blocks
		for (var i:int = 0; i < len; i += 16)
		{

			// 6.1.c
			var a:int = h0;
			var b:int = h1;
			var c:int = h2;
			var d:int = h3;
			var e:int = h4;

			// 80 steps to process each block
			var t:int;
			for (t = 0; t < 20; t++)
			{

				if (t < 16)
				{
					// 6.1.a
					w[t] = blocks[i + t];
				}
				else
				{
					// 6.1.b
					temp = w[t - 3] ^ w[t - 8] ^ w[t - 14] ^ w[t - 16];
					w[t] = (temp << 1) | (temp >>> 31)
				}

				// 6.1.d
				temp = ((a << 5) | (a >>> 27)) + ((b & c) | (~b & d)) + e + int(w[t]) +
					0x5a827999;

				e = d;
				d = c;
				c = (b << 30) | (b >>> 2);
				b = a;
				a = temp;
			}
			for (; t < 40; t++)
			{
				// 6.1.b
				temp = w[t - 3] ^ w[t - 8] ^ w[t - 14] ^ w[t - 16];
				w[t] = (temp << 1) | (temp >>> 31)

				// 6.1.d
				temp = ((a << 5) | (a >>> 27)) + (b ^ c ^ d) + e + int(w[t]) +
					0x6ed9eba1;

				e = d;
				d = c;
				c = (b << 30) | (b >>> 2);
				b = a;
				a = temp;
			}
			for (; t < 60; t++)
			{
				// 6.1.b
				temp = w[t - 3] ^ w[t - 8] ^ w[t - 14] ^ w[t - 16];
				w[t] = (temp << 1) | (temp >>> 31)

				// 6.1.d
				temp = ((a << 5) | (a >>> 27)) + ((b & c) | (b & d) | (c & d)) +
					e + int(w[t]) + 0x8f1bbcdc;

				e = d;
				d = c;
				c = (b << 30) | (b >>> 2);
				b = a;
				a = temp;
			}
			for (; t < 80; t++)
			{
				// 6.1.b
				temp = w[t - 3] ^ w[t - 8] ^ w[t - 14] ^ w[t - 16];
				w[t] = (temp << 1) | (temp >>> 31)

				// 6.1.d
				temp = ((a << 5) | (a >>> 27)) + (b ^ c ^ d) + e + int(w[t]) +
					0xca62c1d6;

				e = d;
				d = c;
				c = (b << 30) | (b >>> 2);
				b = a;
				a = temp;
			}

			// 6.1.e
			h0 += a;
			h1 += b;
			h2 += c;
			h3 += d;
			h4 += e;
		}

		var byteArray:ByteArray = new ByteArray();
		byteArray.writeInt(h0);
		byteArray.writeInt(h1);
		byteArray.writeInt(h2);
		byteArray.writeInt(h3);
		byteArray.writeInt(h4);
		byteArray.position = 0;

		digest = new ByteArray();
		digest.writeBytes(byteArray);
		digest.position = 0;
		return byteArray;
	}
}
}
