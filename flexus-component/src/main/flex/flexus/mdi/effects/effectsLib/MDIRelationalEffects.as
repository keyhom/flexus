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
import mx.effects.Effect;
import mx.effects.Move;
import mx.effects.Parallel;
import mx.effects.Resize;
import mx.events.EffectEvent;
import flexus.mdi.containers.MDIWindow;
import flexus.mdi.effects.MDIEffectsDescriptorBase;
import flexus.mdi.managers.MDIManager;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class MDIRelationalEffects extends MDIVistaEffects
{

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override public function getWindowMinimizeEffect(window:MDIWindow, manager:MDIManager,
													 moveTo:Point = null):Effect
	{

		var parallel:Parallel = super.getWindowMinimizeEffect(window, manager,
															  moveTo) as Parallel;

		parallel.addEventListener(EffectEvent.EFFECT_END, function():void
		{
			//manager.tile(true, 10);
		});


		return parallel;
	}

	override public function getWindowRestoreEffect(window:MDIWindow, manager:MDIManager,
													restoreTo:Rectangle):Effect
	{
		var parallel:Parallel = super.getWindowRestoreEffect(window, manager,
															 restoreTo) as Parallel;

		parallel.addEventListener(EffectEvent.EFFECT_START, function():void
		{
			//manager.tile(true, 10);
		});

		return parallel;
	}

	override public function reTileMinWindowsEffect(window:MDIWindow, manager:MDIManager,
													moveTo:Point):Effect
	{
		var move:Move = super.reTileMinWindowsEffect(window, manager, moveTo) as
			Move;
		manager.bringToFront(window);
		return move;
	}
}
}
