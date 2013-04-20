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

import mx.logging.ILogger;
import mx.logging.LogEventLevel;
import mx.logging.LogLogger;
import mx.logging.targets.TraceTarget;

/**
 * @author keyhom
 */
public class LoggerFactory {

    static private const _TARGET:TraceTarget = new TraceTarget;
    static private const _FACTORY:LoggerFactory = new LoggerFactory;
    static private const _LOGGERS:Object = {};

    /**
     * Returns the logger object for the specific <code>clazz</code>.
     */
    static public function getLogger(clazz:Class):ILogger {
        var qname:String = getQualifiedClassName(clazz);

        if (!(qname in _LOGGERS)) {
            _LOGGERS[qname] = newLogger(qname);
        }
        var dic:Dictionary = _LOGGERS[qname] as Dictionary;

        if (dic) {
            for (var k:* in dic) {
                return k as ILogger;
            }
        }
        else {
            delete _LOGGERS[qname];
        }
        return getLogger(clazz);
    }

    static protected function newLogger(qname:String):Dictionary {
        var dic:Dictionary = new Dictionary;
        var logger:ILogger = new LogLogger(qname);
        _TARGET.addLogger(logger);
        dic[logger] = true;
        return dic;
    }

    public function LoggerFactory() {
        if (_FACTORY)
            throw new IllegalStateError("LoggerFactory is static class!");

        if (_TARGET) {
            _TARGET.includeCategory = true;
            _TARGET.includeDate = true;
            _TARGET.includeLevel = true;
            _TARGET.includeTime = true;
            _TARGET.level = LogEventLevel.ALL;
        }

    }
}
}
