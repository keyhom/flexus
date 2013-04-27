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
import flexus.mdi.effects.effectClasses.MDIGroupEffectItem;
import flexus.mdi.managers.MDIManager;

import mx.core.IVisualElement;
import mx.effects.Blur;
import mx.effects.Effect;
import mx.effects.Move;
import mx.effects.Parallel;
import mx.effects.Resize;
import mx.effects.Sequence;

/**
 * Collection of effects inspired by Windows Vista.
 */
public class MDIVistaEffects extends MDIEffectsDescriptorBase implements IMDIEffectsDescriptor
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param duration
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function MDIVistaEffects(duration:Number = 150):void
	{
		this.duration = duration;
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override public function getCascadeEffect(items:Array, manager:MDIManager):Effect
	{
		var parallel:Parallel = new Parallel();

		for each (var item:MDIGroupEffectItem in items)
		{
			var move:Move = new Move(item.window);
			move.xTo = item.moveTo.x;
			move.yTo = item.moveTo.y;
			//move.easingFunction = this.cascadeEasingFunction;
			move.duration = this.duration;
			parallel.addChild(move);

			var resize:Resize = new Resize(item.window);
			resize.widthTo = item.widthTo;
			resize.heightTo = item.heightTo;
			resize.duration = this.duration;
			parallel.addChild(resize);
		}

		return parallel;
	}

	override public function getTileEffect(items:Array, manager:MDIManager):Effect
	{
		var effect:Parallel = new Parallel();

		for each (var item:MDIGroupEffectItem in items)
		{
			if (!item.isCorrectPosition)
			{
				var move:Move = new Move(item.window);
				move.xTo = item.moveTo.x;
				move.yTo = item.moveTo.y;

				effect.addChild(move);
			}

			if (!item.isCorrectSize)
			{
				item.setWindowSize();
			}
		}

		effect.duration = this.duration;

		return effect;
	}

	override public function getWindowAddEffect(window:MDIWindow, manager:MDIManager):Effect
	{
		var parallel:Parallel = new Parallel(window);

		var blurSequence:Sequence = new Sequence();

		var blurOut:Blur = new Blur();
		blurOut.blurXFrom = 0;
		blurOut.blurYFrom = 0;
		blurOut.blurXTo = 10;
		blurOut.blurYTo = 10;


		blurSequence.addChild(blurOut);

		var blurIn:Blur = new Blur();
		blurIn.blurXFrom = 10;
		blurIn.blurYFrom = 10;
		blurIn.blurXTo = 0;
		blurIn.blurYTo = 0;

		blurSequence.addChild(blurIn);

		parallel.addChild(blurSequence);

		parallel.duration = this.duration;
		return parallel;
	}

	override public function getWindowCloseEffect(window:MDIWindow, manager:MDIManager):Effect
	{
		var blur:Blur = new Blur(window);
		blur.blurXFrom = 0;
		blur.blurYFrom = 0;
		blur.blurXTo = 10;
		blur.blurYTo = 10;
		blur.duration = this.duration;
		return blur;
	}

	override public function getWindowMaximizeEffect(window:MDIWindow, manager:MDIManager,
													 bottomOffset:Number = 0):Effect
	{
		var parallel:Parallel = new Parallel(window);
		
		var resize:Resize = new Resize(window);
		resize.heightTo = IVisualElement(manager.container).height - bottomOffset;
		resize.widthTo = IVisualElement(manager.container).width;
		resize.duration = duration;
		parallel.addChild(resize);
		
		var move:Move = new Move(window);
		move.xTo = 0;
		move.yTo = 0;
		move.duration = duration;
		parallel.addChild(move);
		
		parallel.end();
		return parallel;
	}

	override public function getWindowMinimizeEffect(window:MDIWindow, manager:MDIManager,
													 moveTo:Point = null):Effect
	{
		var sequence:Sequence = new Sequence(window);
		//sequence.duration = 200;
		var parallel:Parallel = new Parallel();

		var resize:Resize = new Resize(window);
		resize.widthTo = window.minWidth;
		resize.heightTo = window.minHeight;
		//resize.heightTo = window.minimizeHeight;
		resize.duration = this.duration;
		parallel.addChild(resize);


		var blurOut:Blur = new Blur();
		blurOut.blurXFrom = 1;
		blurOut.blurXTo = .2;
		blurOut.blurYFrom = 1;
		blurOut.blurYTo = .2;

		//parallel.addChild(blurOut);

		sequence.addChild(parallel);

		var move:Move = new Move(window);
		move.xTo = moveTo.x;
		move.yTo = moveTo.y;
		//move.easingFunction = minEasingFunction;
		move.duration = this.duration;
		sequence.addChild(move);

		var blurIn:Blur = new Blur();
		blurOut.blurXFrom = .2;
		blurOut.blurXTo = 1;
		blurOut.blurYFrom = .2;
		blurOut.blurYTo = 1;


		//sequence.addChild(blurIn);

		return sequence;
	}

	override public function getWindowRestoreEffect(window:MDIWindow, manager:MDIManager,
													restoreTo:Rectangle):Effect
	{
		var parallel:Parallel = new Parallel(window);

		var move:Move = new Move(window);
		move.xTo = restoreTo.x;
		move.yTo = restoreTo.y;
		move.duration = this.duration;
		parallel.addChild(move);

		var resize:Resize = new Resize(window);
		resize.widthTo = restoreTo.width;
		resize.heightTo = restoreTo.height;
		resize.duration = this.duration;
		parallel.addChild(resize);

		parallel.end();
		return parallel;
	}

	override public function reTileMinWindowsEffect(window:MDIWindow, manager:MDIManager,
													moveTo:Point):Effect
	{
		var move:Move = new Move(window);
		move.xTo = moveTo.x;
		move.yTo = moveTo.y;
		move.duration = this.duration;
		move.end();
		return move;
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param t
	 *  @param b
	 *  @param c
	 *  @param d
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function cascadeEasingFunction(t:Number, b:Number, c:Number, d:Number):Number
	{
		var ts:Number = (t /= d) * t;
		var tc:Number = ts * t;
		return b + c * (33 * tc * ts + -106 * ts * ts + 126 * tc + -67 * ts +
			15 * t);
	}

	/**
	 *
	 *  @param t
	 *  @param b
	 *  @param c
	 *  @param d
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function minEasingFunction(t:Number, b:Number, c:Number, d:Number):Number
	{
		var ts:Number = (t /= d) * t;
		var tc:Number = ts * t;
		return b + c * (0 * tc * ts + -2 * ts * ts + 10 * tc + -15 * ts + 8 *
			t);
	}
}
}
