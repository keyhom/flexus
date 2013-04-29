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

import flexus.core.xwork.filterChain.DefaultIoFilterChainBuilder;
import flexus.core.xwork.filterChain.IoFilterChainBuilder;
import flexus.core.xwork.future.FutureEvent;
import flexus.core.xwork.session.AbstractIoSession;
import flexus.core.xwork.session.IoSession;
import flexus.flexus_internal;
import flexus.utils.StringUtil;

[Event(name="serviceActivated", type="flexus.core.xwork.service.IoServiceEvent")]
[Event(name="serviceDeactivated", type="flexus.core.xwork.service.IoServiceEvent")]
[Event(name="serviceClosed", type="flexus.core.xwork.service.IoServiceEvent")]
/**
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class IoConnector extends EventDispatcher {

    /** @private */
    private static const _DEFAULT_TIMEOUT:Number = 1500;
    /** @private */
    private static const _DEFAULT_HANDLER:IoHandler = new IoHandler;
    /** @private */
    private static const _DEFAULT_CALLBACK:Function = function (future:FutureEvent):void {
        COMPILER::DEBUG {
            trace("[IoConnector] %%% WARN %%%: Default connect future handler. Please provides a custom callback function.");
        }
    };
    /**
     * Represents an builder of IoFilterChain.
     */
    public const filterChainBuilder:IoFilterChainBuilder = new DefaultIoFilterChainBuilder;

    /**
     * Creates an IoConnector instance..
     */
    public function IoConnector() {
        listeners = new IoServiceListenerSupport(this);
    }

    /**
     * Represents an I/O handler.
     */
    public var handler:IoHandler;
    /**
     * @private
     */
    protected var listeners:IoServiceListenerSupport;

    /**
     * IoFilterChain associated with this IoConnector.
     */
    public function get filterChain():DefaultIoFilterChainBuilder {
        if (filterChainBuilder is DefaultIoFilterChainBuilder)
            return DefaultIoFilterChainBuilder(filterChainBuilder);
        throw new Error("this filterChainBuilder is not the default builder!");
    }

    /**
     * @private
     */
    [Deprecated]
    public function get transportMetadata():Object {
        return null;
    }

    /** @private */
    private var _disposed:Boolean = false;

    /**
     * Represents a value for determining if disposed.
     */
    public function get disposed():Boolean {
        return _disposed;
    }

    /**
     * @private
     */
    protected function get sessions():Dictionary {
        return listeners.managedSessions;
    }

    /**
     * Connects to remote endpoint by the supplied <code>remoteAddress</code>.
     * If the <code>callback</code> function was valid, it will be called when the connecting was finished.
     *
     * @param host The host address.
     * @param port The target port.
     * @param callback The callback function. (optional)
     */
    public function connect(host:String, port:uint, timeout:uint = 0, callback:Function =
            null):void {
        if (StringUtil.isEmpty(host))
            host = '127.0.0.1';

        if (!port)
            throw new ArgumentError("Invalid port!");

        if (!handler) {
            handler = _DEFAULT_HANDLER;
        }

        if (!timeout) {
            timeout = _DEFAULT_TIMEOUT;
        }

        // first to create the connect request and add it to the connect queue.
        if (callback == null) {
            callback = _DEFAULT_CALLBACK;
        }

        connect0(host, port, timeout, callback);
    }

    /**
     * Removes the supplied session object.
     * It will fire the close event to notify all for closing the session now.
     *
     * @param session The session instance.
     */
    public function remove(session:IoSession):void {
        listeners.flexus_internal::fireSessionDestoryed(session);
    }

    /**
     * Provides the implementation for connecting.
     * This method must be implemented by accurate.
     *
     * @param remoteAddress The remote address for connecting to.
     * @param connectFuture The future function for connecting finished.
     */
    protected function connect0(host:String, port:uint, timeout:uint, callback:Function = null):void {
        // must to be implemented.
    }

    /**
     * Provides the implementation for creating a session instance.
     * This method must be implemented by accurate.
     *
     * @param object The attachment object for creating session.
     */
    protected function newSession(object:Object):IoSession {
        // must to be implemented.
        return null;
    }

    /**
     * Initializes the supplied session instance.
     *
     * @param session The session instance to initialize.
     */
    protected function initSession(session:AbstractIoSession):void {
        filterChainBuilder.buildFilterChain(session.filterChain);
        listeners.flexus_internal::fireSessionCreated(session);
    }

    /**
     * Disposed the service when the service deactivated.
     */
    flexus_internal function dispose():void {
        this._disposed = true;
    }

}
}
// vim:ft=actionscript
