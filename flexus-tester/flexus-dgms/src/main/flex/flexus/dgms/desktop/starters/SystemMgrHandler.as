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

package flexus.dgms.desktop.starters
{

import flash.events.TimerEvent;
import flash.system.ApplicationDomain;
import flash.utils.Timer;

import flexus.mdi.containers.MDIGroup;
import flexus.mdi.containers.MDIWindow;
import flexus.mdi.effects.effectsLib.MDIVistaEffects;
import flexus.mdi.managers.MDIManager;

import mx.events.EffectEvent;
import mx.events.FlexEvent;
import mx.events.ModuleEvent;
import mx.modules.IModuleInfo;
import mx.modules.Module;
import mx.modules.ModuleManager;

import org.osmf.events.TimeEvent;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SystemMgrHandler
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function SystemMgrHandler(desktop:Desktop)
	{
		super();
		this.desktop = desktop;
	}

	private var desktop:Desktop;

	private var info:IModuleInfo;

	private var win:MDIWindow;

	private var ct:Number;
	
	private var domain:ApplicationDomain;

	public function invoke(item:Object):void
	{
		if (info == null)
		{
			win = new MDIWindow;
			var completeFuture:Function = function(e:FlexEvent):void
			{
				win.removeEventListener(FlexEvent.CREATION_COMPLETE, completeFuture);
				desktop.invalidateStarterIndex();
			};
			win.title = item['label'] ? item['label'] : 'Unknown';
			win.width = desktop.mdiGroup.width * 0.75;
			win.height = desktop.mdiGroup.height * 0.75;
			win.addEventListener(FlexEvent.CREATION_COMPLETE, completeFuture);
			desktop.mdiGroup.windowManager.addCenter(win);

			// load the modules first and when it's loaded complete, should add it to the window.
			info = ModuleManager.getModule("SystemMgr.swf");
			info.addEventListener(ModuleEvent.READY, onModuleReady);
			domain = new ApplicationDomain(ApplicationDomain.currentDomain);
			info.load(domain, null, null, desktop.moduleFactory);
		}
	}

	private function onModuleReady(e:ModuleEvent):void
	{
		var info:IModuleInfo = e.currentTarget as IModuleInfo;

		if (info && info.ready)
		{
			var obj:Object = info.factory.create();

			if (obj is Module)
			{
				var module:Module = Module(obj);
				win.maximize();
				win.addElement(module);
			}
		}
	}
}
}
