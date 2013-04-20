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
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;

import flexus.io.ByteBuffer;

/**
 *  @author keyhom
 */
public class SocketChannel extends EventDispatcher {

    static public const CLEAR:int = 1 << 1;
    static public const CONNECT:int = 1;

    /**
     * Creates a SocketChannel instance..
     */
    public function SocketChannel(socket:Socket = null) {
        if (!socket)
            socket = new Socket;
        _socket = socket;
        super(_socket);
    }

    private var _remoteAddress:SocketAddress;

    private var _socket:Socket;

    /**
     * The socket.
     */
    public function get socket():Socket {
        return _socket;
    }

    override public function toString():String {
        return "SocketChannel: [remoteAddress=" + _remoteAddress + ", connected=" +
                socket.connected + "]";
    }

    /**
     * Connects to the remote host by the specific socket address.
     */
    public function connect(address:SocketAddress, options:int = 3):IEventDispatcher {
        if (address) {
            _remoteAddress = address;
            if (socket && (options & CONNECT == CONNECT)) {
                removeAllListeners();

                if ((options & CLEAR) == CLEAR)
                    closeIfConnected(socket);

                socket.addEventListener(Event.CONNECT, connectHandler);
                socket.addEventListener(Event.CLOSE, closeHandler);
                socket.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
                socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);

                socket.connect(address.host.toString(), address.port);
            }
        }

        return this;
    }

    protected function closeIfConnected(socket:Socket):void {
        if (socket && socket.connected)
            socket.close();
    }

    protected function removeAllListeners():void {
        if (socket.hasEventListener(Event.CONNECT))
            socket.removeEventListener(Event.CONNECT, connectHandler);

        if (socket.hasEventListener(Event.CLOSE))
            socket.removeEventListener(Event.CLOSE, closeHandler);

        if (socket.hasEventListener(IOErrorEvent.IO_ERROR))
            socket.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);

        if (socket.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
            socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);

        if (socket.hasEventListener(ProgressEvent.SOCKET_DATA))
            socket.removeEventListener(ProgressEvent.SOCKET_DATA, receiveHandler);
    }

    protected function closeHandler(event:Event):void {
        trace("Socket close: ", this);
    }

    protected function connectHandler(event:Event):void {
        if (!hasEventListener(ProgressEvent.SOCKET_DATA))
            socket.addEventListener(ProgressEvent.SOCKET_DATA, receiveHandler,
                    false, 0, true);
        trace("Socket Connected: ", this);
        var buf:ByteBuffer = new ByteBuffer;
        // length
        buf.putInt(0x00);
        // body
        buf.put(0x01);
        buf.putShort(0x11);
        buf.putShort(0x11);
        buf.putInt(0x22);
        buf.putInt(0x22);
        buf.putLong(1316352475072);

        buf.flip();
        buf.putIntAt(buf.position, buf.remaining);

        socket.writeBytes(buf.array);
        socket.flush();
    }

    protected function errorHandler(event:Event):void {
        trace("Socket ERROR:", this, event);
    }

    protected function receiveHandler(event:ProgressEvent):void {
        trace("Socket receive:", this, event.bytesLoaded, event.bytesTotal);
    }
}
}
