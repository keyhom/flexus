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

import flexus.net.IpAddress;
import flexus.utils.StringUtil;

/**
 *
 *  @author JeremyC
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class InetSocketAddress implements SocketAddress
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
	public function InetSocketAddress(host:*, port:Number = 80)
	{
		if (host is String)
		{
			if (!StringUtil.isEmpty(host))
			{
				if (host == '*')
					_host = new IpAddress;
				else if (IpAddress.isValid(host))
					_host = new IpAddress(host);
			}
		}

		this._port = port;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// host 
	//----------------------------------

	private var _host:IpAddress;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get host():IpAddress
	{
		return _host;
	}

	//----------------------------------
	// port 
	//----------------------------------

	private var _port:Number;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get port():uint
	{
		return _port;
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	public function toString():String
	{
		return host.toString() + ':' + port;
	}
}
}
