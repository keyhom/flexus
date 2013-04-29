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

package flexus.socket {

import flash.events.Event;
import flash.net.Socket;

import flexus.core.xwork.filterChain.IoFilterChain;
import flexus.core.xwork.service.IoConnector;
import flexus.core.xwork.session.AbstractIoSession;
import flexus.io.ByteBuffer;

/**
 * A socket implementation of IoSession.
 *
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class SocketSession extends AbstractIoSession {

    /**
     *  Creates a SocketSession instance.
     *
     *  @param service The IoService instance instead.
     *  @param socket The socket object.
     */
    public function SocketSession(service:IoConnector, socket:Socket) {
        super(service);
        this._socket = socket;
        this._filterChain = new IoFilterChain(this);
    }

    /**
     * @inheritDoc
     */
    override public function get connected():Boolean {
        return socket.connected;
    }

    /** @private */
    private var _filterChain:IoFilterChain;

    /**
     * @inheritDoc
     */
    override public function get filterChain():IoFilterChain {
        return _filterChain;
    }

    /** @private */
    private var _socket:Socket;

    /**
     * The Socket associated with this session.
     */
    protected function get socket():Socket {
        return _socket;
    }

    /**
     * @inheritDoc
     */
    override protected function writeBuffer(buffer:ByteBuffer):uint {
        if (buffer.hasRemaining) {
            socket.writeBytes(buffer.array);
            socket.flush();
            return buffer.limit;
        }
        return 0;
    }

    /**
     * @inheritDoc
     */
    override public function close(now:Boolean = false, closeFuture:Function =
            null):void {
        if (socket) {
            socket.close();
        }

        super.close(now, closeFuture);
    }

    /**
     * @inheritDoc
     */
    override protected function unload(e:Event):void {
        super.unload(e);

        this._filterChain = null;
        this._socket = null;
    }
}
}
// vim:ft=actionscript
