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
import flash.utils.Endian;
import flash.utils.describeType;

/**
 * Keyed-Hashing for Message Authentication
 * Implementation based on algorithm description at
 * http://www.faqs.org/rfcs/rfc2104.html
 */
public class HMAC
{

	//--------------------------------------------------------------------------
	//
	//  Class methods 
	//
	//--------------------------------------------------------------------------

	/**
	 * Performs the HMAC hash algorithm using byte arrays.
	 *
	 * @param secret The secret key
	 * @param message The message to hash
	 * @param algorithm Hash object to use
	 * @return A string containing the hash value of message
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 8.5
	 * @tiptext
	 */
	static public function hash(secret:String, message:String, algorithm:Object =
								null):String
	{
		var text:ByteArray = new ByteArray();
		var k_secret:ByteArray = new ByteArray();

		text.writeUTFBytes(message);
		k_secret.writeUTFBytes(secret);

		return hashBytes(k_secret, text, algorithm);
	}

	/**
	 * Performs the HMAC hash algorithm using string.
	 *
	 * @param secret The secret key
	 * @param message The message to hash
	 * @param algorithm Hash object to use
	 * @return A string containing the hash value of message
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 8.5
	 * @tiptext
	 */
	static public function hashBytes(secret:ByteArray, message:ByteArray, algorithm:Object =
									 null):String
	{
		var ipad:ByteArray = new ByteArray();
		var opad:ByteArray = new ByteArray();
		var endian:String = Endian.BIG_ENDIAN;

		if (algorithm == null)
		{
			algorithm = MD5;
		}

		if (describeType(algorithm).@name.toString() == "com.adobe.crypto::MD5")
		{
			endian = Endian.LITTLE_ENDIAN;
		}

		if (secret.length > 64)
		{
			algorithm.hashBytes(secret);
			secret = new ByteArray();
			secret.endian = endian;

			while (algorithm.digest.bytesAvailable != 0)
			{
				secret.writeInt(algorithm.digest.readInt());
			}
		}

		secret.length = 64
		secret.position = 0;
		for (var x:int = 0; x < 64; x++)
		{
			var byte:int = secret.readByte();
			ipad.writeByte(0x36 ^ byte);
			opad.writeByte(0x5c ^ byte);
		}

		ipad.writeBytes(message);
		algorithm.hashBytes(ipad);
		var tmp:ByteArray = new ByteArray();
		tmp.endian = endian;

		while (algorithm.digest.bytesAvailable != 0)
		{
			tmp.writeInt(algorithm.digest.readInt());
		}
		tmp.position = 0;

		while (tmp.bytesAvailable != 0)
		{
			opad.writeByte(tmp.readUnsignedByte());
		}
		return algorithm.hashBytes(opad);
	}
}

}
