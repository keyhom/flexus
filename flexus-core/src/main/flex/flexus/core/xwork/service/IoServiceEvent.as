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

import flash.events.Event;
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
public class IoServiceEvent extends Event
{
	//----------------------------------
	// EXCEPTION_CAUSED 
	//----------------------------------

	/**
	 *
	 * @default
	 */
	static public const EXCEPTION_CAUSED:String = "exceptionCaused";

	//----------------------------------
	// MESSAGE_RECIEVED 
	//----------------------------------

	/**
	 *
	 * @default
	 */
	static public const MESSAGE_RECIEVED:String = "messageRecieved";

	//----------------------------------
	// MESSAGE_SENT 
	//----------------------------------

	/**
	 *
	 * @default
	 */
	static public const MESSAGE_SENT:String = "messageSent";

	//----------------------------------
	// SERVICE_ACTIVATED 
	//----------------------------------

	/**
	 *
	 * @default
	 */
	static public const SERVICE_ACTIVATED:String = "serviceActivated";

	//----------------------------------
	// SERVICE_CLOSED 
	//----------------------------------

	/**
	 *
	 * @default
	 */
	static public const SERVICE_CLOSED:String = "serviceClosed";

	//----------------------------------
	// SERVICE_DEACTIVATED 
	//----------------------------------

	/**
	 *
	 * @default
	 */
	static public const SERVICE_DEACTIVATED:String = "serviceDeactivated";

	//----------------------------------
	// SESSION_CLOSE 
	//----------------------------------

	/**
	 *
	 * @default
	 */
	static public const SESSION_CLOSED:String = "sessionClosed";

	//----------------------------------
	// SESSION_CREATED 
	//----------------------------------

	/**
	 *
	 * @default
	 */
	static public const SESSION_CREATED:String = "sessionCreated";

	//----------------------------------
	// SESSION_IDLE 
	//----------------------------------

	/**
	 *
	 * @default
	 */
	static public const SESSION_IDLED:String = "sessionIdled";

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param type
	 *  @param session
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function IoServiceEvent(type:String, session:IoSession = null, attachment:Object =
								   null)
	{
		super(type, false, false);
		this.session = session;
		this.attachment = attachment;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// attachment 
	//----------------------------------

	/**
	 *
	 * @default
	 */
	public var attachment:Object;

	//----------------------------------
	// session 
	//----------------------------------

	/**
	 *
	 * @default
	 */
	public var session:IoSession;
}
}
