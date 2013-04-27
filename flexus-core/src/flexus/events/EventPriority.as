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

package flexus.events {

/**
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public final class EventPriority {

    /**
     * The CursorManager has handlers for mouse events
     * which must be executed before other mouse event handlers,
     * so they have a high priority.
     */
    public static const CURSOR_MANAGEMENT:int = 200;

    /**
     * Auto-generated event handlers that evaluate date-binding expressions
     * need to be executed before any others, so they have a higher priority
     * than the default.
     */
    public static const BINDING:int = 100;

    /**
     * Event handlers on component instances are executed with the default
     * priority, <code>0</code>.
     */
    public static const DEFAULT:int = 0;

    /**
     * Some components listen to events that they dispatch on themselves
     * and let other listeners call the <code>preventDefault()</code>
     * method to tell component not to perform a default action.
     * Those components must listen with a lower priority than the default
     * priority, so that the other handlers are executed first and have a
     * chance to call <code>preventDefault()</code>.
     */
    public static const DEFAULT_HANDLER:int = -50;

    /**
     * Auto-generated event handlers that trigger effects are executed
     * after other event handlers on component instances, so they have
     * a lower priority than the default.
     */
    public static const EFFECT:int = -100;

    /**
     * @private
     * Creates an EventPriority instance.
     */
    public function EventPriority() {
    }
}
}
// vim:ft=actionscript
