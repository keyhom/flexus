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

package flexus.dgms.message
{

import flexus.io.ByteBuffer;
import flexus.logging.LoggerFactory;
import flexus.message.IoMessage;
import flexus.message.IoMessageEvent;
import flexus.message.IoMessageInfo;

import mx.events.Request;
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
public class McIoMessage extends IoMessage
{

	static private const LOGGER:ILogger = LoggerFactory.getLogger(McIoMessage);

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param info
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function McIoMessage(info:IoMessageInfo)
	{
		super(info);
	}

	override protected function decodeHandler(e:Request):void
	{
		var buf:ByteBuffer;

		if ((buf = getBuffer(e)))
		{
			var size:uint = buf.getInt();
			var major:int = buf.get();
			var minor:int = buf.get();
			var build:int = buf.getShort();
			var revision:int = buf.getShort();

			var _contract:int = buf.getShort();
			var _commandId:int = buf.getInt();

			var event:IoMessageEvent = new IoMessageEvent(IoMessageEvent.MESSAGE_RECEIVED,
														  buf);
			info.dispatchEvent(event);
		}
	}

	override protected function encodeHandler(e:Request):void
	{
		var buf:ByteBuffer;

		if ((buf = getBuffer(e)))
		{
			buf.putInt(0x00);
			buf.put(0x01);
			buf.put(0x00);
			buf.putShort(0x00);
			buf.putShort(0xFFFF);

			buf.putShort(int(contract));
			buf.putInt(new Date().valueOf());

			var sliceBuf:ByteBuffer = buf.slice();
			sliceBuf.order = buf.order;

			var event:IoMessageEvent = new IoMessageEvent(IoMessageEvent.MESSAGE_SENT,
														  sliceBuf);
			info.dispatchEvent(event);

			if (sliceBuf.limit == 0)
			{
				LOGGER.warn("write empty body message... for contract: {0}",
							contract);
			}

			if (sliceBuf.limit > 0 && sliceBuf.remaining == 0)
				sliceBuf.flip();

			buf.put(sliceBuf);
			buf.flip();
			buf.putIntAt(buf.position, buf.remaining);
		}
	}

}
}
