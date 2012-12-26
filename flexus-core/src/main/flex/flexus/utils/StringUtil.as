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

package flexus.utils
{

/**
* 	Class that contains static utility methods for manipulating Strings.
*
* 	@langversion ActionScript 3.0
*	@playerversion Flash 9.0
*	@tiptext
*/
public class StringUtil
{

	//--------------------------------------------------------------------------
	//
	//  Class methods 
	//
	//--------------------------------------------------------------------------

	/**
	*	Determines whether the specified string begins with the spcified prefix.
	*
	*	@param input The string that the prefix will be checked against.
	*
	*	@param prefix The prefix that will be tested against the string.
	*
	*	@returns True if the string starts with the prefix, false if it does not.
	*
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/
	static public function beginsWith(input:String, prefix:String):Boolean
	{
		return (prefix == input.substring(0, prefix.length));
	}

	/**
	*	Determines whether the specified string ends with the spcified suffix.
	*
	*	@param input The string that the suffic will be checked against.
	*
	*	@param prefix The suffic that will be tested against the string.
	*
	*	@returns True if the string ends with the suffix, false if it does not.
	*
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/
	static public function endsWith(input:String, suffix:String):Boolean
	{
		return (suffix == input.substring(input.length - suffix.length));
	}


	/**
	*	Specifies whether the specified string is either non-null, or contains
	*  	characters (i.e. length is greater that 0)
	*
	*	@param s The string which is being checked for a value
	*
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/
	static public function isEmpty(s:String):Boolean
	{
		//todo: this needs a unit test
		return (s == null || s.length == 0);
	}

	/**
	*	Removes whitespace from the front of the specified string.
	*
	*	@param input The String whose beginning whitespace will will be removed.
	*
	*	@returns A String with whitespace removed from the begining
	*
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/
	static public function ltrim(input:String):String
	{
		var size:Number = input.length;
		for (var i:Number = 0; i < size; i++)
		{
			if (input.charCodeAt(i) > 32)
			{
				return input.substring(i);
			}
		}
		return "";
	}

	/**
	*	Removes all instances of the remove string in the input string.
	*
	*	@param input The string that will be checked for instances of remove
	*	string
	*
	*	@param remove The string that will be removed from the input string.
	*
	*	@returns A String with the remove string removed.
	*
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/
	static public function remove(input:String, remove:String):String
	{
		return StringUtil.replace(input, remove, "");
	}

	/**
	*	Replaces all instances of the replace string in the input string
	*	with the replaceWith string.
	*
	*	@param input The string that instances of replace string will be
	*	replaces with removeWith string.
	*
	*	@param replace The string that will be replaced by instances of
	*	the replaceWith string.
	*
	*	@param replaceWith The string that will replace instances of replace
	*	string.
	*
	*	@returns A new String with the replace string replaced with the
	*	replaceWith string.
	*
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/
	static public function replace(input:String, replace:String, replaceWith:String):String
	{
		return input.split(replace).join(replaceWith);
	}

	/**
	*	Removes whitespace from the end of the specified string.
	*
	*	@param input The String whose ending whitespace will will be removed.
	*
	*	@returns A String with whitespace removed from the end
	*
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/
	static public function rtrim(input:String):String
	{
		var size:Number = input.length;
		for (var i:Number = size; i > 0; i--)
		{
			if (input.charCodeAt(i - 1) > 32)
			{
				return input.substring(0, i);
			}
		}

		return "";
	}


	/**
	*	Does a case insensitive compare or two strings and returns true if
	*	they are equal.
	*
	*	@param s1 The first string to compare.
	*
	*	@param s2 The second string to compare.
	*
	*	@returns A boolean value indicating whether the strings' values are
	*	equal in a case sensitive compare.
	*
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/
	static public function stringsAreEqual(s1:String, s2:String, caseSensitive:Boolean):Boolean
	{
		if (caseSensitive)
		{
			return (s1 == s2);
		}
		else
		{
			return (s1.toUpperCase() == s2.toUpperCase());
		}
	}

	/**
	*	Removes whitespace from the front and the end of the specified
	*	string.
	*
	*	@param input The String whose beginning and ending whitespace will
	*	will be removed.
	*
	*	@returns A String with whitespace removed from the begining and end
	*
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/
	static public function trim(input:String):String
	{
		return StringUtil.ltrim(StringUtil.rtrim(input));
	}
}
}
