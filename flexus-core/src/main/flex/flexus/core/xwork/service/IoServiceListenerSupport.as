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

package flexus.core.xwork.service
{

import flash.events.IEventDispatcher;

import flexus.core.xwork.filterChain.IoFilterChain;
import flexus.core.xwork.session.IoSession;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class IoServiceListenerSupport
{

	private var managedSessions:Object;

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
	public function IoServiceListenerSupport()
	{
	}

	internal function fireSessionCreated(session:IoSession):void
	{
		var first:Boolean = !managedSessions;

		if (!managedSessions)
			managedSessions = {};

		if (!(session.sessionId in managedSessions))
			managedSessions[session.sessionId] = session;

		if (first)
		{
			fireServiceActivated();
		}

		var chain:IoFilterChain = session.filterChain;
		chain.fireSessionCreated();
//		chain.fireSessionOpened(); 
		// Fixed to remove this chain at future.

		session.service.dispatchEvent(new IoServiceEvent(IoServiceEvent.SESSION_CREATED,
														 session));
	}

	private function fireServiceActivated():void
	{
		// dispatch the activated event and log some data.
	}
}
}
