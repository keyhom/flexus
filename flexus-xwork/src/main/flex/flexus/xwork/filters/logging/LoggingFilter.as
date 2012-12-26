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

package flexus.xwork.filters.logging
{

import flexus.core.xwork.XworkLogTarget;
import flexus.core.xwork.filterChain.IoFilter;
import flexus.core.xwork.filterChain.NextFilter;
import flexus.core.xwork.session.IoSession;

import mx.logging.ILogger;
import mx.logging.LogLogger;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class LoggingFilter extends IoFilter
{

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
	public function LoggingFilter(name:String = null, level:int = 4)
	{
		logger = new LogLogger(name ? name : 'XWORK');
		this.logLevel = level;
		XworkLogTarget.addLogger(logger);
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// logLevel 
	//----------------------------------

	private var _logLevel:int;

	/**
	 *  Retrieves the level of the Logging.
	 *
	 *  @return logging level
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get logLevel():int
	{
		return _logLevel;
	}

	/**
	 *  @private
	 */
	public function set logLevel(value:int):void
	{
		this._logLevel = value;
	}

	//----------------------------------
	// logger 
	//----------------------------------

	private var logger:ILogger;

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param nextFilter
	 *  @param session
	 *  @param cause
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override public function exceptionCaught(nextFilter:NextFilter, session:IoSession,
											 cause:Error):void
	{
		logger.log(logLevel, "EXCEPTION - [{0}] {1}:{2} - {3}", cause.errorID,
				   cause.name, cause.message, cause.getStackTrace());
		nextFilter.exceptionCaught(session, cause);
	}

	/**
	 *
	 *  @param nextFilter
	 *  @param session
	 *  @param message
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override public function messageRecieved(nextFilter:NextFilter, session:IoSession,
											 message:Object):void
	{
		logger.log(logLevel, "RECIEVED  - {0}", message);
		nextFilter.messageRecieved(session, message);
	}

	/**
	 *
	 *  @param nextFilter
	 *  @param session
	 *  @param writeRequest
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override public function messageSent(nextFilter:NextFilter, session:IoSession,
										 message:Object):void
	{
		logger.log(logLevel, "SENT      - {0}", message);
		nextFilter.messageSent(session, message);
	}

	/**
	 *
	 *  @param nextFilter
	 *  @param session
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override public function sessionClosed(nextFilter:NextFilter, session:IoSession):void
	{
		logger.log(logLevel, "CLOSED");
		nextFilter.sessionClosed(session);
	}

	/**
	 *
	 *  @param nextFilter
	 *  @param session
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override public function sessionCreated(nextFilter:NextFilter, session:IoSession):void
	{
		logger.log(logLevel, "CREATED");
		nextFilter.sessionCreated(session);
	}

	/**
	 *
	 *  @param nextFilter
	 *  @param session
	 *  @param status
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override public function sessionIdle(nextFilter:NextFilter, session:IoSession,
										 status:int):void
	{
		logger.log(logLevel, "IDLE      - {0}", status);
		nextFilter.sessionIdle(session, status);
	}

}
}
