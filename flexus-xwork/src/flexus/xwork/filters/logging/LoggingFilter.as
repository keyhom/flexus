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

package flexus.xwork.filters.logging {

import flexus.core.xwork.XworkLogTarget;
import flexus.core.xwork.filterChain.IoFilter;
import flexus.core.xwork.filterChain.NextFilter;
import flexus.core.xwork.session.IoSession;
import flexus.logging.ILogger;
import flexus.logging.LogLogger;

/**
 * @author keyhom
 */
public class LoggingFilter extends IoFilter {

    /**
     * Creates a LoggingFilter instance.
     */
    public function LoggingFilter(name:String = null, level:int = 4) {
        _logger = new LogLogger(name ? name : 'XWORK');
        this.logLevel = level;
        XworkLogTarget.addLogger(_logger);
    }

    public var logLevel:int;
    private var _logger:ILogger;

    override public function exceptionCaught(nextFilter:NextFilter, session:IoSession, cause:Error):void {
        _logger.log(logLevel, "EXCEPTION - [{0}] {1}:{2} - {3}", cause.errorID,
                cause.name, cause.message, cause.getStackTrace());
        nextFilter.exceptionCaught(session, cause);
    }

    override public function messageReceived(nextFilter:NextFilter, session:IoSession, message:Object):void {
        _logger.log(logLevel, "RECEIVED  - {0}", message);
        nextFilter.messageReceived(session, message);
    }

    override public function messageSent(nextFilter:NextFilter, session:IoSession, message:Object):void {
        _logger.log(logLevel, "SENT      - {0}", message);
        nextFilter.messageSent(session, message);
    }

    override public function sessionClosed(nextFilter:NextFilter, session:IoSession):void {
        _logger.log(logLevel, "CLOSED");
        nextFilter.sessionClosed(session);
    }

    override public function sessionCreated(nextFilter:NextFilter, session:IoSession):void {
        _logger.log(logLevel, "CREATED");
        nextFilter.sessionCreated(session);
    }

    override public function sessionIdle(nextFilter:NextFilter, session:IoSession, status:int):void {
        _logger.log(logLevel, "IDLE      - {0}", status);
        nextFilter.sessionIdle(session, status);
    }
}
}
