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

/**
 * @author keyhom (keyhom.c@gmail.com)
 */
public class ArrayQueue implements IQueue {

    /**
     * Creates an ArrayQueue instance.
     */
    public function ArrayQueue(capacity:Number = Number.NaN) {
        super();
    }

    /**
     * @private
     */
    private var _queue:Vector.<Object> = new Vector.<Object>;

    /**
     * @inheritDoc
     */
    public function get empty():Boolean {
        return _queue.length == 0;
    }

    /**
     * @inheritDoc
     */
    public function get size():uint {
        return _queue.length;
    }

    /**
     * @inheritDoc
     */
    public function offer(o:Object):void {
        _queue.push(o);
    }

    /**
     * @inheritDoc
     */
    public function peek():Object {
        if (!empty)
            return _queue[0];
        return null;
    }

    /**
     * @inheritDoc
     */
    public function poll():Object {
        return _queue.shift();
    }

    /**
     * @inheritDoc
     */
    public function clear():void {
        // Remove all content.
        _queue.splice(0, _queue.length);
        // New instance assign to.
        _queue = new Vector.<Object>;
    }
}
}
// vim:ft=actionscript
