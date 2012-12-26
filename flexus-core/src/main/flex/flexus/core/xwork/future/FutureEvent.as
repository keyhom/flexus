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

package flexus.core.xwork.future
{

import flash.events.Event;

import flexus.core.xwork.session.IoSession;
import flexus.errors.IllegalStateError;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class FutureEvent extends Event
{

	static public const CONNECTED:String = "futureConnected";

	static public const WRITE:String = "futureWrote";

	static public const READ:String = "futureRead";

	static public const CLOSED:String = "futureClosed";
	
	static public const CLOSING:String = "futureClosing";

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
	public function FutureEvent(type:String, value:Object = null, error:Error =
								null)
	{
		super(type);
		this._value = value;
		this._error = error;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// completed 
	//----------------------------------

	public function get completed():Boolean
	{
		return _value is IoSession;
	}

	//----------------------------------
	// session 
	//----------------------------------

	public function get session():IoSession
	{
		if (_value is IoSession)
			return IoSession(_value);
		else if (_value is Error)
			throw new IllegalStateError(Error(_value).message);
		return null;
	}

	protected function get value():Object
	{
		if (type == CONNECT)
		{
			if (_error)
				return _error;
			return _value;
		}

		return _value;
	}

	public function get error():Error
	{
		return _error;
	}

	//----------------------------------
	// _value 
	//----------------------------------

	private var _value:Object;

	private var _error:Error;
}
}
