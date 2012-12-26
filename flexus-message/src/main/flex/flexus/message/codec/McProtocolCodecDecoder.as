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
import flexus.message.IoMessage;
import flexus.xwork.filters.codec.CumulativeProtocolDecoder;
import flexus.xwork.filters.codec.ProtocolDecoderOutput;

import mx.events.Request;

/**
 *
 * @author keyhom.c
 */
public class McProtocolCodecDecoder extends CumulativeProtocolDecoder
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 */
	public function McProtocolCodecDecoder()
	{
		super();
	}

	override protected function doDecode(session:IoSession, inb:ByteBuffer, out:ProtocolDecoderOutput):Boolean
	{
		var size:int = inb.getIntAt(inb.position);

		if (size == 0)
		{
			session.close();
				// invalid packet length.
		}

		if(session.containsAttribute(Endian))
		{
			var endian:String = session.getAttribute(Endian) as String;
			if(endian)
			{
				inb.order = endian;
			}
		}

		if (inb.hasRemaining && inb.remaining >= inb.getIntAt(inb.position))
		{
			size = inb.getIntAt(inb.position);
			var buf:ByteBuffer = inb.slice();
			buf.order = inb.order;
			inb.position += size;
			
			var req:Request = new Request(IoMessage.DECODE, false, false, buf);
			
			out.write(req);
			return true;
		}

		return false;
	}
}
}
