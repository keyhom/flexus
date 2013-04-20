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
import flash.events.TimerEvent;
import flash.utils.Timer;

import flexus.core.xwork.future.FutureEvent;
import flexus.core.xwork.service.IoConnector;
import flexus.core.xwork.session.IoSession;
import flexus.errors.IllegalStateError;
import flexus.socket.SocketAddress;
import flexus.utils.ArrayQueue;
import flexus.utils.IQueue;
import flexus.xwork.filters.codec.ProtocolCodecFactory;

/**
	 *  @author keyhom.c
	 */
	public class IoMessageSingletonClient extends IoMessageClient
	{
	
		/**
		 *  @private
		 *  Singleton client
		 */
		static private var _client:IoConnector;
	
		//----------------------------------------------------------------------
		//
		//  Constructor 
		//
		//----------------------------------------------------------------------
	
		/**
		 *  Constructor.
		 */
		public function IoMessageSingletonClient()
		{
			super();
		}
	
		//----------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//----------------------------------------------------------------------
	
		/**
		 *  @{inheritDoc}
		 */
		override protected function init():void
		{
			// doing nothing here.
			if (!client)
				super.init();
		}
	
		/**
		 *  @{inheritDoc}
		 */
		override protected function get client():IoConnector
		{
			return _client;
		}
	
		/**
		 *  @{inheritDoc}
		 */
		override protected function set client(value:IoConnector):void
		{
			if (!value)
				throw new ArgumentError("Invalid value for IoConnector!");
	
			_client = value;
		}
	
		/**
		 *  @{inheritDoc}
		 */
		override public function set factory(value:ProtocolCodecFactory):void
		{
			if (!super.factory)
				super.factory = value;
		}
	
		/**
		 *  @{inheritDoc}
		 */
		override public function send(info:IoMessageInfo, remoteAddress:SocketAddress =
									  null):void
		{
			if (_session)
			{
				super.injectSession(info, _session);
				_session.write(info);
			}
			else
			{
				if (!remoteAddress)
					remoteAddress = this.remoteAddress;
	
				if (!remoteAddress)
					throw new IllegalStateError("Invalid remoteAddress to connect!");
	
				if (_connecting)
				{
					_connectQueue.offer(info);
					return;
				}
	
				_connecting = true;
	
				if (!_timer)
				{
					_timer = new Timer(500);
					_timer.addEventListener(TimerEvent.TIMER, processConnectQueue);
				}
	
				client.connect(remoteAddress, function(future:FutureEvent):void
				{
					if (future && future.session && future.session.connected)
					{
						_session = future.session;
						_connecting = false;
						dispatchEvent(new Event(Event.CONNECT));
						send(info);
					}
				});
			}
		}
	
		//----------------------------------------------------------------------
		//
		//  Methods
		//
		//----------------------------------------------------------------------
	
		/**
		 *  @private
		 */
		private function processConnectQueue(e:TimerEvent):void
		{
			if (_session && !_connecting)
			{
				if (!_connectQueue.empty)
				{
					var info:IoMessageInfo = null;
	
					while ((info = _connectQueue.poll() as IoMessageInfo))
					{
						send(info);
					}
				}
				else
				{
					var t:Timer = e.currentTarget as Timer;
	
					if (t.running)
						t.stop();
				}
			}
		}
	
		/**
		 * Close the singleton session, and this'll clear all connecting task.
		 */
		public function close():void
		{
			if (!_connectQueue.empty)
			{
				_connectQueue.clear();
			}
	
			if (_session && _session.connected)
				_session.close();
	
			_connecting = false;
			_session = null;
	
			if (_timer)
				_timer.stop();
			_timer = null;
		}
	
		//----------------------------------------------------------------------
		//
		//  Variables 
		//
		//----------------------------------------------------------------------
	
		/**
		 *  @private
		 */
		private static var _session:IoSession;
	
		/**
		 *  @private
		 */
		private var _connecting:Boolean = false;
	
		/**
		 *  @private
		 */
		private var _connectQueue:IQueue = new ArrayQueue;
	
		/**
		 *  @private
		 */
		private var _timer:Timer;
	}
}
