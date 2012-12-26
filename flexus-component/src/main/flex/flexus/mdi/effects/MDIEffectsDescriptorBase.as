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

package flexus.mdi.effects
{

import flash.geom.Point;
import flash.geom.Rectangle;

import flexus.mdi.containers.MDIWindow;
import flexus.mdi.effects.effectClasses.MDIGroupEffectItem;
import flexus.mdi.managers.MDIManager;

import mx.core.IVisualElement;
import mx.effects.Effect;
import mx.effects.Parallel;

import spark.effects.Move;
import spark.effects.Resize;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class MDIEffectsDescriptorBase implements IMDIEffectsDescriptor
{

	public var duration:Number = 10;

	public function getWindowAddEffect(window:MDIWindow, manager:MDIManager):Effect
	{
		return new Effect();
	}

	public function getWindowMinimizeEffect(window:MDIWindow, manager:MDIManager,
											moveTo:Point = null):Effect
	{
		var parallel:Parallel = new Parallel();
		parallel.duration = this.duration;

		var resize:Resize = new Resize(window);
		resize.widthTo = window.minWidth;
		resize.duration = this.duration;
		//resize.heightTo = window.minimizeHeight;
		resize.heightTo = window.minHeight;
		parallel.addChild(resize);

		if (moveTo != null)
		{
			var move:Move = new Move(window);
			move.xTo = moveTo.x;
			move.yTo = moveTo.y;
			move.duration = this.duration;
			parallel.addChild(move);
		}

		return parallel;
	}

	public function getWindowRestoreEffect(window:MDIWindow, manager:MDIManager,
										   restoreTo:Rectangle):Effect
	{
		var parallel:Parallel = new Parallel();
		parallel.duration = this.duration;

		var resize:Resize = new Resize(window);
		resize.widthTo = restoreTo.width;
		resize.heightTo = restoreTo.height;
		resize.duration = this.duration;
		parallel.addChild(resize);

		var move:Move = new Move(window);
		move.xTo = restoreTo.x;
		move.yTo = restoreTo.y;
		move.duration = this.duration;
		parallel.addChild(move);

		return parallel;
	}

	public function getWindowMaximizeEffect(window:MDIWindow, manager:MDIManager,
											bottomOffset:Number = 0):Effect
	{
		var parallel:Parallel = new Parallel();
		parallel.duration = this.duration;

		var resize:Resize = new Resize(window);
		resize.widthTo = IVisualElement(manager.container).width;
		resize.heightTo = IVisualElement(manager.container).height - bottomOffset;
		resize.duration = this.duration;
		parallel.addChild(resize);

		var move:Move = new Move(window);
		move.xTo = 0;
		move.yTo = 0;
		move.duration = this.duration;
		parallel.addChild(move);

		return parallel;
	}

	public function getWindowCloseEffect(window:MDIWindow, manager:MDIManager):Effect
	{
		// have to return something so that EFFECT_END listener will fire
		var resize:Resize = new Resize(window);
		resize.duration = this.duration;
		resize.widthTo = window.width;
		resize.heightTo = window.height;

		return resize;
	}

	public function getWindowFocusStartEffect(window:MDIWindow, manager:MDIManager):Effect
	{
		return new Effect();
	}

	public function getWindowFocusEndEffect(window:MDIWindow, manager:MDIManager):Effect
	{
		return new Effect();
	}

	public function getWindowDragStartEffect(window:MDIWindow, manager:MDIManager):Effect
	{
		return new Effect();
	}

	public function getWindowDragEffect(window:MDIWindow, manager:MDIManager):Effect
	{
		return new Effect();
	}

	public function getWindowDragEndEffect(window:MDIWindow, manager:MDIManager):Effect
	{
		return new Effect();
	}

	public function getWindowResizeStartEffect(window:MDIWindow, manager:MDIManager):Effect
	{
		return new Effect();
	}

	public function getWindowResizeEffect(window:MDIWindow, manager:MDIManager):Effect
	{
		return new Effect();
	}

	public function getWindowResizeEndEffect(window:MDIWindow, manager:MDIManager):Effect
	{
		return new Effect();
	}

	public function getTileEffect(items:Array, manager:MDIManager):Effect
	{
		var parallel:Parallel = new Parallel();
		parallel.duration = this.duration;

		for each (var item:MDIGroupEffectItem in items)
		{
			manager.bringToFront(item.window);
			var move:Move = new Move(item.window);
			move.xTo = item.moveTo.x;
			move.yTo = item.moveTo.y;
			move.duration = this.duration;
			parallel.addChild(move);

			item.setWindowSize();
		}

		return parallel;
	}

	public function getCascadeEffect(items:Array, manager:MDIManager):Effect
	{
		var parallel:Parallel = new Parallel();
		parallel.duration = this.duration;

		for each (var item:MDIGroupEffectItem in items)
		{

			if (!item.isCorrectPosition)
			{
				var move:Move = new Move(item.window);
				move.xTo = item.moveTo.x;
				move.yTo = item.moveTo.y;
				move.duration = this.duration;
				parallel.addChild(move);

			}

			if (!item.isCorrectSize)
			{

				var resize:Resize = new Resize(item.window);
				resize.widthTo = item.widthTo;
				resize.heightTo = item.heightTo;
				resize.duration = this.duration;
				parallel.addChild(resize);

			}
		}

		return parallel;
	}

	public function reTileMinWindowsEffect(window:MDIWindow, manager:MDIManager,
										   moveTo:Point):Effect
	{
		var move:Move = new Move(window);
		move.duration = this.duration;
		move.xTo = moveTo.x;
		move.yTo = moveTo.y;
		return move
	}
}
}
