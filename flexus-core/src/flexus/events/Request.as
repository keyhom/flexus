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

import flash.events.Event;

/**
 * This is an event that is expects its data property to be set by a responding listener.
 *
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class Request extends Event {

    /**
     * Dispatched from a sub-application or module to find the module factory of its parent
     * application or module. The recipient of this request should set the data property to
     * their module factory.
     *
     * The message is dispatched from the content of a loaded module or application.
     */
    public static const GET_PARENT_FLEX_MODULE_FACTORY_REQUEST:String = "getParentFlexModuleFactoryRequest";

    /**
     * Creates a Request instance.
     */
    public function Request(type:String, bubbles:Boolean = false, concelable:Boolean = false, value:Object = null) {
        super(type, bubbles, cancelable);

        this.value = value;
    }

    /**
     * Value of property, or array of parameters for method.
     */
    public var value:Object;

    /**
     * @inheritDoc
     */
    override public function clone():Event {
        return new Request(type, bubbles, cancelable, value);
    }

}
}
// vim:ft=actionscript
