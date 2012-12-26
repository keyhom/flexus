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
	import flexus.errors.IllegalStateError;
	import flexus.io.ByteBuffer;
	import flexus.utils.ArrayQueue;
	import flexus.utils.IQueue;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ProtocolEncoderOutput
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
	public function ProtocolEncoderOutput()
	{
		// Do nothing
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// messageQueue 
	//----------------------------------

	private const _messageQueue:IQueue = new ArrayQueue;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get messageQueue():IQueue
	{
		return this._messageQueue;
	}

	//----------------------------------
	// buffersOnly 
	//----------------------------------

	private var buffersOnly:Boolean = true;

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function flush():Object
	{
		return null;
	}

	/**
	 *
	 *  @throws IllegalStateError
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function mergeAll():void
	{
		if (!buffersOnly)
		{
			throw new IllegalStateError("the encoded message list contains a non-buffer.");
		}

		const size:uint = messageQueue.size;

		if (size < 2)
		{
			// no need to merge!
			return;
		}

		// Get the size of merged BB
		var sum:int = 0;

		for (var b:* in messageQueue)
		{
			sum += (ByteBuffer(b)).remaining;
		}

		// Allocate a new BB that will contain all fragments
		var newBuf:ByteBuffer = new ByteBuffer;

		// and merge all.
		for (; ; )
		{
			var buf:ByteBuffer = ByteBuffer(messageQueue.poll());

			if (buf == null)
			{
				break;
			}

			newBuf.put(buf);
		}

		// Push the new buffer finally.
		newBuf.flip();
		messageQueue.offer(newBuf);
	}

	/**
	 *
	 *  @param encodedMessage
	 *  @throws ArgumentError
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function write(encodedMessage:Object):void
	{
		if (encodedMessage is ByteBuffer)
		{
			var buf:ByteBuffer = ByteBuffer(encodedMessage);

			if (buf.hasRemaining)
			{
				messageQueue.offer(buf);
			}
			else
			{
				throw new ArgumentError("buf is empty. Forgot to call flip()?");
			}
		}
		else
		{
			messageQueue.offer(encodedMessage);
			buffersOnly = false;
		}
	}
}
}
