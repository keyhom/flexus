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

package flexus.xwork.filters.codec
{

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
public class CumulativeProtocolDecoder extends ProtocolDecoder
{

	//--------------------------------------------------------------------------
	//
	//  Class properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// BUFFER 
	//----------------------------------

	static private const BUFFER:String = "__buffer";

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 * Creates a new instance.
	 */
	public function CumulativeProtocolDecoder()
	{
		super();
		// Do nothing
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	/**
	 * Cumulates content of <tt>in</tt> into internal buffer and forwards
	 * decoding request to #doDecode(IoSession, IoBuffer, ProtocolDecoderOutput).
	 * <tt>doDecode()</tt> is invoked repeatedly until it returns <tt>false</tt>
	 * and the cumulative buffer is compacted after decoding ends.
	 *
	 * @throws IllegalStateException if your <tt>doDecode()</tt> returned
	 *                               <tt>true</tt> not consuming the cumulative buffer.
	 */
	override public function decode(session:IoSession, in1:ByteBuffer, out:ProtocolDecoderOutput):void
	{
		var usingSessionBuffer:Boolean = true;
		var buf:ByteBuffer = ByteBuffer(session.getAttribute(BUFFER));

		// If we have a session buffer, append data to that; otherwise
		// use the buffer read from the network directly.
		if (buf != null)
		{
			var appended:Boolean = false;
			try
			{
				buf.put(in1);
				in1.position = in1.limit;
				appended = true;
			}
			catch (e:Error)
			{
			}
			
			if (appended) {
				buf.flip();
			} else {
				// Reallocate the buffer if append operation failed due to 
				// derivation or EOF, etc.
				buf.flip();
				const newBuf:ByteBuffer = new ByteBuffer();
				newBuf.order = buf.order;
				newBuf.put(buf);
				newBuf.put(in1);
				newBuf.flip();
				buf = newBuf;
				
				// Update the session buffer.
				session.setAttribute(BUFFER, buf);
			}
		}
		else
		{
			buf = in1;
			usingSessionBuffer = false;
		}

		var decoded:Boolean = false;
			
		for (;;)
		{
			const oldPos:int = buf.position;
			decoded = doDecode(session, buf, out);

			if (decoded)
			{
				if (buf.position == oldPos)
				{
					throw new IllegalStateError("doDecode() can't return true when buffer is not consumed.");
				}

				if (!buf.hasRemaining)
				{
					break;
				}
			}
			else
			{
				break;
			}
		}

		// if there is any data left that cannot be decoded, we store
		// it in a buffer in the session and next time this decoder is
		// invoked the session buffer gets appended to
		if (buf.hasRemaining)
		{
			if (usingSessionBuffer)
			{
				buf.compact();
			}
			else
			{
				storeRemainingInSession(buf, session);
			}
		}
		else
		{
			if (usingSessionBuffer)
			{
				removeSessionBuffer(session);
			}
		}
	}

	override public function dispose(session:IoSession):void
	{
		removeSessionBuffer(session);
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param session
	 *  @param buf
	 *  @param out
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	protected function doDecode(session:IoSession, buf:ByteBuffer, out:ProtocolDecoderOutput):Boolean
	{
		return true;
	}

	/**
	 *
	 *  @param session
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function removeSessionBuffer(session:IoSession):void
	{
		const buf:ByteBuffer = session.removeAttribute(BUFFER) as ByteBuffer;
		if (buf) {
			buf.clear();
		}
	}

	/**
	 *
	 *  @param buf
	 *  @param session
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function storeRemainingInSession(buf:ByteBuffer, session:IoSession):void
	{
		// compact the decoded part in buffer.
		const remainingBuf:ByteBuffer = new ByteBuffer;
		remainingBuf.order = buf.order;
		remainingBuf.put(buf);
		buf.position = buf.limit;
		session.setAttribute(BUFFER, remainingBuf);
	}
}
}
