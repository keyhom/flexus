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

package flexus.dgms.login.controls.events
{

import flash.events.Event;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class LoginEvent extends Event
{

	//--------------------------------------------------------------------------
	//
	//  Class properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// READY 
	//----------------------------------

	/**
	 * The event type for user login message ready from authronzier.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion Flex 3
	 */
	static public const READY:String = "loginReady";

	//----------------------------------
	// SUBMIT 
	//----------------------------------

	/**
	 * The event type for user submit the login event.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion Flex 3
	 */
	static public const SUBMIT:String = "loginSubmit";

	//----------------------------------
	// VALIDATED 
	//----------------------------------

	/**
	 * The event type for user submitted being validated.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion Flex 3
	 */
	static public const VALIDATED:String = "loginValidated";

	//----------------------------------
	// VALIDATING 
	//----------------------------------

	/**
	 * The event type for user submitted being validating.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion Flex 3
	 */
	static public const VALIDATING:String = "loginValidating";

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 * 
	 *  @param type
	 *  @param user
	 *  @param ready
	 *  @param success
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function LoginEvent(type:String, user:*, ready:Boolean = false, success:Boolean =
							   false)
	{
		super(type, false, false);
		this._user = user;
		this._ready = ready;
		this._success = success;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// ready 
	//----------------------------------
	
	private var _ready:Boolean;

	/**
	 * 
	 *  @return 
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get ready():Boolean
	{
		return _ready;
	}

	//----------------------------------
	// success 
	//----------------------------------

	private var _success:Boolean;

	/**
	 * 
	 *  @return 
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get success():Boolean
	{
		return _success;
	}

	//----------------------------------
	// user 
	//----------------------------------

	private var _user:*;

	/**
	 * 
	 *  @return 
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get user():*
	{
		return _user;
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 * 
	 *  @return 
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override public function toString():String
	{
		return "LOGIN EVENT: [ type=" + type + ", user=" + user + " ]";
	}
}
}
