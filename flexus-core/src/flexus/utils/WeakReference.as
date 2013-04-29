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

package flexus.utils {

import flash.utils.Dictionary;

/**
 * @author keyhom
 */
public class WeakReference {

    /**
     * @private
     */
    private const context:Dictionary = new Dictionary(true);

    /**
     * Creates a WeakReference instance.
     */
    public function WeakReference(value:* = null) {
        super();

        if (value)
            put(value);
    }

    /**
     * Clears the value.
     *
     * @return this weak reference context object.
     */
    public function clear():WeakReference {
        var o:* = get();

        while (o) {
            context[o] = null;
            delete context[o];
            o = get();
        }

        return this;
    }

    /**
     * Determines if empty it's.
     *
     * @return true if empty it's, false otherwise.
     */
    public function empty():Boolean {
        return get() == null;
    }

    /**
     *  Retrieves the value of the WeakReference.
     *
     *  @return the value
     */
    public function get():* {
        for (var k:* in context) {
            return k;
        }
        return null;
    }

    /**
     * Puts the value into this WeakReference context.
     *
     * @return this weak reference context object.
     */
    public function put(value:*):WeakReference {
        if (!value)
            throw new ArgumentError("Invalid value for WeakReference!");

        clear();
        context[value] = true;
        return this;
    }
}
}
