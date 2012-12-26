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

import flexus.core.xwork.filterChain.DefaultIoFilterChainBuilder;
import flexus.core.xwork.future.FutureEvent;
import flexus.core.xwork.service.IoConnector;
import flexus.core.xwork.service.IoHandler;
import flexus.core.xwork.service.IoServiceEvent;
import flexus.core.xwork.session.IoSession;
import flexus.errors.IllegalStateError;
import flexus.logging.LoggerFactory;
import flexus.socket.SocketAddress;
import flexus.socket.SocketConnector;
import flexus.utils.WeakReference;
import flexus.xwork.filters.codec.ProtocolCodecFactory;
import flexus.xwork.filters.codec.ProtocolCodecFilter;
import flexus.xwork.filters.logging.LoggingFilter;

import flash.events.Event;

import mx.events.Request;
import mx.logging.ILogger;

/**
 * Fired whent connected to the remote endpoint.
 */
[Event(name="connect", type="flash.events.Event")]
/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class IoMessageClient extends IoHandler
{

	//--------------------------------------------------------------------------
	//
	//  Class Variables
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	// LOGGING 
	//----------------------------------

	static private const LOGGING:String = "logging";

	//----------------------------------
	// PROTOCOL_CDEC 
	//----------------------------------

	static private const PROTOCOL_CDEC:String = "protocolCodec";

	//----------------------------------
	// LOGGER
	//----------------------------------

	static private const LOGGER:ILogger = LoggerFactory.getLogger(IoMessageClient);

	//----------------------------------
	// infos
	//----------------------------------

	/**
	 * @private
	 */
	static protected const infos:Object = {};

	//--------------------------------------------------------------------------
	//
	//  Class Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  Bind with contract to the <code>IoMessage</code> and return the info
	 *  interface for processing.
	 *
	 *  @param contract the specifial contract bind with the specifial message.
	 *  @param clazz the specifial class derived from the IoMessage
	 *
	 *  @throw ArgumentError
	 *  @throw IllegalStateError
	 */
	public function bind(contract:*, clazz:Class = null):IoMessageInfo
	{
		return new IoMessageInfoImpl(contract, clazz);
	}

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
	public function IoMessageClient()
	{
		super();
		init();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// factory 
	//----------------------------------

	/**
	 *  @return facotry of the protocol codec.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get factory():ProtocolCodecFactory
	{
		var chain:DefaultIoFilterChainBuilder = client.filterChain;

		if (chain && chain.contains(PROTOCOL_CDEC))
		{
			return ProtocolCodecFilter(chain.get(PROTOCOL_CDEC)).factory;
		}

		return null;
	}

	/**
	 *  @private
	 */
	public function set factory(value:ProtocolCodecFactory):void
	{
		if (!value)
			throw new ArgumentError("Invalid factory value!");

		if (!client)
			throw new IllegalStateError("Invalid client instance!");

		var chain:DefaultIoFilterChainBuilder = client.filterChain;

		if (chain)
		{
			if (chain.contains(PROTOCOL_CDEC))
				chain.replace(PROTOCOL_CDEC, new ProtocolCodecFilter(value));
			else
				chain.addLast(PROTOCOL_CDEC, new ProtocolCodecFilter(value));
		}
	}

	//----------------------------------
	// remoteAddress 
	//----------------------------------

	private var _remoteAddress:SocketAddress;

	/**
	 *  @return remote address.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get remoteAddress():SocketAddress
	{
		return _remoteAddress;
	}

	/**
	 *  @private
	 */
	public function set remoteAddress(value:SocketAddress):void
	{
		_remoteAddress = value;
	}

	//----------------------------------
	// client 
	//----------------------------------

	private var _client:IoConnector;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	protected function get client():IoConnector
	{
		return _client;
	}

	/**
	 *  @private
	 */
	protected function set client(value:IoConnector):void
	{
		if (!value)
			throw new ArgumentError("Invalid value for IoConnector!");

		_client = value;
	}

	//----------------------------------
	// matcher
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the matcher property.
	 */
	private var _matcher:IoMessageMatcher;

	/**
	 *  Retrieves the matcher of the client object.
	 */
	public function get matcher():IoMessageMatcher
	{
		return _matcher;
	}

	/**
	 *  @private
	 */
	public function set matcher(value:IoMessageMatcher):void
	{
		if (!value)
			throw new ArgumentError("Invalid value for IoMessageMatcher!");

		this._matcher = value;
	}

	//----------------------------------
	// useWeakContext
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the useWeakContext property.
	 */
	private var _useWeakContext:Boolean = false;

	[Inspectable(enumeration = "true,false", defaultValue = "false")]
	/**
	 *  Checks if the client use the weak context storing is.
	 */
	public function get useWeakContext():Boolean
	{
		return _useWeakContext;
	}

	/**
	 *  @private
	 */
	public function set useWeakContext(value:Boolean):void
	{
		_useWeakContext = value;
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param message
	 *  @param remoteAddress
	 *  @throws IllegalStateError
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function send(info:IoMessageInfo, remoteAddress:SocketAddress = null):void
	{
		if (!remoteAddress)
			remoteAddress = this.remoteAddress;

		if (!remoteAddress)
			throw new IllegalStateError("Invalid remoteAddress to connect!");

		client.connect(remoteAddress, function(future:FutureEvent):void
		{
			if (future && future.session && future.session.connected)
			{
				injectSession(info, future.session);
				dispatchEvent(new Event(Event.CONNECT));
				future.session.write(info);
			}
		});
	}

	protected function injectSession(info:IoMessageInfo, session:IoSession):void
	{
		if (info is IoMessageInfoImpl)
		{
			IoMessageInfoImpl(info).session = session;
		}
	}

	public function listen(info:IoMessageInfo):void
	{
		if (!info)
		{
			throw new ArgumentError("Invalid message info object to listen!");
		}

		if (useWeakContext)
		{
			var wr:WeakReference = new WeakReference(info);
			infos[info.contract] = wr;
		}
		else
		{
			infos[info.contract] = info;
		}
	}

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	protected function init():void
	{
		// initialize.
		if (!client)
			client = new SocketConnector;
		var chain:DefaultIoFilterChainBuilder = client.filterChain;
		chain.addLast(LOGGING, new LoggingFilter);

		if (factory)
			chain.addLast(PROTOCOL_CDEC, new ProtocolCodecFilter(factory));
		client.handler = this;

		if (!this.hasEventListener(IoServiceEvent.MESSAGE_RECIEVED))
			this.addEventListener(IoServiceEvent.MESSAGE_RECIEVED, messageRecievedHandler);
	}

	protected function messageRecievedHandler(e:IoServiceEvent):void
	{
		var req:Request = e.attachment as Request;

		if (req && req.type == IoMessage.DECODE)
		{
			if (matcher)
			{
				var info:IoMessageInfo = matcher.match(req, infos);

				if (info && info.message)
				{
					if (info is IoMessageInfoImpl)
						IoMessageInfoImpl(info).session = e.session;

					info.message.dispatchEvent(req);
				}
			}
		}
		else
		{
			LOGGER.warn("unknown message request...");
		}
	}
}
}

import flash.events.EventDispatcher;

import flexus.core.xwork.session.IoSession;
import flexus.errors.IllegalStateError;
import flexus.message.IoMessage;
import flexus.message.IoMessageInfo;

/**
 *  @author keyhom.c
 */
class IoMessageInfoImpl extends EventDispatcher implements IoMessageInfo
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param contract
	 */
	public function IoMessageInfoImpl(contract:*, clazz:Class = null)
	{
		super();

		if (!contract)
			throw new ArgumentError("Invalid contract!");

		this._contract = contract;

		if (clazz)
		{
			this._deriveType = clazz;

			try
			{
				this._message = new clazz(this);
			}
			catch (e:Error)
			{
				throw new IllegalStateError("Invalid deriveClass for IoMessage!");
			}
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  contract 
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the contract property.
	 */
	private var _contract:*;

	/**
	 *  Retrieves the contract object.
	 */
	public function get contract():*
	{
		return _contract;
	}

	//----------------------------------
	//  deriveType 
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the deriveType property.
	 */
	private var _deriveType:Class;

	/**
	 *  Retrieves the class of the derive type.
	 */
	public function get deriveType():Class
	{
		return _deriveType;
	}

	//----------------------------------
	//  message
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the message property.
	 */
	private var _message:IoMessage;

	/**
	 *  Retrieves the message bind with the info interface.
	 */
	public function get message():IoMessage
	{
		return _message;
	}

	//----------------------------------
	//  session
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the session property.
	 */
	private var _session:IoSession;

	/**
	 *  Retrieves the session object.
	 */
	public function get session():IoSession
	{
		return _session;
	}

	/**
	 *  @private
	 */
	public function set session(value:IoSession):void
	{
		if (!value)
			throw new ArgumentError("Invalid value for session!");

		this._session = value;
	}
}
