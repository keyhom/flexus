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

import flash.errors.IllegalOperationError;
import flash.events.EventDispatcher;

import flexus.events.EventPriority;
import flexus.events.Request;
import flexus.io.ByteBuffer;

/**
 *  The event fired when the message being decoded.
 */
[Event(name="decode", type="mx.events.Request")]

/**
 *  The event fired when the message being encoded.
 */
[Event(name="encode", type="mx.events.Request")]

/**
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class IoMessage extends EventDispatcher {

    /**
     * @private
     */
    static public const DECODE:String = "decode";

    /**
     * @private
     */
    static public const ENCODE:String = "encode";

    /**
     * Creates an IoMessage instance.
     *
     * @param info The information object of IoMessage.
     */
    public function IoMessage(info:IoMessageInfo) {
        super();
        if (!info)
            throw new ArgumentError("Invalid information object for IoMessage!");

        this._info = info;

        init();
    }

    /**
     * @private
     * Storage for the info property.
     */
    private var _info:IoMessageInfo;

    /**
     * Retrieves the information interface of the IoMessage.
     */
    public function get info():IoMessageInfo {
        return _info;
    }

    /**
     * Retrieves the contract object which binding with the message object.
     */
    public function get contract():* {
        return info.contract;
    }

    /**
     * Disposes.
     */
    public function dispose():void {
        // nothing to do.
    }

    /**
     * @private
     */
    final protected function init():void {
        this.addEventListener(DECODE, decodeHandler, false, EventPriority.DEFAULT_HANDLER, true);
        this.addEventListener(ENCODE, encodeHandler, false, EventPriority.DEFAULT_HANDLER, true);
    }

    /**
     * Retrieves the buffer object attach in the request.
     */
    protected static function getBuffer(e:Request):ByteBuffer {
        if (e.value && e.value is ByteBuffer) {
            return ByteBuffer(e.value);
        }

        return null;
    }

    /**
     * Handle the data decoding.
     */
    protected function decodeHandler(e:Request):void {
        // TODO: decode the data.
        throw new IllegalOperationError("Must implemented the decode handler!");
    }

    /**
     * Handle the data encoding.
     */
    protected function encodeHandler(e:Request):void {
        // TODO: encode the data.
        throw new IllegalOperationError("Must implemented the encode handler!");
    }

}
}
// vim:ft=actionscript
