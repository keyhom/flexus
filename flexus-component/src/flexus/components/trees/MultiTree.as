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

package flexus.components.trees
{

import flash.events.Event;

import mx.collections.ICollectionView;
import mx.controls.Tree;
import mx.controls.treeClasses.TreeItemRenderer;
import mx.core.ClassFactory;
import mx.core.IFactory;
import mx.core.ScrollPolicy;
import mx.core.mx_internal;
import mx.events.StateChangeEvent;
import mx.states.State;

use namespace mx_internal;

/**
 *
 * @author keyhom.c
 */
public class MultiTree extends Tree
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 * Constructor
	 */
	public function MultiTree()
	{
		super();
		horizontalScrollPolicy = ScrollPolicy.AUTO;
		this.states = [new State({name: "single"}), new State({name: "multi"})];
		addEventListener(StateChangeEvent.CURRENT_STATE_CHANGING, function(e:StateChangeEvent):void
		{
			if (e.newState == 'multi')
			{
				_multiMode = true;

				if (!_multiRenderer)
					_multiRenderer = new ClassFactory(TreeCheckBoxRenderer);
				itemRenderer = _multiRenderer;
				rendererIsEditor = true;
			}
			else if (e.newState == 'single')
			{
				_multiMode = false;

				if (!_defaultRenderer)
					_defaultRenderer = new ClassFactory(TreeItemRenderer);
				itemRenderer = _defaultRenderer;
			}
		});
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// cascadeCheck 
	//----------------------------------

	private var _cascadeCheck:Boolean = true;

	/**
	 *
	 * @return
	 */
	public function get cascadeCheck():Boolean
	{
		return _cascadeCheck;
	}

	/**
	 *
	 * @param value
	 */
	public function set cascadeCheck(value:Boolean):void
	{
		_cascadeCheck = value;

		invalidateProperties();
	}

	//----------------------------------
	// checkField 
	//----------------------------------

	private var _checkField:String    = "checked";

	/**
	 *
	 * @return
	 */
	public function get checkField():String
	{
		return _checkField;
	}

	/**
	 *
	 * @param value
	 */
	public function set checkField(value:String):void
	{
		_checkField = value;
	}

	//----------------------------------
	// checkbox 
	//----------------------------------

	private var _checkbox:Boolean;

	/**
	 *
	 * @return
	 */
	public function get checkbox():Boolean
	{
		return _checkbox;
	}

	/**
	 *
	 * @param value
	 */
	public function set checkbox(value:Boolean):void
	{
		_checkbox = value;

		this.setCurrentState(value ? "multi" : "single");
	}

	//----------------------------------
	// checkedItems 
	//----------------------------------

	/**
	 *
	 * @return
	 */
	public function get checkedItems():Array
	{
		if (_multiMode && dataProvider)
		{
			var arr:Array = [];

			if (dataProvider is ICollectionView)
			{
				for each (var data:Object in dataProvider)
				{
					putCheckedItem(arr, data);
				}
			}
			else
			{
				putCheckedItem(arr, dataProvider);
			}

			return arr;
		}
		return null;
	}

	//----------------------------------
	// maxHorizontalScrollPosition 
	//----------------------------------

	// we need to override maxHorizontalScrollPosition because setting 
	// Tree's maxHorizontalScrollPosition adds an indent value to it, 
	// which we don't need as measureWidthOfItems seems to return exactly 
	// what we need.  Not only that, but getIndent() seems to be broken
	// anyways (SDK-12578).

	// I hate using mx_internal stuff, but we can't do 
	// super.super.maxHorizontalScrollPosition in AS 3, so we have to
	// emulate it.
	override public function get maxHorizontalScrollPosition():Number
	{
		return mx_internal::_maxHorizontalScrollPosition;
	}

	override public function set maxHorizontalScrollPosition(value:Number):void
	{
		mx_internal::_maxHorizontalScrollPosition = value;
		dispatchEvent(new Event("maxHorizontalScrollPositionChanged"));

		scrollAreaChanged = true;

		invalidateDisplayList();
	}

	//----------------------------------
	// selectedItems 
	//----------------------------------

	override public function get selectedItems():Array
	{
		return checkedItems;
	}

	//----------------------------------
	// _defaultRenderer 
	//----------------------------------

	private var _defaultRenderer:IFactory;

	//----------------------------------
	// _multiMode 
	//----------------------------------

	private var _multiMode:Boolean    = false;

	//----------------------------------
	// _multiRenderer 
	//----------------------------------

	private var _multiRenderer:IFactory;

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		// we call measureWidthOfItems to get the max width of the item renderers.
		// then we see how much space we need to scroll, setting maxHorizontalScrollPosition appropriately
		var diffWidth:Number = measureWidthOfItems(0, 0) - (unscaledWidth - viewMetrics.
			left - viewMetrics.right);

		if (diffWidth <= 0)
		{
			maxHorizontalScrollPosition = NaN;
			horizontalScrollPolicy = ScrollPolicy.OFF;
		}
		else
		{
			maxHorizontalScrollPosition = diffWidth;
			horizontalScrollPolicy = ScrollPolicy.ON;
		}

		super.updateDisplayList(unscaledWidth, unscaledHeight);
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 * 展开所有节点
	 */
	public function expandAll():void
	{

		if (dataProvider == null)
			return;

		for each (var item:* in dataProvider)
		{
			if (dataDescriptor.isBranch(item) && dataDescriptor.hasChildren(item))
			{
				expandChildrenOf(item, true);
			}
		}
	}

	/**
	 *
	 *  @param arr
	 *  @param item
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function putCheckedItem(arr:Array, item:Object):void
	{
		if (dataDescriptor.isBranch(item) && dataDescriptor.hasChildren(item))
		{
			var items:Object;

			if (item is ICollectionView)
			{
				items = item;
			}
			else
			{
				items = dataDescriptor.getChildren(item);
			}

			for each (var data:Object in items)
			{
				if (data.hasOwnProperty(checkField))
				{
					if (data[checkField] == 1)
						arr.push(data);

					if (dataDescriptor.isBranch(data) && dataDescriptor.hasChildren(data))
					{
						putCheckedItem(arr, data);
					}
				}
			}
		}
	}
}
}
