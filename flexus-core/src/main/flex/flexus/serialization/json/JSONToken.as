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
