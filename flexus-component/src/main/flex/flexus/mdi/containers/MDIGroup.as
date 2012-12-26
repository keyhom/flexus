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

import flexus.mdi.managers.MDIManager;

import mx.core.IVisualElement;
import mx.core.UIComponent;
import mx.events.FlexEvent;

import spark.components.Group;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class MDIGroup extends Group
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
	public function MDIGroup()
	{
		super();
		windowManager = new MDIManager(this);
		this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		this.clipAndEnableScrolling = true;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// windowManager 
	//----------------------------------

	public var windowManager:MDIManager;

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param event
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function onCreationComplete(event:FlexEvent):void
	{
		var num:int = numElements;

		for (var i:int = 0; i < num; i++)
		{
			var child:IVisualElement = getElementAt(i);

			if (child is MDIWindow)
			{
				windowManager.add(child as MDIWindow);
			}
		}
		removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
	}
}
}
