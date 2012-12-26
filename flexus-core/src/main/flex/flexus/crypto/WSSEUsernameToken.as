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

import mx.formatters.DateFormatter;
import mx.utils.Base64Encoder;

/**
 * Web Services Security Username Token
 *
 * Implementation based on algorithm description at
 * http://www.oasis-open.org/committees/wss/documents/WSS-Username-02-0223-merged.pdf
 */
public class WSSEUsernameToken
{

	//--------------------------------------------------------------------------
	//
	//  Class methods 
	//
	//--------------------------------------------------------------------------

	/**
	 * Generates a WSSE Username Token.
	 *
	 * @param username The username
	 * @param password The password
	 * @param nonce A cryptographically random nonce (if null, the nonce
	 * will be generated)
	 * @param timestamp The time at which the token is generated (if null,
	 * the time will be set to the moment of execution)
	 * @return The generated token
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	static public function getUsernameToken(username:String, password:String,
											nonce:String = null, timestamp:Date =
											null):String
	{
		if (nonce == null)
		{
			nonce = generateNonce();
		}
		nonce = base64Encode(nonce);

		var created:String = generateTimestamp(timestamp);

		var password64:String = getBase64Digest(nonce, created, password);

		var token:String = new String("UsernameToken Username=\"");
		token += username + "\", " + "PasswordDigest=\"" + password64 + "\", " +
			"Nonce=\"" + nonce + "\", " + "Created=\"" + created + "\"";
		return token;
	}

	static internal function base64Encode(s:String):String
	{
		var encoder:Base64Encoder = new Base64Encoder();
		encoder.encode(s);
		return encoder.flush();
	}

	static internal function generateTimestamp(timestamp:Date):String
	{
		if (timestamp == null)
		{
			timestamp = new Date();
		}
		var dateFormatter:DateFormatter = new DateFormatter();
		dateFormatter.formatString = "YYYY-MM-DDTJJ:NN:SS"
		return dateFormatter.format(timestamp) + "Z";
	}

	static internal function getBase64Digest(nonce:String, created:String, password:String):String
	{
		return SHA1.hashToBase64(nonce + created + password);
	}

	static private function generateNonce():String
	{
		// Math.random returns a Number between 0 and 1.  We don't want our
		// nonce to contain invalid characters (e.g. the period) so we
		// strip them out before returning the result.
		var s:String =  Math.random().toString();
		return s.replace(".", "");
	}
}
}
