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

package flexus.mdi.effects
{

import flash.geom.Point;
import flash.geom.Rectangle;
import mx.effects.Effect;
import flexus.mdi.containers.MDIWindow;
import flexus.mdi.managers.MDIManager;

/**
 * Interface expected by MDIManager. All effects classes must implement this interface.
 */
public interface IMDIEffectsDescriptor
{

	function getCascadeEffect(items:Array, manager:MDIManager):Effect;

	// group effects

	function getTileEffect(items:Array, manager:MDIManager):Effect;
	// window effects

	function getWindowAddEffect(window:MDIWindow, manager:MDIManager):Effect;

	function getWindowCloseEffect(window:MDIWindow, manager:MDIManager):Effect;

	function getWindowDragEffect(window:MDIWindow, manager:MDIManager):Effect;

	function getWindowDragEndEffect(window:MDIWindow, manager:MDIManager):Effect;

	function getWindowDragStartEffect(window:MDIWindow, manager:MDIManager):Effect;

	function getWindowFocusEndEffect(window:MDIWindow, manager:MDIManager):Effect;

	function getWindowFocusStartEffect(window:MDIWindow, manager:MDIManager):Effect;

	function getWindowMaximizeEffect(window:MDIWindow, manager:MDIManager, bottomOffset:Number =
									 0):Effect;

	function getWindowMinimizeEffect(window:MDIWindow, manager:MDIManager, moveTo:Point =
									 null):Effect;

	function getWindowResizeEffect(window:MDIWindow, manager:MDIManager):Effect;

	function getWindowResizeEndEffect(window:MDIWindow, manager:MDIManager):Effect;

	function getWindowResizeStartEffect(window:MDIWindow, manager:MDIManager):Effect;

	function getWindowRestoreEffect(window:MDIWindow, manager:MDIManager, restoreTo:Rectangle):Effect;

	function reTileMinWindowsEffect(window:MDIWindow, manager:MDIManager, moveTo:Point):Effect;
}
}
