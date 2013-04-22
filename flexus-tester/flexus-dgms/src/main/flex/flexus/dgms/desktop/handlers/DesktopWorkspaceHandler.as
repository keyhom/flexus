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

import flexus.dgms.desktop.RopenCommand;
import flexus.io.ByteBuffer;
import flexus.logging.LoggerFactory;
import flexus.message.IoMessageEvent;
import flexus.message.IoMessageInfo;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;
import mx.logging.ILogger;
import mx.utils.ObjectProxy;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DesktopWorkspaceHandler extends AbstractDesktopHandler
{
	//----------------------------------
	// LOGGER 
	//----------------------------------

	static internal const LOGGER:ILogger = LoggerFactory.getLogger(DesktopWorkspaceHandler);

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function DesktopWorkspaceHandler()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	[EventHandler(name = "creationComplete")]
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
		// load the worksapce menus.
		initializedWorkspaces();
	}

	/**
	 *
	 *  @param event
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	protected function changeWorkspaceHandler(event:Event):void
	{
		var item:Object = desktop.workspaceList.selectedItem;

		if ('name' in item)
		{
			new RopenCommand(item, desktop).execute(null);
		}
	}

	/**
	 *
	 *  @param e
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	protected function workspacesDataReceived(e:IoMessageEvent):void
	{
		if (e.buffer && e.buffer.hasRemaining)
		{
			var menus:ArrayCollection = new ArrayCollection();
			var buf:ByteBuffer = e.buffer;

			if (buf.getBoolean())
			{
				var size:int = buf.get();

				for (var i:int = 0; i < size; i++)
				{
					var o:ObjectProxy = new ObjectProxy;
					o.name = buf.getPrefixString();
					o.label = buf.getPrefixString();
					o.command = buf.getPrefixString();
					menus.addItem(o);
				}
			}

			desktop.startMenus = menus;
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
	private function initializedWorkspaces():void
	{
		var info:IoMessageInfo = client.bind(0x99);
		var writeFuture:Function = function(e:IoMessageEvent):void
		{
			info.removeEventListener(IoMessageEvent.MESSAGE_SENT, writeFuture);
			var buf:ByteBuffer = e.buffer;
			buf.put(true);
			buf.put(0x00); // load catalog enum oridnal.
		};
		info.addEventListener(IoMessageEvent.MESSAGE_SENT, writeFuture);
		info.addEventListener(IoMessageEvent.MESSAGE_RECEIVED, workspacesDataReceived);
		client.listen(info);
		client.send(info);

		desktop.workspaceList.addEventListener(Event.CHANGE, changeWorkspaceHandler);
	}
}
}
