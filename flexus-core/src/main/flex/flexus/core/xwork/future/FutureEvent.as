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

package flexus.core.xwork.future {

import flash.events.Event;

import flexus.core.xwork.session.IoSession;
import flexus.errors.IllegalStateError;

/**
 * @author keyhom
 */
public class FutureEvent extends Event {

    static public const CONNECTED:String = "futureConnected";
    static public const WRITE:String = "futureWrote";
    static public const READ:String = "futureRead";
    static public const CLOSED:String = "futureClosed";
    static public const CLOSING:String = "futureClosing";

    /**
     * Creates a FutureEvent.
     */
    public function FutureEvent(type:String, value:Object = null, error:Error =
            null) {
        super(type);
        this._value = value;
        this._error = error;
    }

    public function get completed():Boolean {
        return _value is IoSession;
    }

    public function get session():IoSession {
        if (_value is IoSession)
            return IoSession(_value);
        else if (_value is Error)
            throw new IllegalStateError(Error(_value).message);
        return null;
    }

    private var _error:Error;

    public function get error():Error {
        return _error;
    }

    private var _value:Object;

    protected function get value():Object {
        if (type == CONNECT) {
            if (_error)
                return _error;
            return _value;
        }

        return _value;
    }
}
}
