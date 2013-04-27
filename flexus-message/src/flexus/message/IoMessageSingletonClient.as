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

package flexus.message {

import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import flexus.core.xwork.future.FutureEvent;
import flexus.core.xwork.service.IoConnector;
import flexus.core.xwork.session.IoSession;
import flexus.errors.IllegalStateError;
import flexus.socket.SocketAddress;
import flexus.utils.ArrayQueue;
import flexus.utils.IQueue;
import flexus.xwork.filters.codec.ProtocolCodecFactory;

/**
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class IoMessageSingletonClient extends IoMessageClient {

    /**
     * @private
     */
    private static var _session:IoSession;

    /**
     * Creates an IoMessageSingletonClient instance.
     */
    public function IoMessageSingletonClient() {
        super();
    }

    /**
     * @private
     */
    private var _connecting:Boolean = false;
    /**
     * @private
     */
    private var _connectQueue:IQueue = new ArrayQueue;
    /**
     * @private
     */
    private var _timer:Timer;

    /**
     * @private
     * Singleton client
     */
    static private var _client:IoConnector;

    /**
     * @inheritDoc
     */
    override protected function get client():IoConnector {
        return _client;
    }

    /**
     * @inheritDoc
     */
    override protected function set client(value:IoConnector):void {
        if (!value)
            throw new ArgumentError("Invalid value for IoConnector!");

        _client = value;
    }

    /**
     * @inheritDoc
     */
    override public function set factory(value:ProtocolCodecFactory):void {
        if (!super.factory)
            super.factory = value;
    }

    /**
     * @inheritDoc
     */
    override protected function init():void {
        // doing nothing here.
        if (!client)
            super.init();
    }

    /**
     *  @{inheritDoc}
     */
    override public function send(info:IoMessageInfo, remoteAddress:SocketAddress =
            null):void {
        if (_session) {
            super.injectSession(info, _session);
            _session.write(info);
        }
        else {
            if (!remoteAddress)
                remoteAddress = this.remoteAddress;

            if (!remoteAddress)
                throw new IllegalStateError("Invalid remoteAddress to connect!");

            if (_connecting) {
                _connectQueue.offer(info);
                return;
            }

            _connecting = true;

            if (!_timer) {
                _timer = new Timer(500);
                _timer.addEventListener(TimerEvent.TIMER, processConnectQueue);
            }

            client.connect(remoteAddress, function (future:FutureEvent):void {
                if (future && future.session && future.session.connected) {
                    _session = future.session;
                    _connecting = false;
                    dispatchEvent(new Event(Event.CONNECT));
                    send(info);
                }
            });
        }
    }

    /**
     * Close the singleton session, and this will clear all connecting task.
     */
    public function close():void {
        if (!_connectQueue.empty) {
            _connectQueue.clear();
        }

        if (_session && _session.connected)
            _session.close();

        _connecting = false;
        _session = null;

        if (_timer)
            _timer.stop();
        _timer = null;
    }

    /**
     * @private
     */
    private function processConnectQueue(e:TimerEvent):void {
        if (_session && !_connecting) {
            if (!_connectQueue.empty) {
                var info:IoMessageInfo = null;

                while ((info = _connectQueue.poll() as IoMessageInfo)) {
                    send(info);
                }
            }
            else {
                var t:Timer = e.currentTarget as Timer;

                if (t.running)
                    t.stop();
            }
        }
    }
}
}
// vim:ft=actionscript
