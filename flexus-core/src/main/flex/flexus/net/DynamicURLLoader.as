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

package flexus.net
{

import flash.net.URLLoader;

/**
* 	Class that provides a dynamic implimentation of the URLLoader class.
*
* 	This class provides no API implimentations. However, since the class is
* 	declared as dynamic, it can be used in place of URLLoader, and allow
* 	you to dynamically attach properties to it (which URLLoader does not allow).
*
* 	@langversion ActionScript 3.0
*	@playerversion Flash 9.0
*	@tiptext
*/
public dynamic class DynamicURLLoader extends URLLoader
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	public function DynamicURLLoader()
	{
		super();
	}
}
}
