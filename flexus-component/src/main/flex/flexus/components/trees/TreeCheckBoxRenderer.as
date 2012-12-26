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

import flash.events.MouseEvent;
import mx.controls.Tree;
import mx.controls.treeClasses.TreeItemRenderer;

/**
 * @author keyhom.c
 */
public class TreeCheckBoxRenderer extends TreeItemRenderer
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 * Default Constructor
	 */
	public function TreeCheckBoxRenderer()
	{
		super();
	}

	//----------------------------------
	// checkbox 
	//----------------------------------

	/**
	 *
	 * @default
	 */
	protected var checkbox:MixedCheckBox;

	//----------------------------------
	// tree 
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
	private function get tree():MultiTree
	{
		return MultiTree(owner);
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override protected function commitProperties():void
	{
		super.commitProperties();

		if (data != null && data.hasOwnProperty(tree.checkField))
		{
			checkbox.value = data[tree.checkField];
		}
		else
		{
			checkbox.value = 0;
		}
	}

	override protected function createChildren():void
	{
		super.createChildren();

		if (!checkbox)
		{
			checkbox = new MixedCheckBox();
			checkbox.styleName = this;
			checkbox.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				checkItem(checkbox.value);
			});
			addChild(checkbox);
		}
	}

	override protected function measure():void
	{
		super.measure();
		measuredWidth += checkbox.getExplicitOrMeasuredWidth() + 4;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		checkbox.y = 10;

		if (icon)
		{
			checkbox.x = icon.x;
			icon.x = checkbox.x + checkbox.getExplicitOrMeasuredWidth() + 2;
			label.x = icon.x + icon.width + 2;
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 * @param value
	 */
	public function checkItem(value:int):void
	{
		if (data != null)
			data[tree.checkField] = value;

		if (data.hasOwnProperty("children") && data.children != null && data.
			children.length > 0)
		{
			updateChildrenChecked(data.children, value);
		}
		else if (data is XML && data.children().length() > 0)
		{
			updateChildrenChecked(data.children(), value);
		}

		//find out if all parents children are checked
		var itemParent:Object = tree.getParentItem(data);

		if (itemParent != null)
			updateParentChecked(itemParent, value);

		//invalidateDisplayList();
		Tree(owner).invalidateList();
	}

	/**
	 *
	 *  @param children
	 *  @param isChecked
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function updateChildrenChecked(children:Object, isChecked:int):void
	{
		//loop through children and copy value
		for each (var currentChild:Object in children)
		{
			currentChild[tree.checkField] = isChecked;

			if (currentChild.hasOwnProperty("children") && currentChild.children !=
				null && currentChild.children.length > 0)
			{
				updateChildrenChecked(currentChild.children, isChecked);
			}
			else if (currentChild is XML && currentChild.children().length() >
				0)
			{
				updateChildrenChecked(currentChild.children(), isChecked);
			}
		}
	}

	/**
	 *
	 *  @param parent
	 *  @param isChecked
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function updateParentChecked(parent:Object, isChecked:int):void
	{
		var allChecked:Boolean  = true;
		var noneChecked:Boolean = true;

		var siblings:Object;

		if (parent is XML)
		{
			siblings = parent.children();
		}
		else
		{
			siblings = parent.children;
		}

		for each (var currentSibling:Object in siblings)
		{
			if (currentSibling[tree.checkField] != 1)
			{
				allChecked = false;
			}

			if (currentSibling[tree.checkField] != undefined && currentSibling[tree.
				checkField] != 0)
			{
				noneChecked = false;
			}
		}

		var checkValue:int;

		if (allChecked)
		{
			checkValue = 1;
		}
		else if (noneChecked)
		{
			checkValue = 0;
		}
		else
		{
			checkValue = 2;
		}

		parent[tree.checkField] = checkValue;

		var itemParent:Object = tree.getParentItem(parent);

		if (itemParent != null)
			updateParentChecked(itemParent, isChecked);
	}
}
}
