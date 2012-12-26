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

package flexus.message
{

import flash.events.Event;

import flexus.io.ByteBuffer;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class IoMessageEvent extends Event
{

	//--------------------------------------------------------------------------
	//
	//  Class properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// READ 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const MESSAGE_RECIEVED:String = "messageRecieved";

	//----------------------------------
	// READY 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const READY:String = "ready";

	//----------------------------------
	// RESOLVED 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const RESOLVED:String = "resolved";

	//----------------------------------
	// WRITE 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const MESSAGE_SENT:String = "messageSent";

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param type
	 *  @param bubbles
	 *  @param cancelable
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function IoMessageEvent(type:String, attach:Object = null)
	{
		super(type, false, false);

		this._attach = attach;

		if (attach && attach is ByteBuffer)
			_buf = attach as ByteBuffer;
		else
			_buf = new ByteBuffer;
	}

	//--------------------------------------------------------------------------
	//
	// Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	// buffer
	//----------------------------------

	private var _buf:ByteBuffer;

	/**
	 * Retrieves the buffer for decoding or encoding.
	 *
	 * @return buffer
	 */
	public function get buffer():ByteBuffer
	{
		return _buf;
	}

	//----------------------------------
	// attach
	//----------------------------------

	/**
	 * @private
	 */
	private var _attach:*;

	/**
	 * Retrieves the attach object.
	 */
	public function get attach():*
	{
		return _attach;
	}

}
}
