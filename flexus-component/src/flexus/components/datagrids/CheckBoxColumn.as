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

package flexus.components.datagrids
{

import flash.events.Event;

import mx.controls.dataGridClasses.DataGridColumn;

[Event(name = "click", type = "flash.events.MouseEvent")]
/**
 * @author keyhom.c
 */
public class CheckBoxColumn extends DataGridColumn
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param columnName
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function CheckBoxColumn(columnName:String = null)
	{
		super(columnName);
		addEventListener(Event.CLEAR, onClearHandler);
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// _checked 
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
	public var _checked:Boolean = false;

	//----------------------------------
	// checkedItems 
	//----------------------------------

	private var _checkedItems:Array = new Array;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get checkedItems():Array
	{
		return _checkedItems;
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
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
	private function onClearHandler(e:Event):void
	{
		if (_checkedItems)
			_checkedItems = new Array;
		_checked = false;
	}
}
}
