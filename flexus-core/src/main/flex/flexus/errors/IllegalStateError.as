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

package flexus.errors
{

/**
* This class represents an Error that is thrown when a method is called when
* the receiving instance is in an invalid state.
*
* For example, this may occur if a method has been called, and other properties
* in the instance have not been initialized properly.
*
* @langversion ActionScript 3.0
* @playerversion Flash 9.0
* @tiptext
*
*/
public class IllegalStateError extends Error
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	*	Constructor
	*
	*	@param message A message describing the error in detail.
	*
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/
	public function IllegalStateError(message:String)
	{
		super(message);
	}
}
}
