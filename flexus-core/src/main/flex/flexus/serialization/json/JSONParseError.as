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
 *
 *
 */
public class JSONParseError extends Error
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 * Constructs a new JSONParseError.
	 *
	 * @param message The error message that occured during parsing
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	public function JSONParseError(message:String = "", location:int = 0, text:String =
								   "")
	{
		super(message);
		name = "JSONParseError";
		_location = location;
		_text = text;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// location 
	//----------------------------------

	/** The location in the string where the error occurred */
	private var _location:int;

	/**
	 * Provides read-only access to the location variable.
	 *
	 * @return The location in the string where the error occurred
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	public function get location():int
	{
		return _location;
	}

	//----------------------------------
	// text 
	//----------------------------------

	/** The string in which the parse error occurred */
	private var _text:String;

	/**
	 * Provides read-only access to the text variable.
	 *
	 * @return The string in which the error occurred
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	public function get text():String
	{
		return _text;
	}
}

}
