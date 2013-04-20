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

import flash.display.Graphics;
import flash.events.Event;

import mx.controls.CheckBox;
import mx.core.FlexSprite;
import mx.core.mx_internal;

use namespace mx_internal;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class MixedCheckBox extends CheckBox
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
	public function MixedCheckBox():void
	{
		this.addEventListener(Event.CHANGE, onCheckBoxChange);
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// value 
	//----------------------------------

	private var _value:int;

	[Bindable]
	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get value():int
	{
		return _value;
	}

	/**
	 *
	 *  @param v
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function set value(v:int):void
	{
		this.removeEventListener(Event.CHANGE, onCheckBoxChange);

		_value = v;

		switch (v)
		{
			case 0:
				this.selected = false;
				break;

			case 1:
				this.selected = true;
				break;

			case 2:
				this.selected = false;
				break;
		}


		updateGraphics();

		this.addEventListener(Event.CHANGE, onCheckBoxChange);
	}

	//----------------------------------
	// _someCheckMask 
	//----------------------------------

	private var _someCheckMask:FlexSprite;

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override protected function createChildren():void
	{
		super.createChildren();

		if (!_someCheckMask)
		{
			_someCheckMask = new FlexSprite;
			addChild(_someCheckMask);
		}
	}

	override protected function measure():void
	{
		super.measure();
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		setChildIndex(_someCheckMask, numChildren - 1);
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
	private function onCheckBoxChange(e:Event):void
	{
		if (this.selected)
		{
			value = 1;
		}
		else
		{
			value = 0;
		}
	}

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function updateGraphics():void
	{
		var g:Graphics = _someCheckMask.graphics;

		g.clear();

		if (value == 2)
		{
			//draw black square indicating some children selected some not
			g.beginFill(0x000000, 0.5);
			g.drawRect(4.5, -3.5, 8, 8);
			g.endFill();
		}
	}
}
}
