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

package flexus.logging {

import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import flexus.errors.IllegalStateError;
import flexus.logging.targets.TraceTarget;
import flexus.utils.WeakReference;

/**
 * Represents a factory facade for creating the ILogger interface.
 *
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class LoggerFactory {

    /**
     * @private
     */
    private static const _TARGET:TraceTarget = new TraceTarget();
    /**
     * @private
     */
    private static const _FACTORY:LoggerFactory = new LoggerFactory();
    /**
     * @private
     */
    private static const _LOGGERS:Dictionary = new Dictionary();

    /**
     * Gets an implementation of ILogger.
     *
     * @param obj Class or Name of class to be specified.
     * @return An ILogger instance.
     */
    public static function getLogger(obj:*):ILogger {
        var qname:String = null;

        if (obj is String) {
            qname = String(obj);
        } else if (obj is Class) {
            qname = getQualifiedClassName(obj);
        } else {
            throw new ArgumentError("Invalid class or name for ILogger.");
        }

        if (!(qname in _LOGGERS)) {
            _LOGGERS[qname] = newLogger(qname);
        }

        const ref:WeakReference = _LOGGERS[qname] as WeakReference;
        const value:ILogger = ref ? ref.get() as ILogger : null;

        if (value) {
            return value;
        } else {
            delete _LOGGERS[qname];
        }

        return getLogger(qname);
    }

    /**
     * @private
     */
    protected static function newLogger(qname:String):WeakReference {
        const logger:ILogger = new LogLogger(qname);
        _TARGET.addLogger(logger);

        const ref:WeakReference = new WeakReference(logger);
        return ref;
    }

    /**
     * Creates a LoggerFactory instance.
     */
    public function LoggerFactory() {
        super();

        if (_FACTORY) {
            throw new IllegalStateError("LoggerFactory is static class!");
        }

        if (_TARGET) {
            _TARGET.includeCategory = true;
            _TARGET.includeDate = true;
            _TARGET.includeTime = true;
            _TARGET.includeLevel = true;
            _TARGET.level = LogLevel.ALL;
        }
    }

}
}
// vim:ft=actionscript
