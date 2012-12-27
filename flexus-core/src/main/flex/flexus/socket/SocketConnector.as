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

package flexus.socket
{

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;

import flexus.core.xwork.future.FutureEvent;
import flexus.core.xwork.service.IoConnector;
import flexus.core.xwork.session.AbstractIoSession;
import flexus.core.xwork.session.IoSession;
import flexus.errors.IllegalStateError;
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
public class SocketConnector extends IoConnector
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
	public function SocketConnector()
	{
		super();
	}

	override protected function newSession(object:Object):IoSession
	{
		var session:SocketSession = new SocketSession(this, Socket(object));
		// construct the session map.
		super.newSession(session);

		if (!(object in sessions))
			sessions[object] = session;

		return session;
	}

	override protected function connect0(address:SocketAddress, connectFuture:Function):void
	{
		const socket:Socket = new Socket;
		socket.addEventListener(Event.CONNECT, function(e:Event):void
		{
			// connected.
			var s:Socket = e.currentTarget as Socket;
			s.flush();
			s.addEventListener(ProgressEvent.SOCKET_DATA, processDataQueue);
			s.addEventListener(IOErrorEvent.IO_ERROR, errorCaught);

			// new session construct.
			var session:IoSession = newSession(s);
			initSession(AbstractIoSession(session));

			if (connectFuture != null)
			{
				var future:FutureEvent = new FutureEvent(FutureEvent.CONNECTED,
														 session);
				connectFuture.call(null, future);
			}
		}, false, 0, true);

		socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorCaught);
		socket.addEventListener(Event.CLOSE, processClosed);


		if (!address)
			throw new IllegalStateError("Invalid remote address!");

		socket.timeout = 15000;
		socket.connect(address.host.toString(), address.port);
	}
	
	private function processDataQueue(e:ProgressEvent):void
	{
		if (e && e.type == ProgressEvent.SOCKET_DATA)
		{
			const s:Socket = e.currentTarget as Socket;

			if (s && (s in sessions) && s.bytesAvailable)
			{
				const buf:ByteBuffer = new ByteBuffer;
				
				s.readBytes(buf.array);

				if (buf.hasRemaining)
				{
					IoSession(sessions[s]).filterChain.fireMessageRecieved(buf);
				}
			}
		}
		// nothing to process.
	}

	private function processClosed(e:Event):void
	{
		if (e.target && (e.target is Socket))
		{
			var s:Socket = Socket(e.target);

			if (s in sessions)
			{
				var session:IoSession = IoSession(sessions[s]);
				session.service.remove(session);
			}
		}
	}

	private function errorCaught(e:Event):void
	{
		logger.info("ERROR CAUGHT.");
	}


}
}
