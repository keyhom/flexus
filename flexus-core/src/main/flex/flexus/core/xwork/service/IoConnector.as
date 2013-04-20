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

package flexus.core.xwork.service {

import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import flexus.core.xwork.XworkLogTarget;
import flexus.core.xwork.filterChain.DefaultIoFilterChainBuilder;
import flexus.core.xwork.filterChain.IoFilterChainBuilder;
import flexus.core.xwork.future.FutureEvent;
import flexus.core.xwork.session.AbstractIoSession;
import flexus.core.xwork.session.IoSession;
import flexus.errors.IllegalStateError;
import flexus.socket.SocketAddress;
import flexus.utils.ArrayQueue;
import flexus.utils.IQueue;

import mx.logging.ILogger;
import mx.logging.LogLogger;

[Event(name="serviceActived", type="flexus.core.xwork.service.IoServiceEvent")]
/**
 * @author keyhom
 */
public class IoConnector extends EventDispatcher {

    static private var DEFAULT_HANDLER:IoHandler = new IoHandler;

    /**
     * Creates an IoConnector instance..
     */
    public function IoConnector() {
        super();
        logger = new LogLogger(getQualifiedClassName(IoConnector));
        XworkLogTarget.addLogger(logger);

        _connectQueue = new ArrayQueue;
        _closeQueue = new ArrayQueue;

        listeners = new IoServiceListenerSupport();
    }

    protected var listeners:IoServiceListenerSupport;
    protected var sessions:Dictionary = new Dictionary();
    protected var logger:ILogger;

    /**
     * @inheritDoc
     */
    public function get filterChain():DefaultIoFilterChainBuilder {
        if (_filterChainBuilder is DefaultIoFilterChainBuilder)
            return DefaultIoFilterChainBuilder(_filterChainBuilder);
        throw new Error("this filterChainBuilder is not the default builder!");
    }

    private var _filterChainBuilder:IoFilterChainBuilder = new DefaultIoFilterChainBuilder;

    public function get filterChainBuilder():IoFilterChainBuilder {
        return _filterChainBuilder;
    }

    /**
     * @private
     */
    public function set filterChainBuilder(value:IoFilterChainBuilder):void {
        _filterChainBuilder = value;
    }

    private var _handler:IoHandler;

    /**
     * @inheritDoc
     */
    public function get handler():IoHandler {
        return _handler;
    }

    /**
     * @private
     */
    public function set handler(value:IoHandler):void {
        _handler = value;
    }

    /**
     *  @inheritDoc
     */
    public function get transportMetadata():Object {
        return null;
    }

    private var _closeQueue:IQueue;

    protected function get closeQueue():IQueue {
        return _closeQueue;
    }

    private var _connectQueue:IQueue;

    protected function get connectQueue():IQueue {
        return _connectQueue;
    }

    public function connect(remoteAddress:SocketAddress, callback:Function =
            null):void {
        if (!remoteAddress)
            throw new IllegalStateError("invalid remote address!");

        if (!handler) {
            handler = DEFAULT_HANDLER;
        }

        // first to create the connect request and add it to the connect queue.

        if (callback == null) {
            callback = function (future:FutureEvent):void {
                trace("default connect future handler.");
            };
        }

        connect0(remoteAddress, callback);
    }

    public function remove(session:IoSession):void {
        session.filterChain.fireFilterClose();
        session.filterChain.fireSessionClosed();
        AbstractIoSession(session).traceStatistics(logger);
    }

    protected function connect0(remoteAddress:SocketAddress, connectFuture:Function):void {
        // must to be implemented.
    }

    protected function newSession(object:Object):IoSession {
        // must to be implemented.
        return null;
    }

    protected function initSession(session:AbstractIoSession):void {
        filterChainBuilder.buildFilterChain(session.filterChain);
        session.service.listeners.fireSessionCreated(session);
    }

}
}
