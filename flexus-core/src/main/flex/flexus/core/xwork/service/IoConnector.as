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

import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import flexus.core.xwork.XworkLogTarget;
import flexus.core.xwork.filterChain.DefaultIoFilterChainBuilder;
import flexus.core.xwork.filterChain.IoFilterChainBuilder;
import flexus.core.xwork.future.FutureEvent;
import flexus.core.xwork.session.AbstractIoSession;
import flexus.core.xwork.session.IoSession;
import flexus.errors.IllegalStateError;
import flexus.socket.SocketAddress;
import flexus.utils.ArrayQueue;
import flexus.utils.IQueue;

import mx.logging.ILogger;
import mx.logging.LogLogger;

[Event(name = "serviceActived", type = "flexus.core.xwork.service.IoServiceEvent")]
/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class IoConnector extends EventDispatcher
{

	//--------------------------------------------------------------------------
	//
	//  Class properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// DEFAULT_HANDLER 
	//----------------------------------

	static private var DEFAULT_HANDLER:IoHandler = new IoHandler;

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
	public function IoConnector()
	{
		super();
		logger = new LogLogger(getQualifiedClassName(IoConnector));
		XworkLogTarget.addLogger(logger);

		_connectQueue = new ArrayQueue;
		_closeQueue = new ArrayQueue;

		listeners = new IoServiceListenerSupport();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	protected var listeners:IoServiceListenerSupport;

	protected var sessions:Dictionary = new Dictionary();

	//----------------------------------
	// filterChain 
	//----------------------------------

	/**
	 *  @{inheritDoc}
	 */
	public function get filterChain():DefaultIoFilterChainBuilder
	{
		if (_filterChainBuilder is DefaultIoFilterChainBuilder)
			return DefaultIoFilterChainBuilder(_filterChainBuilder);
		throw new Error("this filterChainBuilder is not the default builder!");
	}

	//----------------------------------
	// filterChainBuilder 
	//----------------------------------

	private var _filterChainBuilder:IoFilterChainBuilder = new DefaultIoFilterChainBuilder;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get filterChainBuilder():IoFilterChainBuilder
	{
		return _filterChainBuilder;
	}

	/**
	 *  @private
	 */
	public function set filterChainBuilder(value:IoFilterChainBuilder):void
	{
		_filterChainBuilder = value;
	}

	//----------------------------------
	// handler 
	//----------------------------------

	private var _handler:IoHandler;

	/**
	 *  @{inheritDoc}
	 */
	public function get handler():IoHandler
	{
		return _handler;
	}

	/**
	 *
	 *  @param value
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function set handler(value:IoHandler):void
	{
		_handler = value;
	}

	//----------------------------------
	// transportMetadata 
	//----------------------------------

	/**
	 *  @{inheritDoc}
	 */
	public function get transportMetadata():Object
	{
		return null;
	}

	//----------------------------------
	// closeQueue 
	//----------------------------------

	private var _closeQueue:IQueue;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	protected function get closeQueue():IQueue
	{
		return _closeQueue;
	}

	//----------------------------------
	// connectQueue 
	//----------------------------------

	private var _connectQueue:IQueue;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	protected function get connectQueue():IQueue
	{
		return _connectQueue;
	}

	//----------------------------------
	// logging 
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
	protected var logger:ILogger;

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param remoteAddress
	 *  @param callback
	 *  @throws IllegalStateError
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function connect(remoteAddress:SocketAddress, callback:Function =
							null):void
	{
		if (!remoteAddress)
			throw new IllegalStateError("invalid remote address!");

		if (!handler)
		{
			handler = DEFAULT_HANDLER;
		}

		// first to create the connect request and add it to the connect queue.

		if (callback == null)
		{
			callback = function(future:FutureEvent):void
			{
				trace("default connect future handler.");
			};
		}

		connect0(remoteAddress, callback);
	}

	protected function connect0(remoteAddress:SocketAddress, connectFuture:Function):void
	{
		// must to be implemented.
	}

	protected function newSession(object:Object):IoSession
	{
		// must to be implemented.
		return null;
	}

	protected function initSession(session:AbstractIoSession):void
	{
		// TODO: build the Attribute map and Write-requests.
		filterChainBuilder.buildFilterChain(session.filterChain);
		session.service.listeners.fireSessionCreated(session);
	}

	public function remove(session:IoSession):void
	{
		session.filterChain.fireFilterClose();
		session.filterChain.fireSessionClosed();
		AbstractIoSession(session).traceStatistics(logger);
	}

}
}
