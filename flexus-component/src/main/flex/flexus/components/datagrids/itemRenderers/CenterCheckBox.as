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
import flash.text.TextField;

import mx.controls.CheckBox;

/**
 * @author keyhom.c
 */
public class CenterCheckBox extends CheckBox
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
	public function CenterCheckBox()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	// Overrides
	//
	//--------------------------------------------------------------------------

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		// 居中显示
		var n:int = numChildren;

		for (var i:int = 0; i < n; i++)
		{
			var c:DisplayObject = getChildAt(i);

			if (!(c is TextField))
			{
				c.x = Math.round((unscaledWidth - c.width) / 2);
				c.y = Math.round((unscaledHeight - c.height) / 2);
			}
		}
	}
}
}
