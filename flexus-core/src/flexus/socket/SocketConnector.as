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

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.utils.Dictionary;

import flexus.core.xwork.future.FutureEvent;
import flexus.core.xwork.service.IoConnector;
import flexus.core.xwork.session.AbstractIoSession;
import flexus.core.xwork.session.IoSession;
import flexus.io.ByteBuffer;

/**
 * A socket implementation of IoConnector.
 *
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class SocketConnector extends IoConnector {

    /**
     * Creates a SocketConnector instance.
     */
    public function SocketConnector() {
        super();
    }

    /** @private */
    private var _sessionBiMap:Dictionary;

    /**
     * @inheritDoc
     */
    override protected function newSession(object:Object):IoSession {
        if (!(object is Socket))
            return null;

        const session:IoSession = new SocketSession(this, Socket(object));
        // Construct the session map.
        super.newSession(session);

        if (!_sessionBiMap) {
            _sessionBiMap = new Dictionary(true);
        }

        // Make an association from socket to sessionId.
        if (!(object in _sessionBiMap))
            _sessionBiMap[object] = session.sessionId;

        return session;
    }

    /**
     * @inheritDoc
     */
    override protected function connect0(host:String, port:uint, timeout:uint, callback:Function = null):void {
        // Connected callback.
        const func:Function = function (e:Event):void {
            const s:Socket = e.currentTarget as Socket;
            s.removeEventListener(Event.CONNECT, func);

            s.flush();
            s.addEventListener(ProgressEvent.SOCKET_DATA, processDataQueue);
            s.addEventListener(IOErrorEvent.IO_ERROR, errorCaught);

            // Creates session.
            const session:IoSession = newSession(s);
            // Initializes session.
            initSession(AbstractIoSession(session));

            // Called the callback if it's valid.
            if (callback != null) {
                callback.call(null, new FutureEvent(FutureEvent.CONNECTED, session));
            }
        };

        // Creates socket.
        const socket:Socket = new Socket;

        // General socket event listener.
        socket.addEventListener(Event.CONNECT, func);
        socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorCaught);
        socket.addEventListener(Event.CLOSE, processClosed);

        socket.timeout = timeout;

        // Perform connecting.
        socket.connect(host, port);
    }

    /**
     * @private
     */
    private function getSession(s:Socket):IoSession {
        if (s && s in _sessionBiMap) {
            const sessionId:int = int(_sessionBiMap[s]);
            return sessions[sessionId];
        }
        return null;
    }

    /**
     * @private
     */
    private function processDataQueue(e:ProgressEvent):void {
        if (e && e.type == ProgressEvent.SOCKET_DATA) {
            const s:Socket = e.currentTarget as Socket;
            const session:IoSession = getSession(s);

            if (session && s.bytesAvailable) {
                const buf:ByteBuffer = new ByteBuffer;

                s.readBytes(buf.array);

                if (buf.hasRemaining) {
                    session.filterChain.fireMessageReceived(buf);
                }
            }
        }
    }

    /**
     * @private
     */
    private function unloadSocket(s:Socket):void {
        if (s) {
            s.removeEventListener(ProgressEvent.SOCKET_DATA, processDataQueue);
            s.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorCaught);
            s.removeEventListener(IOErrorEvent.IO_ERROR, errorCaught);
            s.removeEventListener(Event.CLOSE, processClosed);
        }
    }

    /**
     * @private
     */
    private function processClosed(e:Event):void {
        if (e.currentTarget && (e.currentTarget is Socket)) {
            const s:Socket = Socket(e.currentTarget);
            const session:IoSession = getSession(s);

            unloadSocket(s);

            if (session) {
                // Removes the socket association.
                delete _sessionBiMap[s];

                session.filterChain.fireFilterClose();
            }
        }
    }

    /**
     * @private
     */
    private function errorCaught(e:ErrorEvent):void {
        if (e.target && e.target is Socket) {
            const session:IoSession = getSession(Socket(e.target));
            if (session) {
                session.filterChain.exceptionCaught(new Error(e.text, e.errorID));
            }
        }
    }

}
}
// vim:ft=actionscript
