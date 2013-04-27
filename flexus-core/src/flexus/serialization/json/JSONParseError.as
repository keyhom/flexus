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
