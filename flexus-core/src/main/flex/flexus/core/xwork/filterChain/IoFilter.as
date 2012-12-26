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

package flexus.core.xwork.filterChain
{

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
public class IoFilter
{

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 */
	public function destroy():void
	{
	}

	/**
	 *
	 * @param nextFilter
	 * @param session
	 * @param cause
	 */
	public function exceptionCaught(nextFilter:NextFilter, session:IoSession,
									cause:Error):void
	{
		nextFilter.exceptionCaught(session, cause);
	}

	/**
	 *
	 * @param nextFilter
	 * @param session
	 */
	public function filterClose(nextFilter:NextFilter, session:IoSession):void
	{
		nextFilter.filterClose(session);
	}

	/**
	 *
	 * @param nextFilter
	 * @param session
	 * @param message
	 */
	public function filterWrite(nextFilter:NextFilter, session:IoSession, message:Object):void
	{
		nextFilter.filterWrite(session, message);
	}

	/**
	 *
	 */
	public function init():void
	{
	}

	/**
	 *
	 * @param nextFilter
	 * @param session
	 * @param message
	 */
	public function messageRecieved(nextFilter:NextFilter, session:IoSession,
									message:Object):void
	{
		nextFilter.messageRecieved(session, message);
	}

	/**
	 *
	 * @param nextFilter
	 * @param session
	 * @param message
	 */
	public function messageSent(nextFilter:NextFilter, session:IoSession, message:Object):void
	{
		nextFilter.messageSent(session, message);
	}

	/**
	 *
	 * @param filter
	 * @param name
	 * @param nextFilter
	 */
	public function onPostAdd(filter:IoFilterChain, name:String, nextFilter:NextFilter):void
	{
	}

	/**
	 *
	 * @param filter
	 * @param name
	 * @param nextFilter
	 */
	public function onPostRemove(filter:IoFilterChain, name:String, nextFilter:NextFilter):void
	{
	}

	/**
	 *
	 * @param filter
	 * @param name
	 * @param nextFilter
	 */
	public function onPreAdd(filter:IoFilterChain, name:String, nextFilter:NextFilter):void
	{
	}

	/**
	 *
	 * @param filter
	 * @param name
	 * @param nextFilter
	 */
	public function onPreRemove(filter:IoFilterChain, name:String, nextFilter:NextFilter):void
	{
	}

	/**
	 *
	 * @param nextFilter
	 * @param session
	 */
	public function sessionClosed(nextFilter:NextFilter, session:IoSession):void
	{
		nextFilter.sessionClosed(session);
	}

	/**
	 *
	 * @param nextFilter
	 * @param session
	 */
	public function sessionCreated(nextFilter:NextFilter, session:IoSession):void
	{
		nextFilter.sessionCreated(session);
	}

	/**
	 *
	 * @param nextFilter
	 * @param session
	 * @param status
	 */
	public function sessionIdle(nextFilter:NextFilter, session:IoSession, status:int):void
	{
		nextFilter.sessionIdle(session, status);
	}

}
}
