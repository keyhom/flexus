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

public class JSONDecoder
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 * Constructs a new JSONDecoder to parse a JSON string
	 * into a native object.
	 *
	 * @param s The JSON string to be converted
	 *		into a native object
	 * @param strict Flag indicating if the JSON string needs to
	 * 		strictly match the JSON standard or not.
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	public function JSONDecoder(s:String, strict:Boolean)
	{
		this.strict = strict;
		tokenizer = new JSONTokenizer(s, strict);

		nextToken();
		value = parseValue();

		// Make sure the input stream is empty
		if (strict && nextToken() != null)
		{
			tokenizer.parseError("Unexpected characters left in input stream");
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// strict 
	//----------------------------------

	/**
	 * Flag indicating if the parser should be strict about the format
	 * of the JSON string it is attempting to decode.
	 */
	private var strict:Boolean;

	//----------------------------------
	// token 
	//----------------------------------

	/** The current token from the tokenizer */
	private var token:JSONToken;

	//----------------------------------
	// tokenizer 
	//----------------------------------

	/** The tokenizer designated to read the JSON string */
	private var tokenizer:JSONTokenizer;

	//----------------------------------
	// value 
	//----------------------------------

	/** The value that will get parsed from the JSON string */
	private var value:*;

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 * Gets the internal object that was created by parsing
	 * the JSON string passed to the constructor.
	 *
	 * @return The internal object representation of the JSON
	 * 		string that was passed to the constructor
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * @tiptext
	 */
	public function getValue():*
	{
		return value;
	}

	/**
	 * Returns the next token from the tokenzier reading
	 * the JSON string
	 */
	private function nextToken():JSONToken
	{
		return token = tokenizer.getNextToken();
	}

	/**
	 * Attempt to parse an array.
	 */
	private function parseArray():Array
	{
		// create an array internally that we're going to attempt
		// to parse from the tokenizer
		var a:Array = new Array();

		// grab the next token from the tokenizer to move
		// past the opening [
		nextToken();

		// check to see if we have an empty array
		if (token.type == JSONTokenType.RIGHT_BRACKET)
		{
			// we're done reading the array, so return it
			return a;
		}
		// in non-strict mode an empty array is also a comma
		// followed by a right bracket
		else if (!strict && token.type == JSONTokenType.COMMA)
		{
			// move past the comma
			nextToken();

			// check to see if we're reached the end of the array
			if (token.type == JSONTokenType.RIGHT_BRACKET)
			{
				return a;
			}
			else
			{
				tokenizer.parseError("Leading commas are not supported.  Expecting ']' but found " +
									 token.value);
			}
		}

		// deal with elements of the array, and use an "infinite"
		// loop because we could have any amount of elements
		while (true)
		{
			// read in the value and add it to the array
			a.push(parseValue());

			// after the value there should be a ] or a ,
			nextToken();

			if (token.type == JSONTokenType.RIGHT_BRACKET)
			{
				// we're done reading the array, so return it
				return a;
			}
			else if (token.type == JSONTokenType.COMMA)
			{
				// move past the comma and read another value
				nextToken();

				// Allow arrays to have a comma after the last element
				// if the decoder is not in strict mode
				if (!strict)
				{
					// Reached ",]" as the end of the array, so return it
					if (token.type == JSONTokenType.RIGHT_BRACKET)
					{
						return a;
					}
				}
			}
			else
			{
				tokenizer.parseError("Expecting ] or , but found " + token.value);
			}
		}
		return null;
	}

	/**
	 * Attempt to parse an object.
	 */
	private function parseObject():Object
	{
		// create the object internally that we're going to
		// attempt to parse from the tokenizer
		var o:Object = new Object();

		// store the string part of an object member so
		// that we can assign it a value in the object
		var key:String

		// grab the next token from the tokenizer
		nextToken();

		// check to see if we have an empty object
		if (token.type == JSONTokenType.RIGHT_BRACE)
		{
			// we're done reading the object, so return it
			return o;
		}
		// in non-strict mode an empty object is also a comma
		// followed by a right bracket
		else if (!strict && token.type == JSONTokenType.COMMA)
		{
			// move past the comma
			nextToken();

			// check to see if we're reached the end of the object
			if (token.type == JSONTokenType.RIGHT_BRACE)
			{
				return o;
			}
			else
			{
				tokenizer.parseError("Leading commas are not supported.  Expecting '}' but found " +
									 token.value);
			}
		}

		// deal with members of the object, and use an "infinite"
		// loop because we could have any amount of members
		while (true)
		{
			if (token.type == JSONTokenType.STRING)
			{
				// the string value we read is the key for the object
				key = String(token.value);

				// move past the string to see what's next
				nextToken();

				// after the string there should be a :
				if (token.type == JSONTokenType.COLON)
				{
					// move past the : and read/assign a value for the key
					nextToken();
					o[key] = parseValue();

					// move past the value to see what's next
					nextToken();

					// after the value there's either a } or a ,
					if (token.type == JSONTokenType.RIGHT_BRACE)
					{
						// we're done reading the object, so return it
						return o;
					}
					else if (token.type == JSONTokenType.COMMA)
					{
						// skip past the comma and read another member
						nextToken();

						// Allow objects to have a comma after the last member
						// if the decoder is not in strict mode
						if (!strict)
						{
							// Reached ",}" as the end of the object, so return it
							if (token.type == JSONTokenType.RIGHT_BRACE)
							{
								return o;
							}
						}
					}
					else
					{
						tokenizer.parseError("Expecting } or , but found " +
											 token.value);
					}
				}
				else
				{
					tokenizer.parseError("Expecting : but found " + token.value);
				}
			}
			else
			{
				tokenizer.parseError("Expecting string but found " + token.value);
			}
		}
		return null;
	}

	/**
	 * Attempt to parse a value
	 */
	private function parseValue():Object
	{
		// Catch errors when the input stream ends abruptly
		if (token == null)
		{
			tokenizer.parseError("Unexpected end of input");
		}

		switch (token.type)
		{
			case JSONTokenType.LEFT_BRACE:
				return parseObject();

			case JSONTokenType.LEFT_BRACKET:
				return parseArray();

			case JSONTokenType.STRING:
			case JSONTokenType.NUMBER:
			case JSONTokenType.TRUE:
			case JSONTokenType.FALSE:
			case JSONTokenType.NULL:
				return token.value;

			case JSONTokenType.NAN:
				if (!strict)
				{
					return token.value;
				}
				else
				{
					tokenizer.parseError("Unexpected " + token.value);
				}

			default:
				tokenizer.parseError("Unexpected " + token.value);

		}

		return null;
	}
}
}
