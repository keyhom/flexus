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

import flexus.core.xwork.filterChain.NextFilter;
import flexus.core.xwork.session.IoSession;
import flexus.utils.ArrayQueue;
import flexus.utils.IQueue;

/**
 * @author keyhom
 */
public class ProtocolDecoderOutput {

    /**
     * @private
     */
    private const _messageQueue:IQueue = new ArrayQueue(2 << 4);

    /**
     * Creates a ProtocolDecoderOutput instance.
     */
    public function ProtocolDecoderOutput() {
        // do nothing.
    }

    public function get messageQueue():IQueue {
        return this._messageQueue;
    }

    public function flush(nextFilter:NextFilter, session:IoSession):void {
    }

    public function write(message:Object):void {
        if (message == null) {
            throw new ArgumentError("message");
        }

        messageQueue.offer(message);
    }
}
}
