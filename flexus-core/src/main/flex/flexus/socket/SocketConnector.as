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
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;

import flexus.core.xwork.future.FutureEvent;
import flexus.core.xwork.service.IoConnector;
import flexus.core.xwork.session.AbstractIoSession;
import flexus.core.xwork.session.IoSession;
import flexus.errors.IllegalStateError;
import flexus.io.ByteBuffer;

/**
 * A socket implementation of IoConnector.
 *
 * @author keyhom
 */
public class SocketConnector extends IoConnector {

    /**
     * Creates a SocketConnector instance.
     */
    public function SocketConnector() {
        super();
    }

    override protected function newSession(object:Object):IoSession {
        var session:SocketSession = new SocketSession(this, Socket(object));
        // construct the session map.
        super.newSession(session);

        if (!(object in sessions))
            sessions[object] = session;

        return session;
    }

    override protected function connect0(address:SocketAddress, connectFuture:Function):void {
        const socket:Socket = new Socket;
        var func:Function = null;
        socket.addEventListener(Event.CONNECT, func = function (e:Event):void {
            // connected.
            socket.removeEventListener(Event.CONNECT, func);
            func = null;

            var s:Socket = e.currentTarget as Socket;
            s.flush();
            s.addEventListener(ProgressEvent.SOCKET_DATA, processDataQueue);
            s.addEventListener(IOErrorEvent.IO_ERROR, errorCaught);

            // new session construct.
            var session:IoSession = newSession(s);
            initSession(AbstractIoSession(session));

            if (connectFuture != null) {
                var future:FutureEvent = new FutureEvent(FutureEvent.CONNECTED,
                        session);
                connectFuture.call(null, future);
            }
        }, false, 0, true);

        socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorCaught);
        socket.addEventListener(Event.CLOSE, processClosed);


        if (!address)
            throw new IllegalStateError("Invalid remote address!");

        socket.timeout = 15000;
        socket.connect(address.host.toString(), address.port);
    }

    private function processDataQueue(e:ProgressEvent):void {
        if (e && e.type == ProgressEvent.SOCKET_DATA) {
            const s:Socket = e.currentTarget as Socket;

            if (s && (s in sessions) && s.bytesAvailable) {
                const buf:ByteBuffer = new ByteBuffer;

                s.readBytes(buf.array);

                if (buf.hasRemaining) {
                    IoSession(sessions[s]).filterChain.fireMessageRecieved(buf);
                }
            }
        }
        // nothing to process.
    }

    private function processClosed(e:Event):void {
        if (e.target && (e.target is Socket)) {
            var s:Socket = Socket(e.target);

            if (s in sessions) {
                var session:IoSession = IoSession(sessions[s]);
                session.service.remove(session);
            }
        }
    }

    private function errorCaught(e:Event):void {
        logger.info("ERROR CAUGHT.");
    }

}
}
