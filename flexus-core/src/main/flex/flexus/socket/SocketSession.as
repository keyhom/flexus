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

import flash.net.Socket;

import flexus.core.xwork.filterChain.IoFilterChain;
import flexus.core.xwork.service.IoConnector;
import flexus.core.xwork.session.AbstractIoSession;
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
public class SocketSession extends AbstractIoSession
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param service
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function SocketSession(service:IoConnector, socket:Socket)
	{
		super(service);
		this._socket = socket;
		this._filterChain = new IoFilterChain(this);
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	// connected 
	//----------------------------------

	override public function get connected():Boolean
	{
		return socket.connected;
	}

	//----------------------------------
	// socket 
	//----------------------------------

	private var _socket:Socket;

	private var _filterChain:IoFilterChain;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	protected function get socket():Socket
	{
		return _socket;
	}

	override public function get filterChain():IoFilterChain
	{
		return _filterChain;
	}

	override protected function writeBuffer(buffer:ByteBuffer):uint
	{
		if (buffer.hasRemaining)
		{
			socket.writeBytes(buffer.array);
			socket.flush();
			return buffer.limit;
		}
		return 0;
	}

	override public function close(now:Boolean = false, closeFuture:Function =
								   null):void
	{
		if (socket)
		{
			if (socket.connected)
				socket.close();
		}

		super.close(false, closeFuture);
	}
}
}
