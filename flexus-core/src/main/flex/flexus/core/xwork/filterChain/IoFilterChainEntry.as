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

package flexus.core.xwork.filterChain
{


/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IoFilterChainEntry
{
	//----------------------------------
	// filter 
	//----------------------------------

	function get filter():IoFilter;
	//----------------------------------
	// name 
	//----------------------------------

	function get name():String;
	//----------------------------------
	// nextFilter 
	//----------------------------------

	function get nextFilter():NextFilter;

	function addAfter(name:String, filter:IoFilter):void;
	function addBefore(name:String, filter:IoFilter):void;
	function remove():void;
	function replace(filter:IoFilter):void;
}
}
