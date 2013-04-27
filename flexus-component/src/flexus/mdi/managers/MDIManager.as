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

package flexus.mdi.managers
{

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import flexus.mdi.containers.MDIWindow;
import flexus.mdi.effects.IMDIEffectsDescriptor;
import flexus.mdi.effects.MDIEffectsDescriptorBase;
import flexus.mdi.effects.effectClasses.MDIGroupEffectItem;
import flexus.mdi.events.MDIEffectEvent;
import flexus.mdi.events.MDIManagerEvent;
import flexus.mdi.events.MDIWindowEvent;

import mx.collections.ArrayCollection;
import mx.core.EventPriority;
import mx.core.FlexGlobals;
import mx.core.IFlexDisplayObject;
import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.effects.CompositeEffect;
import mx.effects.Effect;
import mx.events.EffectEvent;
import mx.events.ResizeEvent;
import mx.managers.PopUpManager;
import mx.utils.ArrayUtil;

//----------------------------------------
// Events
//----------------------------------------

/**
 *  Dispatched when a window is added to the manager.
 *
 *  @eventType flexus.mdi.events.MDIManagerEvent.WINDOW_ADD
 */
[Event(name = "windowAdd", type = "flexus.mdi.events.MDIManagerEvent")]

/**
 *  Dispatched when the minimize button is clicked.
 *
 *  @eventType flexus.mdi.events.MDIManagerEvent.WINDOW_MINIMIZE
 */
[Event(name = "windowMinimize", type = "flexus.mdi.events.MDIManagerEvent")]

/**
 *  If the window is minimized, this event is dispatched when the titleBar is clicked.
 * 	If the window is maxmimized, this event is dispatched upon clicking the restore button
 *  or double clicking the titleBar.
 *
 *  @eventType flexus.mdi.events.MDIManagerEvent.WINDOW_RESTORE
 */
[Event(name = "windowRestore", type = "flexus.mdi.events.MDIManagerEvent")]

/**
 *  Dispatched when the maximize button is clicked or when the window is in a
 *  normal state (not minimized or maximized) and the titleBar is double clicked.
 *
 *  @eventType flexus.mdi.events.MDIManagerEvent.WINDOW_MAXIMIZE
 */
[Event(name = "windowMaximize", type = "flexus.mdi.events.MDIManagerEvent")]

/**
 *  Dispatched when the minimize button is clicked.
 *
 *  @eventType flexus.mdi.events.MDIManagerEvent.WINDOW_CLOSE
 */
[Event(name = "windowClose", type = "flexus.mdi.events.MDIManagerEvent")]

/**
 *  Dispatched when the window gains focus and is given topmost z-index of MDIManager's children.
 *
 *  @eventType flexus.mdi.events.MDIManagerEvent.WINDOW_FOCUS_START
 */
[Event(name = "windowFocusStart", type = "flexus.mdi.events.MDIManagerEvent")]

/**
 *  Dispatched when the window loses focus and no longer has topmost z-index of MDIManager's children.
 *
 *  @eventType flexus.mdi.events.MDIManagerEvent.WINDOW_FOCUS_END
 */
[Event(name = "windowFocusEnd", type = "flexus.mdi.events.MDIManagerEvent")]

/**
 *  Dispatched when the window begins being dragged.
 *
 *  @eventType flexus.mdi.events.MDIManagerEvent.WINDOW_DRAG_START
 */
[Event(name = "windowDragStart", type = "flexus.mdi.events.MDIManagerEvent")]

/**
 *  Dispatched while the window is being dragged.
 *
 *  @eventType flexus.mdi.events.MDIManagerEvent.WINDOW_DRAG
 */
[Event(name = "windowDrag", type = "flexus.mdi.events.MDIManagerEvent")]

/**
 *  Dispatched when the window stops being dragged.
 *
 *  @eventType flexus.mdi.events.MDIManagerEvent.WINDOW_DRAG_END
 */
[Event(name = "windowDragEnd", type = "flexus.mdi.events.MDIManagerEvent")]

/**
 *  Dispatched when a resize handle is pressed.
 *
 *  @eventType flexus.mdi.events.MDIManagerEvent.WINDOW_RESIZE_START
 */
[Event(name = "windowResizeStart", type = "flexus.mdi.events.MDIManagerEvent")]

/**
 *  Dispatched while the mouse is down on a resize handle.
 *
 *  @eventType flexus.mdi.events.MDIManagerEvent.WINDOW_RESIZE
 */
[Event(name = "windowResize", type = "flexus.mdi.events.MDIManagerEvent")]

/**
 *  Dispatched when the mouse is released from a resize handle.
 *
 *  @eventType flexus.mdi.events.MDIManagerEvent.WINDOW_RESIZE_END
 */
[Event(name = "windowResizeEnd", type = "flexus.mdi.events.MDIManagerEvent")]

/**
 *  Dispatched when the windows are cascaded.
 *
 *  @eventType flexus.mdi.events.MDIManagerEvent.CASCADE
 */
[Event(name = "cascade", type = "flexus.mdi.events.MDIManagerEvent")]

/**
 *  Dispatched when the windows are tiled.
 *
 *  @eventType flexus.mdi.events.MDIManagerEvent.TILE
 */
[Event(name = "tile", type = "flexus.mdi.events.MDIManagerEvent")]

/**
 *  Dispatched when an effect begins.
 *
 *  @eventType mx.events.EffectEvent.EFFECT_START
 */
[Event(name = "effectStart", type = "mx.events.EffectEvent")]

/**
 *  Dispatched when an effect ends.
 *
 *  @eventType mx.events.EffectEvent.EFFECT_END
 */
[Event(name = "effectEnd", type = "mx.events.EffectEvent")]
/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class MDIManager extends EventDispatcher
{
	/**
	 * Temporary storage location for use in dispatching MDIEffectEvents.
	 *
	 * @private
	 */
	private var mgrEventCollection:ArrayCollection = new ArrayCollection();


	//--------------------------------------------------------------------------
	//
	//  Class properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// global 
	//----------------------------------

	/**
	 *
	 *  @return the global manager.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public function get global():MDIManager
	{
		if (MDIManager.globalMDIManager == null)
		{
			globalMDIManager = new MDIManager(FlexGlobals.topLevelApplication as
											  IVisualElementContainer);
			globalMDIManager.isGlobal = true;
		}
		return MDIManager.globalMDIManager;
	}

	//----------------------------------
	// globalMDIManager 
	//----------------------------------

	static private var globalMDIManager:MDIManager = null;

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
	public function MDIManager(container:IVisualElementContainer, effects:IMDIEffectsDescriptor =
							   null)
	{
		super();
		this.container = container;

		if (effects != null)
			this.effects = effects;

		if (tileMinimize)
		{
			tileWindows = new ArrayCollection();
		}
		this.addEventListener(ResizeEvent.RESIZE, containerResizeHandler);

		this.windowToManagerEventMap = new Dictionary;
		windowToManagerEventMap[MDIWindowEvent.MINIMIZE] = MDIManagerEvent.WINDOW_MINIMIZE;
		windowToManagerEventMap[MDIWindowEvent.RESTORE] = MDIManagerEvent.WINDOW_RESTORE;
		windowToManagerEventMap[MDIWindowEvent.MAXIMIZE] = MDIManagerEvent.WINDOW_MAXIMIZE;
		windowToManagerEventMap[MDIWindowEvent.CLOSE] = MDIManagerEvent.WINDOW_CLOSE;
		windowToManagerEventMap[MDIWindowEvent.FOCUS_START] = MDIManagerEvent.
			WINDOW_FOCUS_START;
		windowToManagerEventMap[MDIWindowEvent.FOCUS_END] = MDIManagerEvent.
			WINDOW_FOCUS_END;
		windowToManagerEventMap[MDIWindowEvent.DRAG_START] = MDIManagerEvent.
			WINDOW_DRAG_START;
		windowToManagerEventMap[MDIWindowEvent.DRAG] = MDIManagerEvent.WINDOW_DRAG;
		windowToManagerEventMap[MDIWindowEvent.DRAG_END] = MDIManagerEvent.WINDOW_DRAG_END;
		windowToManagerEventMap[MDIWindowEvent.RESIZE_START] = MDIManagerEvent.
			WINDOW_RESIZE_START;
		windowToManagerEventMap[MDIWindowEvent.RESIZE] = MDIManagerEvent.WINDOW_RESIZE;
		windowToManagerEventMap[MDIWindowEvent.RESIZE_END] = MDIManagerEvent.
			WINDOW_RESIZE_END;

		// these handlers execute default behaviors, these events are dispatched by this class
		addEventListener(MDIManagerEvent.WINDOW_ADD, executeDefaultBehavior,
						 false, EventPriority.DEFAULT_HANDLER);
		addEventListener(MDIManagerEvent.WINDOW_MINIMIZE, executeDefaultBehavior,
						 false, EventPriority.DEFAULT_HANDLER);
		addEventListener(MDIManagerEvent.WINDOW_RESTORE, executeDefaultBehavior,
						 false, EventPriority.DEFAULT_HANDLER);
		addEventListener(MDIManagerEvent.WINDOW_MAXIMIZE, executeDefaultBehavior,
						 false, EventPriority.DEFAULT_HANDLER);
		addEventListener(MDIManagerEvent.WINDOW_CLOSE, executeDefaultBehavior,
						 false, EventPriority.DEFAULT_HANDLER);

		addEventListener(MDIManagerEvent.WINDOW_FOCUS_START, executeDefaultBehavior,
						 false, EventPriority.DEFAULT_HANDLER);
		addEventListener(MDIManagerEvent.WINDOW_FOCUS_END, executeDefaultBehavior,
						 false, EventPriority.DEFAULT_HANDLER);
		addEventListener(MDIManagerEvent.WINDOW_DRAG_START, executeDefaultBehavior,
						 false, EventPriority.DEFAULT_HANDLER);
		addEventListener(MDIManagerEvent.WINDOW_DRAG, executeDefaultBehavior,
						 false, EventPriority.DEFAULT_HANDLER);
		addEventListener(MDIManagerEvent.WINDOW_DRAG_END, executeDefaultBehavior,
						 false, EventPriority.DEFAULT_HANDLER);
		addEventListener(MDIManagerEvent.WINDOW_RESIZE_START, executeDefaultBehavior,
						 false, EventPriority.DEFAULT_HANDLER);
		addEventListener(MDIManagerEvent.WINDOW_RESIZE, executeDefaultBehavior,
						 false, EventPriority.DEFAULT_HANDLER);
		addEventListener(MDIManagerEvent.WINDOW_RESIZE_END, executeDefaultBehavior,
						 false, EventPriority.DEFAULT_HANDLER);

		addEventListener(MDIManagerEvent.CASCADE, executeDefaultBehavior, false,
						 EventPriority.DEFAULT_HANDLER);
		addEventListener(MDIManagerEvent.TILE, executeDefaultBehavior, false,
						 EventPriority.DEFAULT_HANDLER);

	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------

	public var effects:IMDIEffectsDescriptor = new MDIEffectsDescriptorBase();

	//----------------------------------
	// container 
	//----------------------------------

	private var _container:IVisualElementContainer;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get container():IVisualElementContainer
	{
		return _container;
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
	public function set container(value:IVisualElementContainer):void
	{
		this._container = value;
	}

	//----------------------------------
	// tileMinimize 
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
	public var tileMinimize:Boolean = true;

	//----------------------------------
	// windowList 
	//----------------------------------

	[Bindable]
	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var windowList:Array = [];

	//----------------------------------
	// isGlobal 
	//----------------------------------

	public var isGlobal:Boolean = false;

	//----------------------------------
	// tileWindows 
	//----------------------------------

	private var tileWindows:ArrayCollection;

	//----------------------------------
	// windowToManagerEventMap
	//----------------------------------

	private var windowToManagerEventMap:Dictionary;

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param window
	 *  @param x
	 *  @param y
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function absPos(window:MDIWindow, x:Number, y:Number):void
	{
		window.x = x;
		window.y = y;
	}

	/**
	 *  Add the specific MDI window to this manager.
	 *
	 *  @param window
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function add(window:MDIWindow):void
	{
		if (windowList.indexOf(window) < 0)
		{
			window.windowManager = this;
			this.addListeners(window);
			this.windowList.push(window);

			// this.addContextMenu

			if (this.isGlobal)
			{
				PopUpManager.addPopUp(window, FlexGlobals.topLevelApplication as
									  DisplayObject, false);
				this.position(window);
			}
			else
			{
				// to accomodate mxml impl
				if (window.parent == null && this.container is IVisualElementContainer)
				{
					IVisualElementContainer(this.container).addElement(window);
					this.position(window);
				}
			}

			dispatchEvent(new MDIManagerEvent(MDIManagerEvent.WINDOW_ADD, window,
											  this));
			bringToFront(window);
		}
	}

	/**
	 *
	 *  @param window
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function addCenter(window:MDIWindow):void
	{
		this.add(window);
		this.center(window);
	}

	/**
	 *
	 *  @param window
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function bringToFront(window:MDIWindow):void
	{
		if (this.isGlobal)
		{
			PopUpManager.bringToFront(window as IFlexDisplayObject);
		}
		else
		{
			for each (var win:MDIWindow in windowList)
			{
				if (win != window && win.hasFocus)
				{
					win.dispatchEvent(new MDIWindowEvent(MDIWindowEvent.FOCUS_END,
														 win));
				}

				if (win == window && !window.hasFocus)
				{
					win.dispatchEvent(new MDIWindowEvent(MDIWindowEvent.FOCUS_START,
														 win));
				}
			}
		}
	}

	/**
	 *
	 *  @param window
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function center(window:MDIWindow):void
	{
		window.x = (IVisualElement(container).width - window.width) * 0.5;
		window.y = (IVisualElement(container).height - window.height) * 0.5;
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
	public function executeDefaultBehavior(event:Event):void
	{
		if (event is MDIManagerEvent && !event.isDefaultPrevented())
		{
			var mgrEvent:MDIManagerEvent = event as MDIManagerEvent;

			switch (mgrEvent.type)
			{
				case MDIManagerEvent.WINDOW_ADD:
					mgrEvent.effect = this.effects.getWindowAddEffect(mgrEvent.
																	  window,
																	  this);
					break;
				case MDIManagerEvent.WINDOW_MAXIMIZE:
					mgrEvent.effect = getMaximizeWindowEffect(mgrEvent.window);
					break;
				case MDIManagerEvent.WINDOW_RESTORE:
					break;
				case MDIManagerEvent.WINDOW_FOCUS_START:
					mgrEvent.window.hasFocus = true;
					mgrEvent.window.validateNow();
					container.setElementIndex(mgrEvent.window, container.numElements -
											  1);
					break;
				case MDIManagerEvent.WINDOW_FOCUS_END:
					mgrEvent.window.hasFocus = false;
					mgrEvent.window.validateNow();
					break;
				case MDIManagerEvent.WINDOW_CLOSE:
					mgrEvent.effect.addEventListener(EffectEvent.EFFECT_END,
													 onCloseEffectEnd);
					break;
			}

			if (mgrEvent.effect && (mgrEvent.effect is CompositeEffect || (mgrEvent.
				effect.targets && mgrEvent.effect.targets.length)))
			{
				mgrEventCollection.addItem(mgrEvent);

				mgrEvent.effect.addEventListener(EffectEvent.EFFECT_START, onMgrEffectEvent);
				mgrEvent.effect.addEventListener(EffectEvent.EFFECT_END, onMgrEffectEvent);

				mgrEvent.effect.play();
			}
		}
	}

	private function getMaximizeWindowEffect(window:MDIWindow):Effect
	{
		// cuts the default. TODO figure out future.
		return this.effects.getWindowMaximizeEffect(window, this);
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getOpenedWindowList():Array
	{
		var array:Array = [];

		for (var i:int = 0, l:int = windowList.length; i < l; i++)
		{
			if (!MDIWindow(windowList[i]).minimized)
				array.push(windowList[i]);
		}
		return array;
	}

	/**
	 *
	 *  @param window
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function manage(window:MDIWindow):void
	{
		if (window != null && windowList.indexOf(window) < 0)
		{
			windowList.push(window);
		}
	}

	/**
	 *
	 *  @param window
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function position(window:MDIWindow):void
	{
		window.x = this.windowList.length * 30;
		window.y = this.windowList.length * 30;

		if ((window.x + windowList.length) > IVisualElement(container).width)
			window.x = 40;

		if ((window.y + windowList.length) > IVisualElement(container).height)
			window.y = 40;
	}

	/**
	 *
	 *  @param window
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function remove(window:MDIWindow):void
	{
		var index:int = ArrayUtil.getItemIndex(window, this.windowList);
		windowList.splice(index, 1);

		if (this.isGlobal)
		{
			PopUpManager.removePopUp(window as IFlexDisplayObject);
		}
		else
		{
			container.removeElement(window);
		}

		removeListeners(window);

		for (var i:int = container.numElements - 1; i > -1; i--)
		{
			var obj:IVisualElement = container.getElementAt(i);

			if (obj is MDIWindow)
			{
				bringToFront(MDIWindow(obj));
				return;
			}
		}
	}

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function removeAll():void
	{
		for each (var window:MDIWindow in windowList)
		{
			if (this.isGlobal)
			{
				PopUpManager.removePopUp(window as IFlexDisplayObject);
			}
			else
			{
				container.removeElement(window);
			}

			this.removeListeners(window);
		}

		this.windowList = [];
	}

	/**
	 *
	 *  @param window
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function resize(window:MDIWindow):void
	{
		var w:Number = IVisualElement(container).width * 0.6;
		var h:Number = IVisualElement(container).height * 0.6;

		if (w > window.width)
			window.width = w;

		if (h > window.height)
			window.height = h;
	}

	/**
	 *
	 *  @param window
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function addListeners(window:MDIWindow):void
	{
		window.addEventListener(MDIWindowEvent.MINIMIZE, windowEventProxy, false,
								EventPriority.DEFAULT_HANDLER);
		window.addEventListener(MDIWindowEvent.RESTORE, windowEventProxy, false,
								EventPriority.DEFAULT_HANDLER);
		window.addEventListener(MDIWindowEvent.MAXIMIZE, windowEventProxy, false,
								EventPriority.DEFAULT_HANDLER);
		window.addEventListener(MDIWindowEvent.CLOSE, windowEventProxy, false,
								EventPriority.DEFAULT_HANDLER);

		window.addEventListener(MDIWindowEvent.FOCUS_START, windowEventProxy,
								false, EventPriority.DEFAULT_HANDLER);
		window.addEventListener(MDIWindowEvent.FOCUS_END, windowEventProxy, false,
								EventPriority.DEFAULT_HANDLER);
		window.addEventListener(MDIWindowEvent.DRAG_START, windowEventProxy,
								false, EventPriority.DEFAULT_HANDLER);
		window.addEventListener(MDIWindowEvent.DRAG, windowEventProxy, false,
								EventPriority.DEFAULT_HANDLER);
		window.addEventListener(MDIWindowEvent.DRAG_END, windowEventProxy, false,
								EventPriority.DEFAULT_HANDLER);
		window.addEventListener(MDIWindowEvent.RESIZE_START, windowEventProxy,
								false, EventPriority.DEFAULT_HANDLER);
		window.addEventListener(MDIWindowEvent.RESIZE, windowEventProxy, false,
								EventPriority.DEFAULT_HANDLER);
		window.addEventListener(MDIWindowEvent.RESIZE_END, windowEventProxy,
								false, EventPriority.DEFAULT_HANDLER);
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
	private function containerResizeHandler(event:ResizeEvent):void
	{
	}

	/**
	 *
	 *  @param window
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function removeListeners(window:MDIWindow):void
	{
		window.removeEventListener(MDIWindowEvent.MINIMIZE, windowEventProxy);
		window.removeEventListener(MDIWindowEvent.RESTORE, windowEventProxy);
		window.removeEventListener(MDIWindowEvent.MAXIMIZE, windowEventProxy);
		window.removeEventListener(MDIWindowEvent.CLOSE, windowEventProxy);

		window.removeEventListener(MDIWindowEvent.FOCUS_START, windowEventProxy);
		window.removeEventListener(MDIWindowEvent.FOCUS_END, windowEventProxy);
		window.removeEventListener(MDIWindowEvent.DRAG_START, windowEventProxy);
		window.removeEventListener(MDIWindowEvent.DRAG, windowEventProxy);
		window.removeEventListener(MDIWindowEvent.DRAG_END, windowEventProxy);
		window.removeEventListener(MDIWindowEvent.RESIZE_START, windowEventProxy);
		window.removeEventListener(MDIWindowEvent.RESIZE, windowEventProxy);
		window.removeEventListener(MDIWindowEvent.RESIZE_END, windowEventProxy);
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
	private function windowEventProxy(event:Event):void
	{
		if (event is MDIWindowEvent && !event.isDefaultPrevented())
		{
			var winEvent:MDIWindowEvent = event as MDIWindowEvent;
			var mgrEvent:MDIManagerEvent = new MDIManagerEvent(windowToManagerEventMap[winEvent.
															   type], winEvent.
															   window, this,
															   null, null, null);

			switch (winEvent.type)
			{
				case MDIWindowEvent.MAXIMIZE:
					//mgrEvent.window.restoreStyle();
					mgrEvent.effect = this.effects.getWindowMaximizeEffect(winEvent.
																		   window,
																		   this);
					break;
				case MDIWindowEvent.RESTORE:
					//mgrEvent.window.restoreStyle();
					mgrEvent.effect = this.effects.getWindowRestoreEffect(winEvent.
																		  window,
																		  this,
																		  winEvent.
																		  window.
																		  savedWindowRect);
					break;
				case MDIWindowEvent.FOCUS_START:
					mgrEvent.effect = this.effects.getWindowFocusStartEffect(winEvent.
																			 window,
																			 this);
					break;
				case MDIWindowEvent.FOCUS_END:
					mgrEvent.effect = this.effects.getWindowFocusEndEffect(winEvent.
																		   window,
																		   this);
					break;
				case MDIWindowEvent.CLOSE:
					mgrEvent.effect = this.effects.getWindowCloseEffect(winEvent.
																		window,
																		this);
					break;
			}

			dispatchEvent(mgrEvent);
		}
	}

	private function onMgrEffectEvent(event:EffectEvent):void
	{
		// iterable over stored events
		for each (var mgrEvent:MDIManagerEvent in mgrEventCollection)
		{
			// is this the manager event that corresponds to this effect?
			if (mgrEvent.effect == event.effectInstance.effect)
			{
				// for group events (tile and cascade) event.window is null
				// and we have to dig in a bit to get the window list
				var windows:Array = new Array();

				if (mgrEvent.window)
				{
					windows.push(mgrEvent.window);
				}
				else
				{
					for each (var group:MDIGroupEffectItem in mgrEvent.effectItems)
					{
						windows.push(group.window);
					}
				}
				// create and dispatch event
				dispatchEvent(new MDIEffectEvent(event.type, mgrEvent.type, windows));

				// if the effect is over remove the manager event from collection
				if (event.type == EffectEvent.EFFECT_END)
				{
					mgrEventCollection.removeItemAt(mgrEventCollection.getItemIndex(mgrEvent));
				}
				return;
			}
		}
	}

	private function onCloseEffectEnd(event:EffectEvent):void
	{
		remove(event.effectInstance.target as MDIWindow);
	}
}
}
