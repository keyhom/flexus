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
* 	Class that contains static utility methods for formatting Numbers
*
* 	@langversion ActionScript 3.0
*	@playerversion Flash 9.0
*	@tiptext
*
*	@see #mx.formatters.NumberFormatter
*/
public class NumberFormatter
{

	//--------------------------------------------------------------------------
	//
	//  Class methods 
	//
	//--------------------------------------------------------------------------

	/**
	*	Formats a number to include a leading zero if it is a single digit
	*	between -1 and 10.
	*
	* 	@param n The number that will be formatted
	*
	*	@return A string with single digits between -1 and 10 padded with a
	*	leading zero.
	*
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/
	static public function addLeadingZero(n:Number):String
	{
		var out:String = String(n);

		if (n < 10 && n > -1)
		{
			out = "0" + out;
		}

		return out;
	}
}
}
