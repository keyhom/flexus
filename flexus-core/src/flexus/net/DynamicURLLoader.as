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

package flexus.net {

import flash.net.URLLoader;

/**
 * Class that provides a dynamic implementation of the URLLoader class.
 *
 * This class provides no API implementation. However, since the class is
 * declared as dynamic, it can be used in place of URLLoader, and allow
 * you to dynamically attach properties to it (which URLLoader does not allow).
 *
 * @langversion ActionScript 3.0
 * @playerversion Flash 9.0
 * @tiptext
 */
public dynamic class DynamicURLLoader extends URLLoader {

    /**
     * Creates a DynamicURLLoader instance.
     */
    public function DynamicURLLoader() {
        super();
    }
}
}
