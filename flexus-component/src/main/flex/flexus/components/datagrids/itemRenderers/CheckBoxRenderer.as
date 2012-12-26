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

package flexus.components.datagrids.itemRenderers
{

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import mx.controls.listClasses.ListBase;

/**
 * @author keyhom.c
 */
public class CheckBoxRenderer extends CenterCheckBox
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
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
	public function CheckBoxRenderer()
	{
		super();
		focusEnabled = false;
	}

	//----------------------------------------------------------------------
	//
	// Overrides
	//
	//----------------------------------------------------------------------

	override public function set data(value:Object):void
	{
		super.data = value;
		invalidateProperties();
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override protected function clickHandler(event:MouseEvent):void
	{

	}

	override protected function commitProperties():void
	{
		super.commitProperties();

		if (owner is ListBase)
		{
			selected = ListBase(owner).isItemSelected(data);
		}
	}

	override protected function keyDownHandler(event:KeyboardEvent):void
	{

	}

	override protected function keyUpHandler(event:KeyboardEvent):void
	{

	}
}
}
