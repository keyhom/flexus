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

import flexus.logging.ILogger;
import flexus.logging.LogLevel;
import flexus.logging.targets.TraceTarget;

/**
 * Provides a logger target that used for XWork.
 *
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class XworkLogTarget extends TraceTarget {

    /**
     * @private
     */
    private static const _instance:XworkLogTarget = new XworkLogTarget();

    /**
     * Adds logger to the XWork logging category.
     *
     * @param logger The logger to add.
     * @return The logger instance add to.
     */
    public static function addLogger(logger:ILogger):ILogger {
        _instance.addLogger(logger);
        return logger;
    }

    /**
     * @private
     * Creates a XworkLogTarget instance.
     */
    public function XworkLogTarget() {
        super();
        this.filters = ['XWORK'];
        this.includeCategory = true;
        this.includeDate = true;
        this.includeLevel = true;
        this.includeTime = true;
        this.level = LogLevel.ALL;
    }
}
}
// vim:ft=actionscript