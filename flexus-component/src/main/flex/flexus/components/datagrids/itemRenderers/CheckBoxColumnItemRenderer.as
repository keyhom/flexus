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
import mx.controls.dataGridClasses.DataGridColumn;
import mx.controls.dataGridClasses.DataGridListData;

/**
 * @author keyhom.c
 */
public class CheckBoxColumnItemRenderer extends CenterCheckBox
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
	public function CheckBoxColumnItemRenderer()
	{
		super();
		this.addEventListener(Event.CHANGE, onChangeHandler);
	}

	//--------------------------------------------------------------------------
	//
	// Overrides
	//
	//--------------------------------------------------------------------------

	override public function set data(value:Object):void
	{
		if (!(value is DataGridColumn))
		{
			// 首先得进行默认值的设置，确保数据对象中存在标记属性
			var dataField:String = DataGridListData(listData).dataField;

			if (!value.hasOwnProperty(dataField))
				value[dataField] = false;
			/*if(selected && selected == true)
			value[dataField] = true;*/

			// 保存当前对象引用
			item = value;

			if (!data)
			{
				if (column.hasEventListener(MouseEvent.CLICK))
					column.removeEventListener(MouseEvent.CLICK, columnHeaderClickHandler);
				column.addEventListener(MouseEvent.CLICK, columnHeaderClickHandler);
				selected = value[column.dataField];
			}
		}

		super.data = value;
	}

	//--------------------------------------------------------------------------
	//
	// Variables
	//
	//--------------------------------------------------------------------------

	/**
	 * @private
	 * 保存当前数据行数据对象
	 */
	private var _item:Object;

	/**
	 * 当前行数据对象
	 */
	public function get item():Object
	{
		return _item;
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
	public function set item(value:Object):void
	{
		_item = value;
	}

	//----------------------------------
	// column 
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
	private function get column():CheckBoxColumn
	{
		var dg:DataGrid = DataGrid(listData.owner);
		return dg.columns[listData.columnIndex] as CheckBoxColumn;
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
	private function columnHeaderClickHandler(event:MouseEvent):void
	{
		callLater(validateCheckedList);
		selected = CheckBoxColumn(event.currentTarget)._checked;

		trace(listData.rowIndex, listData.columnIndex);
	}

	//--------------------------------------------------------------------------
	//
	// Event handlers
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param e
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function onChangeHandler(e:Event):void
	{
		validateCheckedList();
		column.dispatchEvent(new Event("releaseChecked"));
	}

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function validateCheckedList():void
	{
		if (selected)
		{
			if (column.checkedItems.indexOf(data) == -1)
				column.checkedItems.push(data);
		}
		else
		{
			var arr:Array = column.checkedItems;
			var index:int = arr.indexOf(data);

			if (index != -1)
				column.checkedItems.splice(index, 1);
		}

		var dataField:String = DataGridListData(listData).dataField;
		data[dataField] = selected;
	}
}
}
