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

package flexus.core.xwork.service {

import flexus.core.xwork.filterChain.IoFilterChain;
import flexus.core.xwork.session.IoSession;

/**
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class IoServiceListenerSupport {

    /**
     * Creates an IoServiceListenerSupport instance.
     */
    public function IoServiceListenerSupport() {
    }

    /**
     * @private
     */
    private var managedSessions:Object;

    /**
     * @private
     */
    internal function fireSessionCreated(session:IoSession):void {
        var first:Boolean = !managedSessions;

        if (!managedSessions)
            managedSessions = {};

        if (!(session.sessionId in managedSessions))
            managedSessions[session.sessionId] = session;

        if (first) {
            fireServiceActivated();
        }

        var chain:IoFilterChain = session.filterChain;
        chain.fireSessionCreated();
//		chain.fireSessionOpened(); 
        // Fixed to remove this chain at future.

        session.service.dispatchEvent(new IoServiceEvent(IoServiceEvent.SESSION_CREATED,
                session));
    }

    private function fireServiceActivated():void {
        // dispatch the activated event and log some data.
    }
}
}
// vim:ft=actionscript
