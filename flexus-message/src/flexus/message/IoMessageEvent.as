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

import flexus.io.ByteBuffer;

/**
 * Represents an Event specified for IoMessage.
 *
 * @version $Revision$
 * @author keyhom.c
 */
public class IoMessageEvent extends Event {

    /**
     * Provides a constant string of receiving message event.
     */
    static public const MESSAGE_RECEIVED:String = "messageReceived";
    static public const READY:String = "ready";
    static public const RESOLVED:String = "resolved";
    static public const MESSAGE_SENT:String = "messageSent";

    /**
     * Creates an IoMessageEvent object.
     */
    public function IoMessageEvent(type:String, attach:Object = null) {
        super(type, false, false);

        this._attach = attach;

        if (attach && attach is ByteBuffer)
            _buf = attach as ByteBuffer;
        else
            _buf = new ByteBuffer;
    }

    /**
     * @private
     */
    private var _buf:ByteBuffer;

    /**
     * Retrieves the buffer for decoding or encoding.
     *
     * @return buffer
     */
    public function get buffer():ByteBuffer {
        return _buf;
    }

    /**
     * @private
     */
    private var _attach:*;

    /**
     * Retrieves the attach object.
     */
    public function get attach():* {
        return _attach;
    }

}
}
// vim:ft=actionscript
