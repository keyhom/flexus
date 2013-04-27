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
import flexus.mdi.managers.MDIManager;

import mx.effects.Effect;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class MDIManagerEvent extends Event
{

	//--------------------------------------------------------------------------
	//
	//  Class properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// CASCADE 
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
	static public const CASCADE:String = "cascade";

	//----------------------------------
	// TILE 
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
	static public const TILE:String = "tile";

	//----------------------------------
	// WINDOW_ADD 
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
	static public const WINDOW_ADD:String = "windowAdd";

	//----------------------------------
	// WINDOW_CLOSE 
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
	static public const WINDOW_CLOSE:String = "windowClose";

	//----------------------------------
	// WINDOW_DRAG 
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
	static public const WINDOW_DRAG:String = "windowDrag";

	//----------------------------------
	// WINDOW_DRAG_END 
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
	static public const WINDOW_DRAG_END:String = "windowDragEnd";

	//----------------------------------
	// WINDOW_DRAG_START 
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
	static public const WINDOW_DRAG_START:String = "windowDragStart";

	//----------------------------------
	// WINDOW_FOCUS_END 
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
	static public const WINDOW_FOCUS_END:String = "windowFocusEnd";

	//----------------------------------
	// WINDOW_FOCUS_START 
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
	static public const WINDOW_FOCUS_START:String = "windowFocusStart";

	//----------------------------------
	// WINDOW_MAXIMIZE 
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
	static public const WINDOW_MAXIMIZE:String = "windowMaximize";

	//----------------------------------
	// WINDOW_MINIMIZE 
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
	static public const WINDOW_MINIMIZE:String = "windowMinimize";

	//----------------------------------
	// WINDOW_RESIZE 
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
	static public const WINDOW_RESIZE:String = "windowResize";

	//----------------------------------
	// WINDOW_RESIZE_END 
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
	static public const WINDOW_RESIZE_END:String = "windowResizeEnd";

	//----------------------------------
	// WINDOW_RESIZE_START 
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
	static public const WINDOW_RESIZE_START:String = "windowResizeStart";

	//----------------------------------
	// WINDOW_RESTORE 
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
	static public const WINDOW_RESTORE:String = "windowRestore";

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
	 *  @param manager
	 *  @param effect
	 *  @param effectItems
	 *  @param resizeHandle
	 *  @param bubbles
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function MDIManagerEvent(type:String, window:MDIWindow, manager:MDIManager,
									effect:Effect = null, effectItems:Array =
									null, resizeHandle:String = null, bubbles:Boolean =
									false)
	{
		super(type, bubbles, true);
		this.window = window;
		this.manager = manager;
		this.effect = effect;
		this.effectItems = effectItems;
		this.resizeHandle = resizeHandle;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// effect 
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
	public var effect:Effect;

	//----------------------------------
	// effectItems 
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
	public var effectItems:Array;

	//----------------------------------
	// manager 
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
	public var manager:MDIManager;

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
		return new MDIManagerEvent(type, window, manager, effect, effectItems,
								   resizeHandle, bubbles);
	}
}
}
