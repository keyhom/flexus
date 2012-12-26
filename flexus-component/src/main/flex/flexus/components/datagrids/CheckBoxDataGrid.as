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

import flash.display.Sprite;
import flash.events.KeyboardEvent;

import flexus.components.datagrids.itemRenderers.CheckBoxHeaderRenderer;
import flexus.components.datagrids.itemRenderers.CheckBoxRenderer;

import mx.controls.CheckBox;
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.ClassFactory;

/**
 *
 * @author keyhom.c
 */
public class CheckBoxDataGrid extends DataGrid
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
	public function CheckBoxDataGrid()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// columns 
	//----------------------------------

	override public function set columns(value:Array):void
	{
		var frozenWidth:uint = 30;

		if (value && enableCheckBox)
		{
			var dgc:DataGridColumn = new DataGridColumn;
			dgc.resizable = false;
			dgc.draggable = false;
			dgc.sortable = false;
			dgc.editable = false;
			dgc.minWidth = frozenWidth;
			dgc.width = frozenWidth;

			dgc.headerRenderer = new ClassFactory(CheckBoxHeaderRenderer);
			dgc.itemRenderer = new ClassFactory(CheckBoxRenderer);

			if (value.length > 0)
			{
				value.reverse().push(dgc);
				value.reverse();
			}
		}

		super.columns = value;
	}

	//----------------------------------
	// enableCheckBox 
	//----------------------------------

	[Inspectable(enumeration = "true,false", defaultValue = "false")]
	private var _enableCheckBox:Boolean = false;

	/**
	 * 是否打开复选列
	 * @return true or false
	 */
	public function get enableCheckBox():Boolean
	{
		return _enableCheckBox;
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
	public function set enableCheckBox(value:Boolean):void
	{
		_enableCheckBox = value;
	}

	//----------------------------------------------------------------------
	//
	// Overrides
	//
	//----------------------------------------------------------------------

	override protected function commitProperties():void
	{
		super.commitProperties();

		if (enableCheckBox && !allowMultipleSelection)
			allowMultipleSelection = true;
	}

	override protected function drawItem(item:IListItemRenderer, selected:Boolean =
										 false, highlighted:Boolean = false,
										 caret:Boolean = false, transition:Boolean =
										 false):void
	{
		// whenever we draw the renderer, make sure we re-eval the checked state
		if (enableCheckBox && (item is CheckBox))
			CheckBox(item).invalidateProperties();
		super.drawItem(item, selected, highlighted, caret, transition);
	}

	override protected function drawSelectionIndicator(indicator:Sprite, x:Number,
													   y:Number, width:Number,
													   height:Number, color:uint,
													   itemRenderer:IListItemRenderer):void
	{
		// turn off selection indicator
		//			if(!enableCheckBox)
		super.drawSelectionIndicator(indicator, x, y, width, height, color, itemRenderer);
	}

	override protected function keyDownHandler(event:KeyboardEvent):void
	{
		if (enableCheckBox)
		{
			// this is technically illegal, but works
			event.ctrlKey = true;
			event.shiftKey = false;
		}
		super.keyDownHandler(event);
	}

	override protected function selectItem(item:IListItemRenderer, shiftKey:Boolean,
										   ctrlKey:Boolean, transition:Boolean =
										   true):Boolean
	{
		if (enableCheckBox)
		{
			if (item is CheckBox)
				return super.selectItem(item, false, true, transition);
			return false;
		}
		else
			return super.selectItem(item, shiftKey, ctrlKey, transition);
	}
}
}
