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

package flexus.mdi.containers
{

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import flexus.mdi.events.MDIWindowEvent;
import flexus.mdi.managers.MDIManager;

import mx.controls.Alert;
import mx.events.CloseEvent;

import spark.components.TitleWindow;

//--------------------------------------
//  Events
//--------------------------------------
/**
 *  Dispatched when the minimize button is clicked.
 *
 *  @eventType flexus.mdi.events.MDIWindowEvent.MINIMIZE
 */
[Event(name = "minimize", type = "flexus.mdi.events.MDIWindowEvent")]
/**
 *  If the window is minimized, this event is dispatched when the titleBar is clicked.
 * 	If the window is maxmimized, this event is dispatched upon clicking the restore button
 *  or double clicking the titleBar.
 *
 *  @eventType flexus.mdi.events.MDIWindowEvent.RESTORE
 */
[Event(name = "restore", type = "flexus.mdi.events.MDIWindowEvent")]
/**
 *  Dispatched when the maximize button is clicked or when the window is in a
 *  normal state (not minimized or maximized) and the titleBar is double clicked.
 *
 *  @eventType flexus.mdi.events.MDIWindowEvent.MAXIMIZE
 */
[Event(name = "maximize", type = "flexus.mdi.events.MDIWindowEvent")]
/**
 *  Dispatched when the close button is clicked.
 *
 *  @eventType flexus.mdi.events.MDIWindowEvent.CLOSE
 */
[Event(name = "close", type = "flexus.mdi.events.MDIWindowEvent")]
/**
 *  Dispatched when the window gains focus and is given topmost z-index of MDIManager's children.
 *
 *  @eventType flexus.mdi.events.MDIWindowEvent.FOCUS_START
 */
[Event(name = "focusStart", type = "flexus.mdi.events.MDIWindowEvent")]
/**
 *  Dispatched when the window loses focus and no longer has topmost z-index of MDIManager's children.
 *
 *  @eventType flexus.mdi.events.MDIWindowEvent.FOCUS_END
 */
[Event(name = "focusEnd", type = "flexus.mdi.events.MDIWindowEvent")]
/**
 *  Dispatched when the window starts being dragged.
 *
 *  @eventType flexus.mdi.events.MDIWindowEvent.DRAG_START
 */
[Event(name = "dragStart", type = "flexus.mdi.events.MDIWindowEvent")]
/**
 *  Dispatched while the window is being dragged.
 *
 *  @eventType flexus.mdi.events.MDIWindowEvent.DRAG
 */
[Event(name = "drag", type = "flexus.mdi.events.MDIWindowEvent")]
/**
 *  Dispatched when the window stops being dragged.
 *
 *  @eventType flexus.mdi.events.MDIWindowEvent.DRAG_END
 */
[Event(name = "dragEnd", type = "flexus.mdi.events.MDIWindowEvent")]
/**
 *  Dispatched when a resize handle is pressed.
 *
 *  @eventType flexus.mdi.events.MDIWindowEvent.RESIZE_START
 */
[Event(name = "resizeStart", type = "flexus.mdi.events.MDIWindowEvent")]
/**
 *  Dispatched while the mouse is down on a resize handle.
 *
 *  @eventType flexus.mdi.events.MDIWindowEvent.RESIZE
 */
[Event(name = "resize", type = "flexus.mdi.events.MDIWindowEvent")]
/**
 *  Dispatched when the mouse is released from a resize handle.
 *
 *  @eventType flexus.mdi.events.MDIWindowEvent.RESIZE_END
 */
[Event(name = "resizeEnd", type = "flexus.mdi.events.MDIWindowEvent")]
/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class MDIWindow extends TitleWindow
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function MDIWindow()
	{
		super();
		minWidth = minHeight = width = height = 200;
		windowState = MDIWindowState.NORMAL;
		doubleClickEnabled = true;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// draggable 
	//----------------------------------

	private var _draggable:Boolean = true;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get draggable():Boolean
	{
		return _draggable;
	}

	/**
	 *
	 *  @param value
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function set draggable(value:Boolean):void
	{
		_draggable = value;
	}

	//----------------------------------
	// dragging 
	//----------------------------------

	private var _dragging:Boolean = false;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get dragging():Boolean
	{
		return _dragging;
	}

	/**
	 *
	 *  @param value
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function set dragging(value:Boolean):void
	{
		_dragging = value;
	}

	//----------------------------------
	// hasFocus 
	//----------------------------------

	private var _hasFocus:Boolean = false;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get hasFocus():Boolean
	{
		return _hasFocus;
	}

	/**
	 *
	 *  @param value
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function set hasFocus(value:Boolean):void
	{
		if (_hasFocus == value)
			return;

		_hasFocus = value;
		updateStyles();
	}

	//----------------------------------
	// maximized 
	//----------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get maximized():Boolean
	{
		return windowState == MDIWindowState.MAXIMIZED;
	}

	//----------------------------------
	// minimized 
	//----------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get minimized():Boolean
	{
		return windowState == MDIWindowState.MINIMIZED;
	}

	//----------------------------------
	// windowManager 
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
	public var windowManager:MDIManager;

	//----------------------------------
	// _prevWindowState 
	//----------------------------------

	private var _prevWindowState:int;

	//----------------------------------
	// dragStartMouseX 
	//----------------------------------

	private var dragStartMouseX:Number = 0;

	//----------------------------------
	// dragStartMouseY 
	//----------------------------------

	private var dragStartMouseY:Number = 0;

	//----------------------------------
	// windowState 
	//----------------------------------

	private var _windowState:int;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function get windowState():int
	{
		return _windowState;
	}

	/**
	 *
	 *  @param value
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function set windowState(value:int):void
	{
		_prevWindowState = _windowState;
		_windowState = value;

		//updateContextMenu();
	}

	//--------------------------------------------------------------------------
	//
	//  Overriden Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @{inheritDoc}
	 */
	override protected function createChildren():void
	{
		super.createChildren();

		addListeners();
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function addListeners():void
	{
		addEventListener(MouseEvent.MOUSE_DOWN, bringToFrontProxy);
		var closeFuture:Function = function(e:CloseEvent):void
		{
			removeEventListener(Event.CLOSE, closeFuture);
			close(e);
		};
		addEventListener(Event.CLOSE, closeFuture);

		if (!windowManager.isGlobal)
		{
			// defined the custom move handlers.
			super.moveArea.addEventListener(MouseEvent.MOUSE_DOWN, onTitleBarPress);
			super.moveArea.addEventListener(MouseEvent.MOUSE_UP, onTitleBarRelease);
			super.moveArea.addEventListener(MouseEvent.DOUBLE_CLICK, onMaximizeRestore);
			super.moveArea.addEventListener(MouseEvent.CLICK, onUnMinimize);
		}
	}

	/**
	 *
	 *  @param event
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function bringToFrontProxy(event:Event):void
	{
		windowManager.bringToFront(this);
	}

	/**
	 *
	 *  @param event
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function onTitleBarPress(event:MouseEvent):void
	{
		// only floating windows can be dragged.
		if (this.windowState == MDIWindowState.NORMAL && draggable)
		{
			dragStartMouseX = mouseX;
			dragStartMouseY = mouseY;

			systemManager.addEventListener(Event.ENTER_FRAME, onWindowMove);
			systemManager.addEventListener(MouseEvent.MOUSE_UP, onTitleBarRelease);
			systemManager.stage.addEventListener(Event.MOUSE_LEAVE, onTitleBarRelease);
		}
	}

	/**
	 *
	 *  @param event
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function onTitleBarRelease(event:Event):void
	{
		this.stopDrag();

		if (dragging)
		{
			dragging = false;
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.DRAG_END, this));
		}

		systemManager.removeEventListener(Event.ENTER_FRAME, onWindowMove);
		systemManager.removeEventListener(MouseEvent.MOUSE_UP, onTitleBarRelease);
		systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, onTitleBarRelease);
	}

	/**
	 *
	 *  @param event
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function onWindowMove(event:Event):void
	{
		if (!dragging)
		{
			dragging = true;
			// clear styling.
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.DRAG_START, this));
		}

		x = parent.mouseX - dragStartMouseX;
		y = parent.mouseY - dragStartMouseY;

		dispatchEvent(new MDIWindowEvent(MDIWindowEvent.DRAG, this));
	}

	/**
	 *
	 *  @param event
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function onUnMinimize(event:MouseEvent = null):void
	{
		if (minimized)
		{
			// showControls = true;
			if (_prevWindowState == MDIWindowState.NORMAL)
			{
				restore();
			}
			else
			{
				maximize();
			}
		}
	}

	/**
	 *
	 *  @param event
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function onMaximizeRestore(event:MouseEvent = null):void
	{
		if (windowState == MDIWindowState.NORMAL)
		{
			saveWindow();
			maximize();
		}
		else
		{
			restore();
		}
	}

	/**
	 *
	 *  @param event
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function close(event:Event = null):void
	{
		dispatchEvent(new MDIWindowEvent(MDIWindowEvent.CLOSE, this));
	}

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var savedWindowRect:Rectangle;

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function saveWindow():void
	{
		savedWindowRect = new Rectangle(this.x, this.y, this.width, this.height);
	}

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function restore():void
	{
		windowState = MDIWindowState.NORMAL;
		updateStyles();
		dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESTORE, this));
	}

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function maximize():void
	{
		if (windowState == MDIWindowState.NORMAL)
		{
			saveWindow();
		}

		// showControls = true;
		windowState = MDIWindowState.MAXIMIZED;
		updateStyles();
		dispatchEvent(new MDIWindowEvent(MDIWindowEvent.MAXIMIZE, this));
	}

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function updateStyles():void
	{
		trace("update styles in MDIWindow...");
	}
}
}
