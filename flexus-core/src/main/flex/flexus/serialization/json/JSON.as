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
