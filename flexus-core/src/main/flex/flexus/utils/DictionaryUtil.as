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

import flash.utils.Dictionary;

public class DictionaryUtil
{

	//--------------------------------------------------------------------------
	//
	//  Class methods 
	//
	//--------------------------------------------------------------------------

	/**
	*	Returns an Array of all keys within the specified dictionary.
	*
	* 	@param d The Dictionary instance whose keys will be returned.
	*
	* 	@return Array of keys contained within the Dictionary
	*
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/
	static public function getKeys(d:Dictionary):Array
	{
		var a:Array = new Array();

		for (var key:Object in d)
		{
			a.push(key);
		}

		return a;
	}

	/**
	*	Returns an Array of all values within the specified dictionary.
	*
	* 	@param d The Dictionary instance whose values will be returned.
	*
	* 	@return Array of values contained within the Dictionary
	*
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/
	static public function getValues(d:Dictionary):Array
	{
		var a:Array = new Array();

		for each (var value:Object in d)
		{
			a.push(value);
		}

		return a;
	}
}
}
