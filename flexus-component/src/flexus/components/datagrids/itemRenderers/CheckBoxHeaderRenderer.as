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

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;

import mx.controls.dataGridClasses.DataGridListData;
import mx.controls.listClasses.ListBase;
import mx.events.FlexEvent;

/**
 * 数据列表复选框列头项呈示器
 *
 * @author jeremy
 */
public class CheckBoxHeaderRenderer extends CenterCheckBox
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
	public function CheckBoxHeaderRenderer()
	{
		super();
		focusEnabled = false;
		selected = false;
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

	//----------------------------------------------------------------------
	//
	// Variables
	//
	//----------------------------------------------------------------------

	private var listenerAdded:Boolean = false;

	//----------------------------------
	// partiallySelected 
	//----------------------------------

	private var partiallySelected:Boolean = false;

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override protected function clickHandler(event:MouseEvent):void
	{
		if (selected)
		{
			// uncheck everything
			ListBase(owner).selectedIndex = -1;
		}
		else
		{
			if (ListBase(owner).dataProvider)
			{
				var n:int = ListBase(owner).dataProvider.length;
				var arr:Array = [];

				for (var i:int = 0; i < n; i++)
				{
					arr.push(i);
				}

				ListBase(owner).selectedIndices = arr;
			}
		}
	}

	override protected function commitProperties():void
	{
		super.commitProperties();

		if (owner is ListBase)
		{
			if (!listenerAdded)
			{
				listenerAdded = true;
				owner.addEventListener(FlexEvent.VALUE_COMMIT, ownerChangeHandler,
									   false, 0, true);
				owner.addEventListener(Event.CHANGE, ownerChangeHandler, false,
									   0, true);
			}

			if (ListBase(owner).dataProvider && ListBase(owner).selectedItems.
				length == ListBase(owner).dataProvider.length)
			{
				selected = true;
				partiallySelected = false;
			}
			else if (ListBase(owner).selectedItems.length == 0)
			{
				selected = false;
				partiallySelected = false;
			}
			else
			{
				selected = false;
				partiallySelected = true;
			}

			invalidateDisplayList();
		}
	}

	override protected function keyDownHandler(event:KeyboardEvent):void
	{

	}

	override protected function keyUpHandler(event:KeyboardEvent):void
	{

	}

	override protected function updateDisplayList(w:Number, h:Number):void
	{
		super.updateDisplayList(w, h);

		graphics.clear();

		if (listData is DataGridListData)
		{
			var n:int = numChildren;

			for (var i:int = 0; i < n; i++)
			{
				var c:DisplayObject = getChildAt(i);

				if (!(c is TextField))
				{
					c.x = (w - c.width) / 2;
					c.y = (h - c.height) / 2;
					c.alpha = 1;

					if (partiallySelected)
					{
						graphics.beginFill(0x000000);
						graphics.drawRect(c.x + 2.5, c.y + 2.5, c.width - 4,
										  c.height - 4);
						graphics.endFill();
						c.alpha = 0.7;
					}
				}
			}
		}
	}

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
	protected function ownerChangeHandler(event:Event):void
	{
		invalidateProperties();
	}
}
}
