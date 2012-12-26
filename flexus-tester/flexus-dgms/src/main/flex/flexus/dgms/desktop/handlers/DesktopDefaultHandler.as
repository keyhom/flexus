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

package flexus.dgms.desktop.handlers
{

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

import flexus.mdi.effects.effectsLib.MDIVistaEffects;
import flexus.mdi.managers.MDIManager;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.FlexEvent;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DesktopDefaultHandler extends AbstractDesktopHandler
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param client
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function DesktopDefaultHandler()
	{
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param event
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function logoutConfirmHandler(event:Event):void
	{
		var logoutFuture:Function = function(e:CloseEvent):void
		{
			if (e.detail == Alert.NO)
				return;
			else
			{
				desktop.mdiGroup.windowManager.removeAll();
				desktop.dispatchEvent(new Event("logout", true, false));
			}
		};
		Alert.show("您确定要注销当前会话吗?", "注销确认", Alert.YES | Alert.NO, context.document,
				   logoutFuture);
	}

	[EventHandler(name = "creationComplete", useWeakReference = true)]
	/**
	 *
	 *  @param e
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function readyHandler(e:FlexEvent):void
	{
		Alert.okLabel = "确定";
		Alert.yesLabel = "是";
		Alert.noLabel = "否";
		Alert.cancelLabel = "取消";

		if (desktop.mdiGroup)
		{
			var manager:MDIManager = desktop.mdiGroup.windowManager;
			manager.effects = new MDIVistaEffects(75);
		}

		desktop.btnLogout.addEventListener(MouseEvent.CLICK, logoutConfirmHandler);
		startTimeTicker();
	}

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	protected function startTimeTicker():void
	{
		var timer:Timer = new Timer(1000);
		var func:Function = function(e:TimerEvent = null):void
		{
			desktop.currentTime = new Date().toLocaleTimeString();
		};

		timer.addEventListener(TimerEvent.TIMER, func, false, 0, true);
		func.call();
		timer.start();
	}
}
}
