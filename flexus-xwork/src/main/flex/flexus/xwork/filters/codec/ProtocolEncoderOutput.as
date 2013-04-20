/*
 * Copyright (c) 2013 keyhom.c@gmail.com.
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from
 * the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose
 * excluding commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 *     1. The origin of this software must not be misrepresented; you must not
 *     claim that you wrote the original software. If you use this software
 *     in a product, an acknowledgment in the product documentation would be
 *     appreciated but is not required.
 *
 *     2. Altered source versions must be plainly marked as such, and must not
 *     be misrepresented as being the original software.
 *
 *     3. This notice may not be removed or altered from any source
 *     distribution.
 */

package flexus.xwork.filters.codec {

import flexus.errors.IllegalStateError;
import flexus.io.ByteBuffer;
import flexus.utils.ArrayQueue;
import flexus.utils.IQueue;

/**
 * @author keyhom
 */
public class ProtocolEncoderOutput {

    /**
     * Queue of message.
     */
    private const _messageQueue:IQueue = new ArrayQueue;

    /**
     * Creates a ProtocolEncoderOutput instance.
     */
    public function ProtocolEncoderOutput() {
        // Do nothing
    }

    private var buffersOnly:Boolean = true;

    /**
     * Returns the queue of messages.
     */
    public function get messageQueue():IQueue {
        return this._messageQueue;
    }

    /**
     * @inheritDoc
     */
    public function flush():Object {
        return null;
    }

    /**
     * Merges all.
     */
    public function mergeAll():void {
        if (!buffersOnly) {
            throw new IllegalStateError("the encoded message list contains a non-buffer.");
        }

        const size:uint = messageQueue.size;

        if (size < 2) {
            // no need to merge!
            return;
        }

        // Get the size of merged BB
        var sum:int = 0;

        for (var b:String in messageQueue) {
            sum += (ByteBuffer(b)).remaining;
        }

        // Allocate a new BB that will contain all fragments
        var newBuf:ByteBuffer = new ByteBuffer;

        // and merge all.
        for (; ;) {
            var buf:ByteBuffer = ByteBuffer(messageQueue.poll());

            if (buf == null) {
                break;
            }

            newBuf.put(buf);
        }

        // Push the new buffer finally.
        newBuf.flip();
        messageQueue.offer(newBuf);
    }

    public function write(encodedMessage:Object):void {
        if (encodedMessage is ByteBuffer) {
            var buf:ByteBuffer = ByteBuffer(encodedMessage);

            if (buf.hasRemaining) {
                messageQueue.offer(buf);
            }
            else {
                throw new ArgumentError("buf is empty. Forgot to call flip()?");
            }
        }
        else {
            messageQueue.offer(encodedMessage);
            buffersOnly = false;
        }
    }
}
}
