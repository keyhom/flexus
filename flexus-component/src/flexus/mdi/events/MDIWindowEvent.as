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

package flexus.mdi.events
{

import flash.events.Event;

import flexus.mdi.containers.MDIWindow;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class MDIWindowEvent extends Event
{

	//--------------------------------------------------------------------------
	//
	//  Class properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// CLOSE 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const CLOSE:String = "close";

	//----------------------------------
	// DRAG 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const DRAG:String = "drag";

	//----------------------------------
	// DRAG_END 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const DRAG_END:String = "dragEnd";

	//----------------------------------
	// DRAG_START 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const DRAG_START:String = "dragStart";

	//----------------------------------
	// FOCUS_END 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const FOCUS_END:String = "focusEnd";

	//----------------------------------
	// FOCUS_START 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const FOCUS_START:String = "focusStart";

	//----------------------------------
	// MAXIMIZE 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const MAXIMIZE:String = "maximize";

	//----------------------------------
	// MINIMIZE 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const MINIMIZE:String = "minimize";

	//----------------------------------
	// RESIZE 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const RESIZE:String = "resize";

	//----------------------------------
	// RESIZE_END 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const RESIZE_END:String = "resizeEnd";

	//----------------------------------
	// RESIZE_START 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const RESIZE_START:String = "resizeStart";

	//----------------------------------
	// RESTORE 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const RESTORE:String = "restore";

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param type
	 *  @param window
	 *  @param resizeHandle
	 *  @param bubbles
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function MDIWindowEvent(type:String, window:MDIWindow, resizeHandle:String =
								   null, bubbles:Boolean = false)
	{
		super(type, bubbles, true);
		this.window = window;
		this.resizeHandle = resizeHandle;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// resizeHandle 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var resizeHandle:String;

	//----------------------------------
	// window 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var window:MDIWindow;

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override public function clone():Event
	{
		return new MDIWindowEvent(type, window, resizeHandle, bubbles);
	}
}
}
