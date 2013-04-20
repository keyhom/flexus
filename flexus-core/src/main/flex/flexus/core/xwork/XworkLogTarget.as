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

package flexus.core.xwork {

import mx.logging.ILogger;
import mx.logging.LogEventLevel;
import mx.logging.targets.TraceTarget;

/**
 * @author keyhom
 */
public class XworkLogTarget extends TraceTarget {

    static private var _instance:XworkLogTarget = new XworkLogTarget;

    /**
     * Adds logger to the ENSA logging categories.
     */
    static public function addLogger(logger:ILogger):ILogger {
        _instance.addLogger(logger);
        return logger;
    }

    /**
     * Creates a XworkLogTarget instance.
     */
    public function XworkLogTarget() {
        super();
        this.filters = ['ENSA'];
        this.includeCategory = true;
        this.includeDate = true;
        this.includeLevel = true;
        this.includeTime = true;
        this.level = LogEventLevel.ALL;
    }
}
}
// vim:ft=actionscript
