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

import flash.errors.IllegalOperationError;
import flash.events.EventDispatcher;

import flexus.io.ByteBuffer;

import mx.core.EventPriority;
import mx.events.Request;

/**
 *  The event fired when the message being decoded.
 */
[Event(name = "decode", type = "mx.events.Request")]

/**
 *  The event fired when the message being encoded.
 */
[Event(name = "encode", type = "mx.events.Request")]

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class IoMessage extends EventDispatcher
{

	static public const DECODE:String = "decode";
	static public const ENCODE:String = "encode";

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	public function IoMessage(info:IoMessageInfo)
	{
		super();
		if(!info)
			throw new ArgumentError("Invalid information object for IoMessage!");

		this._info = info;

		init();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------

	//---------------------------------- 
	//  info 
	//---------------------------------- 

	/**
	 *  @private
	 *  Storage for the info property.
	 */
	private var _info:IoMessageInfo;

	/**
	 *  Retrieves the information interface of the IoMessage.
	 */
	public function get info():IoMessageInfo
	{
		return _info;
	}

	//----------------------------------
	//  contract
	//----------------------------------

	/**
	 *  Retrieves the contract object which binding with the message object.
	 */
	public function get contract():*
	{
		return info.contract;
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	final protected function init():void
	{
		this.addEventListener(DECODE, decodeHandler, false, EventPriority.DEFAULT_HANDLER, true);
		this.addEventListener(ENCODE, encodeHandler, false, EventPriority.DEFAULT_HANDLER, true);
	}

	/**
	 *  dispose
	 */
	public function dispose():void
	{
		// nothing to do.
	}

	/**
	 *  Retrieves the buffer object attach in the request.
	 */
	protected function getBuffer(e:Request):ByteBuffer
	{
		if(e.value && e.value is ByteBuffer)
		{
			return ByteBuffer(e.value);
		}

		return null;
	}

	//--------------------------------------------------------------------------
	//
	//  Event handlers 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Handle the data decoding.
	 */
	protected function decodeHandler(e:Request):void
	{
		// TODO: decode the data.
		throw new IllegalOperationError("Must implemented the decode handler!");
	}

	/**
	 *  Handle the data encoding.
	 */
	protected function encodeHandler(e:Request):void
	{
		// TODO: encode the data.
		throw new IllegalOperationError("Must implemented the encode handler!");
	}

}
}

