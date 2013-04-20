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

package flexus.serialization.json
{

/**
 * This class provides encoding and decoding of the JSON format.
 *
 * Example usage:
 * <code>
 * 		// create a JSON string from an internal object
 * 		JSON.encode( myObject );
 *
 *		// read a JSON string into an internal object
 *		var myObject:Object = JSON.decode( jsonString );
 *	</code>
 */
public class JSON
{

	//--------------------------------------------------------------------------
	//
	//  Class methods 
	//
	//--------------------------------------------------------------------------

	/**
	 * Decodes a JSON string into a native object.
	 *
	 * @param s The JSON string representing the object
	 * @param strict Flag indicating if the decoder should strictly adhere
	 * 		to the JSON standard or not.  The default of <code>true</code>
	 * 		throws errors if the format does not match the JSON syntax exactly.
	 * 		Pass <code>false</code> to allow for non-properly-formatted JSON
	 * 		strings to be decoded with more leniancy.
	 * @return A native object as specified by s
	 * @throw JSONParseError
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	static public function decode(s:String, strict:Boolean = true):*
	{
		return new JSONDecoder(s, strict).getValue();
	}

	/**
	 * Encodes a object into a JSON string.
	 *
	 * @param o The object to create a JSON string for
	 * @return the JSON string representing o
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	static public function encode(o:Object):String
	{
		return new JSONEncoder(o).getString();
	}
}

}
