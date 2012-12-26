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
 * Class containing constant values for the different types
 * of tokens in a JSON encoded string.
 */
public class JSONTokenType
{

	//--------------------------------------------------------------------------
	//
	//  Class properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// COLON 
	//----------------------------------

	static public const COLON:int = 6;

	//----------------------------------
	// COMMA 
	//----------------------------------

	static public const COMMA:int = 0;

	//----------------------------------
	// FALSE 
	//----------------------------------

	static public const FALSE:int = 8;

	//----------------------------------
	// LEFT_BRACE 
	//----------------------------------

	static public const LEFT_BRACE:int = 1;

	//----------------------------------
	// LEFT_BRACKET 
	//----------------------------------

	static public const LEFT_BRACKET:int = 3;

	//----------------------------------
	// NAN 
	//----------------------------------

	static public const NAN:int = 12;

	//----------------------------------
	// NULL 
	//----------------------------------

	static public const NULL:int = 9;

	//----------------------------------
	// NUMBER 
	//----------------------------------

	static public const NUMBER:int = 11;

	//----------------------------------
	// RIGHT_BRACE 
	//----------------------------------

	static public const RIGHT_BRACE:int = 2;

	//----------------------------------
	// RIGHT_BRACKET 
	//----------------------------------

	static public const RIGHT_BRACKET:int = 4;

	//----------------------------------
	// STRING 
	//----------------------------------

	static public const STRING:int = 10;

	//----------------------------------
	// TRUE 
	//----------------------------------

	static public const TRUE:int = 7;

	//----------------------------------
	// UNKNOWN 
	//----------------------------------

	static public const UNKNOWN:int = -1;
}

}
