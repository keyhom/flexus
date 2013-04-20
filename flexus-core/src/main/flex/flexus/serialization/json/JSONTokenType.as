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
