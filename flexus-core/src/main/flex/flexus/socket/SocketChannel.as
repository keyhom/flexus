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

import flash.errors.IOError;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
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
public class SocketChannel extends EventDispatcher
{
	//----------------------------------
	// CLEAR 
	//----------------------------------

	static public const CLEAR:int = 1 << 1;

	//----------------------------------
	// CONNECT 
	//----------------------------------

	static public const CONNECT:int = 1;

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param socket
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function SocketChannel(socket:Socket = null)
	{
		if (!socket)
			socket = new Socket;
		_socket = socket;
		super(_socket);
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// socket 
	//----------------------------------

	private var _socket:Socket;

	/**
	 *  Retrieves the socket object.
	 *
	 *  @return socket
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get socket():Socket
	{
		return _socket;
	}

	//----------------------------------
	// _remoteAddress 
	//----------------------------------

	private var _remoteAddress:SocketAddress;

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override public function toString():String
	{
		return "SocketChannel: [remoteAddress=" + _remoteAddress + ", connected=" +
			socket.connected + "]";
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	public function connect(address:SocketAddress, options:int = 3):IEventDispatcher
	{
		if (address)
		{
			_remoteAddress = address;
			if (socket && (options & CONNECT == CONNECT))
			{
				removeAllListeners();

				if ((options & CLEAR) == CLEAR)
					closeIfConnected(socket);

				socket.addEventListener(Event.CONNECT, connectHandler);
				socket.addEventListener(Event.CLOSE, closeHandler);
				socket.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);

				socket.connect(address.host.toString(), address.port);
			}
		}
		
		return this;
	}

	protected function closeHandler(event:Event):void
	{
		trace("Socket close: ", this);
	}

	protected function closeIfConnected(socket:Socket):void
	{
		if (socket && socket.connected)
			socket.close();
	}

	protected function connectHandler(event:Event):void
	{
		if (!hasEventListener(ProgressEvent.SOCKET_DATA))
			socket.addEventListener(ProgressEvent.SOCKET_DATA, recieveHandler,
									false, 0, true);
		trace("Socket Connected: ", this);
		var buf:ByteBuffer = new ByteBuffer;
		// length
		buf.putInt(0x00);
		// body
		buf.put(0x01);
		buf.putShort(0x11);
		buf.putShort(0x11);
		buf.putInt(0x22);
		buf.putInt(0x22);
		buf.putLong(1316352475072);

		buf.flip();
		buf.putIntAt(buf.position, buf.remaining);

		socket.writeBytes(buf.array);
		socket.flush();
	}

	protected function errorHandler(event:Event):void
	{
		trace("Socket ERROR:", this, event);
	}

	protected function recieveHandler(event:ProgressEvent):void
	{
		trace("Socket recieve:", this, event.bytesLoaded, event.bytesTotal);
	}

	protected function removeAllListeners():void
	{
		if (socket.hasEventListener(Event.CONNECT))
			socket.removeEventListener(Event.CONNECT, connectHandler);

		if (socket.hasEventListener(Event.CLOSE))
			socket.removeEventListener(Event.CLOSE, closeHandler);

		if (socket.hasEventListener(IOErrorEvent.IO_ERROR))
			socket.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);

		if (socket.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
			socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);

		if (socket.hasEventListener(ProgressEvent.SOCKET_DATA))
			socket.removeEventListener(ProgressEvent.SOCKET_DATA, recieveHandler);
	}
}
}
