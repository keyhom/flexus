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

package flexus.mdi.effects.effectsLib
{

import flash.geom.Point;
import flash.geom.Rectangle;

import flexus.mdi.containers.MDIWindow;
import flexus.mdi.effects.IMDIEffectsDescriptor;
import flexus.mdi.effects.MDIEffectsDescriptorBase;
import flexus.mdi.managers.MDIManager;

import mx.core.IVisualElement;
import mx.effects.Effect;
import mx.effects.Move;
import mx.effects.Resize;
import mx.effects.Sequence;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class MDILinearEffects extends MDIEffectsDescriptorBase implements IMDIEffectsDescriptor
{

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override public function getWindowCloseEffect(window:MDIWindow, manager:MDIManager):Effect
	{
		window.minWidth = window.minHeight = 1;

		var resize:Resize = new Resize(window);
		resize.widthTo = resize.heightTo = 1;
		resize.duration = 100;
		return resize;
	}

	override public function getWindowMaximizeEffect(window:MDIWindow, manager:MDIManager,
													 bottomOffset:Number = 0):Effect
	{
		var seq:Sequence = new Sequence(window);

		var moveX:Move = new Move(window);
		moveX.xTo = 0;
		moveX.duration = 100;
		seq.addChild(moveX);

		var moveY:Move = new Move(window);
		moveY.yTo = 0;
		moveY.duration = 100;
		seq.addChild(moveY);

		var resizeW:Resize = new Resize(window);
		resizeW.widthTo = IVisualElement(manager.container).width;
		resizeW.duration = 100;
		seq.addChild(resizeW);

		var resizeH:Resize = new Resize(window);
		resizeH.heightTo = IVisualElement(manager.container).height - bottomOffset;
		resizeH.duration = 100;
		seq.addChild(resizeH);

		seq.end();
		return seq;
	}

	override public function getWindowMinimizeEffect(window:MDIWindow, manager:MDIManager,
													 moveTo:Point = null):Effect
	{
		var seq:Sequence = new Sequence();

		var resizeW:Resize = new Resize(window);
		resizeW.widthTo = window.minWidth;
		resizeW.duration = 100;
		seq.addChild(resizeW);

		var resizeH:Resize = new Resize(window);
		//resizeH.heightTo = window.minimizeHeight;
		resizeH.heightTo = window.minHeight;
		resizeH.duration = 100;
		seq.addChild(resizeH);

		var moveX:Move = new Move(window);
		moveX.xTo = moveTo.x;
		moveX.duration = 100;
		seq.addChild(moveX);

		var moveY:Move = new Move(window);
		moveY.yTo = moveTo.y;
		moveY.duration = 100;
		seq.addChild(moveY);

		seq.end();
		return seq;
	}

	override public function getWindowRestoreEffect(window:MDIWindow, manager:MDIManager,
													restoreTo:Rectangle):Effect
	{
		var seq:Sequence = new Sequence();

		var moveY:Move = new Move(window);
		moveY.yTo = restoreTo.y;
		moveY.duration = 100;
		seq.addChild(moveY);

		var moveX:Move = new Move(window);
		moveX.xTo = restoreTo.x;
		moveX.duration = 100;
		seq.addChild(moveX);

		var resizeW:Resize = new Resize(window);
		resizeW.widthTo = restoreTo.width;
		resizeW.duration = 100;
		seq.addChild(resizeW);

		var resizeH:Resize = new Resize(window);
		resizeH.heightTo = restoreTo.height;
		resizeH.duration = 100;
		seq.addChild(resizeH);

		seq.end();
		return seq;
	}
}
}
