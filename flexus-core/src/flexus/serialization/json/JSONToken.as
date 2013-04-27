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

public class JSONToken
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 * Creates a new JSONToken with a specific token type and value.
	 *
	 * @param type The JSONTokenType of the token
	 * @param value The value of the token
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	public function JSONToken(type:int = -1 /* JSONTokenType.UNKNOWN */, value:Object =
							  null)
	{
		_type = type;
		_value = value;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// type 
	//----------------------------------

	private var _type:int;

	/**
	 * Returns the type of the token.
	 *
	 * @see com.adobe.serialization.json.JSONTokenType
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	public function get type():int
	{
		return _type;
	}

	/**
	 * Sets the type of the token.
	 *
	 * @see com.adobe.serialization.json.JSONTokenType
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	public function set type(value:int):void
	{
		_type = value;
	}

	//----------------------------------
	// value 
	//----------------------------------

	private var _value:Object;

	/**
	 * Gets the value of the token
	 *
	 * @see com.adobe.serialization.json.JSONTokenType
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	public function get value():Object
	{
		return _value;
	}

	/**
	 * Sets the value of the token
	 *
	 * @see com.adobe.serialization.json.JSONTokenType
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	public function set value(v:Object):void
	{
		_value = v;
	}
}

}
