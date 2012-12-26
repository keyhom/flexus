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

package flexus.dgms.message
{

import flexus.core.xwork.service.IoServiceEvent;
import flexus.message.IoMessageInfo;
import flexus.message.IoMessageMatcher;
import flexus.message.IoMessageSingletonClient;
import flexus.message.codec.McProtocolCodecFactory;
import flexus.xwork.filters.codec.ProtocolCodecFactory;

import mx.managers.CursorManager;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class McService extends IoMessageSingletonClient
{

	static private const MATCHER:IoMessageMatcher = new McIoMessageMatcher;

	static private const FACTORY:ProtocolCodecFactory = new McProtocolCodecFactory;

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
	public function McService()
	{
		super();
	}

	override protected function init():void
	{
		super.init();
		factory = FACTORY;
		matcher = MATCHER;

		this.addEventListener(IoServiceEvent.SESSION_CLOSED, sessionClosedHandler);
		this.addEventListener(IoServiceEvent.EXCEPTION_CAUSED, exceptionCaughtHandler);
	}

	protected function sessionClosedHandler(e:IoServiceEvent):void
	{
		CursorManager.removeBusyCursor();
	}

	protected function exceptionCaughtHandler(e:IoServiceEvent):void
	{
		CursorManager.removeBusyCursor();
	}

	override public function bind(contract:*, clazz:Class = null):IoMessageInfo
	{
		if (!clazz)
		{
			clazz = McIoMessage;
		}
		return super.bind(contract, clazz);
	}
}
}
