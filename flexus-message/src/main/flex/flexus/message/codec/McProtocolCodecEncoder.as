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

package flexus.message.codec
{

import flash.utils.Endian;

import flexus.core.xwork.session.IoSession;
import flexus.io.ByteBuffer;
import flexus.logging.LoggerFactory;
import flexus.message.IoMessage;
import flexus.message.IoMessageInfo;
import flexus.xwork.filters.codec.ProtocolEncoder;
import flexus.xwork.filters.codec.ProtocolEncoderOutput;

import mx.events.Request;
import mx.logging.ILogger;

/**
 *
 * @author keyhom.c
 */
public class McProtocolCodecEncoder extends ProtocolEncoder
{

	static private const LOGGER:ILogger = LoggerFactory.getLogger(McProtocolCodecEncoder);

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 */
	public function McProtocolCodecEncoder()
	{
		super();
	}

	override public function encode(session:IoSession, message:Object, out:ProtocolEncoderOutput):void
	{
		if (message is IoMessageInfo)
		{
			var info:IoMessageInfo = IoMessageInfo(message);
			var buf:ByteBuffer = new ByteBuffer;

			if(session.containsAttribute(Endian))
			{
				var endian:String = session.getAttribute(Endian) as String;
				if(endian)
				{
					buf.order = endian;
				}
			}

			var req:Request = new Request(IoMessage.ENCODE, false, false, buf);
			info.message.dispatchEvent(req);

			if (buf.remaining)
				out.write(buf);
		}
	}
}
}
