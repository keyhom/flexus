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

package flexus.core.xwork.session
{

import flash.events.IEventDispatcher;
import flexus.core.xwork.filterChain.IoFilterChain;
import flexus.core.xwork.service.IoConnector;
import flexus.core.xwork.service.IoHandler;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IoSession extends IEventDispatcher
{
	//----------------------------------
	// connected 
	//----------------------------------

	function get connected():Boolean;
	//----------------------------------
	// filterChain 
	//----------------------------------

	function get filterChain():IoFilterChain;
	//----------------------------------
	// handler 
	//----------------------------------

	function get handler():IoHandler;
	//----------------------------------
	// service 
	//----------------------------------

	function get service():IoConnector;
	//----------------------------------
	// sessionId 
	//----------------------------------

	function get sessionId():uint;

	function close(now:Boolean = false, closeFuture:Function = null):void;

	function containsAttribute(key:Object):Boolean;
	function getAttribute(key:Object, defaultValue:Object = null):Object;
	function getAttributeKeys():Array;
	function removeAttribute(key:Object, value:Object = null):Object;
	function replaceAttribute(key:Object, oldValue:Object, newValue:Object):Object;
	function setAttribute(key:Object, value:Object):Object;
	function setAttributeIfAbsent(key:Object, value:Object):Object;
	function write(message:Object, writeFuture:Function = null):void;
}
}
