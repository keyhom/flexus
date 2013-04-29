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

package flexus.core.xwork.session {

import flash.errors.IOError;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.FileReference;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import flexus.core.xwork.filterChain.IoFilterChain;
import flexus.core.xwork.future.FutureEvent;
import flexus.core.xwork.service.IoConnector;
import flexus.core.xwork.service.IoHandler;
import flexus.flexus_internal;
import flexus.io.ByteBuffer;

/**
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class AbstractIoSession extends EventDispatcher implements IoSession {

    /**
     * @private
     */
    static private var SESSION_ID_GENERATOR:uint = 0;

    /**
     * Creates an AbstractIoSession concrete instance.
     */
    public function AbstractIoSession(service:IoConnector) {
        if (!service)
            throw new ArgumentError('service');

        this._service = service;
        this._sessionId = ++SESSION_ID_GENERATOR;

        this.addEventListener(Event.UNLOAD, unload);
    }

    /**
     * @private
     */
    private var _attributes:Dictionary = new Dictionary();

    /**
     * @inheritDoc
     */
    public function get connected():Boolean {
        // must to be implemented.
        return false;
    }

    /**
     * @inheritDoc
     */
    public function get filterChain():IoFilterChain {
        // must to be implemented.
        return null;
    }

    /**
     * @inheritDoc
     */
    public function get handler():IoHandler {
        if (service)
            return service.handler;
        return null;
    }

    /**
     * @private
     */
    private var _service:IoConnector;

    /**
     * @inheritDoc
     */
    public function get service():IoConnector {
        return _service;
    }

    /**
     * @private
     */
    private var _sessionId:uint;

    /**
     * @inheritDoc
     */
    public function get sessionId():uint {
        return _sessionId;
    }

    /**
     * @inheritDoc
     */
    override public function toString():String {
        return "IoSession#" + sessionId;
    }

    /**
     * @inheritDoc
     */
    public function close(now:Boolean = false, closeFuture:Function = null):void {
        // must to be implemented.
        if (closeFuture != null)
            closeFuture.call(null, new FutureEvent(FutureEvent.CLOSED, this));

        filterChain.fireFilterClose();
    }

    /**
     * @inheritDoc
     */
    public function containsAttribute(key:Object):Boolean {
        return key in _attributes;
    }

    /**
     * Flushes the supplied message object to send.
     *
     * @param message The message object.
     */
    public function flush(message:Object):void {
        if (!message)
            throw new ArgumentError('message');

        if (message is ByteBuffer) {
            var writeBytes:uint = writeBuffer(ByteBuffer(message));

            if (writeBytes > 0) {
                filterChain.fireMessageSent(message);
            }
        }
    }

    /**
     * @inheritDoc
     */
    public function getAttribute(key:Object, defaultValue:Object = null):Object {
        var o:Object = null;

        if (key in _attributes) {
            o = _attributes[key];
        }

        if (!o && defaultValue)
            return defaultValue;

        return o;
    }

    /**
     * @inheritDoc
     */
    public function getAttributeKeys():Vector.<Object> {
        const result:Vector.<Object> = new Vector.<Object>;

        for (var k:String in _attributes) {
            result.push(k);
        }
        return result;
    }

    /**
     * @inheritDoc
     */
    public function removeAttribute(key:Object, defaultValue:Object = null):Object {
        var originObject:Object;

        if (key in _attributes) {
            originObject = _attributes[key];
            _attributes[key] = null;
            delete _attributes[key];
        }

        if (!originObject && defaultValue)
            return defaultValue;

        return originObject;
    }

    /**
     * @inheritDoc
     */
    public function replaceAttribute(key:Object, oldValue:Object, newValue:Object):Object {
        if (key && (key in _attributes)) {
            var obj:Object = _attributes[key];

            if (obj == oldValue) {
                _attributes[key] = newValue;
                return obj;
            }
        }
        return null;
    }

    /**
     * @inheritDoc
     */
    public function setAttribute(key:Object, value:Object):Object {
        var originObject:Object = _attributes[key];
        _attributes[key] = value;
        return originObject;
    }

    /**
     * @inheritDoc
     */
    public function setAttributeIfAbsent(key:Object, value:Object):Object {
        if (!(key in _attributes) || !_attributes[key])
            _attributes[key] = value;
        return null;
    }

    /**
     * @inheritDoc
     */
    public function write(message:Object, writeFuture:Function = null):void {
        if (!message)
            throw new ArgumentError('message');

        // checking the session is alive.
        if (!connected) {
            var future:FutureEvent = new FutureEvent(FutureEvent.WRITE, this,
                    new IOError('write to closed session!'));
            dispatchEvent(future);
            return;
        }

        var buf:ByteBuffer = null;

        if (message is ByteArray)
            message = ByteBuffer.wrap(ByteArray(message));

        if (message is ByteBuffer) {
            buf = message as ByteBuffer;

            if (buf && !buf.hasRemaining)
                throw new ArgumentError('message is empty. Forgot to call flip()?');
        }
        else if (message is String) {
            buf = new ByteBuffer;
            buf.putString(message.toString());
        }
        else if (message is FileReference) {
            ByteBuffer.wrap(FileReference(message).data);
        }

        // filtering the chain to write.
        filterChain.fireFilterWrite(message);
    }

    /**
     * Writes the buffer and flush to the remote.
     *
     * @param buffer
     * @return bytes length of the flushing.
     */
    protected function writeBuffer(buffer:ByteBuffer):uint {
        // must to be implemented.
        return 0;
    }

    /**
     * @private
     */
    flexus_internal static function traceStatistics():void {
        COMPILER::DEBUG {
            trace("Not found the statistics information now.");
        }
    }

    /**
     * Unload this session instance.
     */
    protected function unload(e:Event):void {
        removeEventListener(Event.UNLOAD, unload);

        this._service = null;
        this._attributes = null;
    }
}
}
