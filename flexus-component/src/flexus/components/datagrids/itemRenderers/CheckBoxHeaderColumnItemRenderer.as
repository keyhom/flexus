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

import flash.events.Event;
import flash.events.MouseEvent;

import flexus.components.datagrids.CheckBoxColumn;

import mx.controls.DataGrid;
import mx.events.DataGridEvent;

/**
 * @author jeremy
 */
public class CheckBoxHeaderColumnItemRenderer extends CenterCheckBox
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
	public function CheckBoxHeaderColumnItemRenderer()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// data 
	//----------------------------------

	private var _data:CheckBoxColumn;

	override public function get data():Object
	{
		return _data;
	}

	override public function set data(value:Object):void
	{
		_data = value as CheckBoxColumn;
		var dg:DataGrid = DataGrid(listData.owner);

		//dg.addEventListener(DataGridEvent.HEADER_RELEASE, sortEventHandler);
		if (!_data.hasEventListener("releaseChecked"))
			_data.addEventListener("releaseChecked", function(e:Event):void
			{
				trace(_data.checkedItems.length, dg.dataProvider.length);

				if (_data.checkedItems.length < dg.dataProvider.length)
				{
					_data._checked = false;
					selected = false;
				}
				else if (_data.checkedItems.length == dg.dataProvider.length)
				{
					_data._checked = true;
					selected = true;
				}
			});
		selected = _data._checked;
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override protected function clickHandler(event:MouseEvent):void
	{
		super.clickHandler(event);
		data._checked = selected;
		data.dispatchEvent(event);
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
	private function sortEventHandler(event:DataGridEvent):void
	{
		if (event.itemRenderer == this)
			event.preventDefault();
	}
}
}
