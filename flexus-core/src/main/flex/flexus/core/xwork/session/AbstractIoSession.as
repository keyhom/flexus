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

package flexus.core.xwork.session
{

import flash.errors.IOError;
import flash.events.EventDispatcher;
import flash.net.FileReference;
import flash.utils.ByteArray;

import flexus.core.xwork.filterChain.IoFilterChain;
import flexus.core.xwork.future.FutureEvent;
import flexus.core.xwork.service.IoConnector;
import flexus.core.xwork.service.IoHandler;
import flexus.io.ByteBuffer;

import mx.logging.ILogger;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class AbstractIoSession extends EventDispatcher implements IoSession
{

	//--------------------------------------------------------------------------
	//
	//  Class properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// SESSION_ID_GENERATOR 
	//----------------------------------

	static private var SESSION_ID_GENERATOR:uint = 0;

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
	public function AbstractIoSession(service:IoConnector)
	{
		if (!service)
			throw new ArgumentError('service');

		this._service = service;
		this._sessionId = ++SESSION_ID_GENERATOR;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	// connected 
	//----------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get connected():Boolean
	{
		// must to be implemented.
		return false;
	}

	//----------------------------------
	// filterChain 
	//----------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get filterChain():IoFilterChain
	{
		return null;
	}

	//----------------------------------
	// handler 
	//----------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get handler():IoHandler
	{
		if (service)
			return service.handler;
		return null;
	}

	//----------------------------------
	// service 
	//----------------------------------

	private var _service:IoConnector;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get service():IoConnector
	{
		return _service;
	}

	//----------------------------------
	// sessionId 
	//----------------------------------

	private var _sessionId:uint;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get sessionId():uint
	{
		return _sessionId;
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override public function toString():String
	{
		return "IoSession#" + sessionId;
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param now
	 *  @param closeFuture
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function close(now:Boolean = false, closeFuture:Function = null):void
	{
		// must to be implemented.
		try
		{
			if (closeFuture != null)
				closeFuture.call(null, new FutureEvent(FutureEvent.CLOSED, this));
		}
		finally
		{
			service.remove(this);
		}
	}

	private var _attributes:Object = {};

	/**
	 *
	 *  @param key
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function containsAttribute(key:Object):Boolean
	{
		return key in _attributes;
	}

	/**
	 *
	 * @param message
	 * @throws ArgumentError
	 */
	public function flush(message:Object):void
	{
		if (!message)
			throw new ArgumentError('message');

		if (message is ByteBuffer)
		{
			var writeBytes:uint = writeBuffer(ByteBuffer(message));

			if (writeBytes > 0)
			{
				filterChain.fireMessageSent(message);
			}
		}
	}

	/**
	 *
	 *  @param key
	 *  @param defaultValue
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getAttribute(key:Object, defaultValue:Object = null):Object
	{
		var o:Object = null;

		if (key in _attributes)
		{
			o = _attributes[key];
		}

		if (!o && defaultValue)
			return defaultValue;

		return o;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getAttributeKeys():Array
	{
		var result:Array = [];

		for (var k:* in _attributes)
		{
			result.push(k);
		}
		return result;
	}

	/**
	 *
	 *  @param key
	 *  @param defaultValue
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function removeAttribute(key:Object, defaultValue:Object = null):Object
	{
		var originObject:Object = null

		if (key in _attributes)
		{
			originObject = _attributes[key];
			_attributes[key] = null;
			delete _attributes[key];
		}

		if (!originObject && defaultValue)
			return defaultValue;

		return originObject;
	}

	/**
	 *
	 *  @param key
	 *  @param oldValue
	 *  @param newValue
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function replaceAttribute(key:Object, oldValue:Object, newValue:Object):Object
	{
		if (key && (key in _attributes))
		{
			var obj:Object = _attributes[key];

			if (obj == oldValue)
			{
				_attributes[key] = newValue;
				return obj;
			}
		}
		return null;
	}

	/**
	 *
	 *  @param key
	 *  @param value
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function setAttribute(key:Object, value:Object):Object
	{
		var originObject:Object = _attributes[key];
		_attributes[key] = value;
		return originObject;
	}

	/**
	 *
	 *  @param key
	 *  @param value
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function setAttributeIfAbsent(key:Object, value:Object):Object
	{
		if (!(key in _attributes) || !_attributes[key])
			_attributes[key] = value;
		return null;
	}

	/**
	 *
	 *  @param message
	 *  @param writeFuture
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function write(message:Object, writeFuture:Function = null):void
	{
		if (!message)
			throw new ArgumentError('message');

		// checking the session is alive.
		if (!connected)
		{
			var future:FutureEvent = new FutureEvent(FutureEvent.WRITE, this,
													 new IOError('write to closed session!'));
			dispatchEvent(future);
			return;
		}

		var buf:ByteBuffer = null;

		if (message is ByteArray)
			message = ByteBuffer.wrap(ByteArray(message));

		if (message is ByteBuffer)
		{
			buf = message as ByteBuffer;

			if (buf && !buf.hasRemaining)
				throw new ArgumentError('message is empty. Forgot to call flip()?');
		}
		else if (message is String)
		{
			buf = new ByteBuffer;
			buf.putString(message.toString());
		}
		else if (message is FileReference)
		{
			// TODO: implemented by file stream.
		}

		// fitler the chain to write.
		filterChain.fireFilterWirte(message);
	}

	/**
	 * Writes the buffer and flush to the remote.
	 *
	 * @param buffer
	 * @return bytes length of the flushing.
	 */
	protected function writeBuffer(buffer:ByteBuffer):uint
	{
		// must to be implemented.
		return 0;
	}

	public function traceStatistics(log:ILogger):void
	{
		log.debug("Not found the statistics information now.");
	}
}
}
