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

import flash.events.Event;
import flash.utils.Dictionary;

import flexus.core.xwork.filterChain.IoFilterChain;
import flexus.core.xwork.session.AbstractIoSession;
import flexus.core.xwork.session.IoSession;
import flexus.flexus_internal;

/**
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class IoServiceListenerSupport {

    use namespace flexus_internal;

    /**
     * Creates an IoServiceListenerSupport instance.
     *
     * @param ioConnector An IoConnector associated this instance.
     */
    public function IoServiceListenerSupport(ioConnector:IoConnector) {
        if (!ioConnector) {
            throw new ArgumentError("ioConnector");
        }

        this._service = ioConnector;
    }

    /** Provides value for determining if the instance is active. */
    public var activated:Boolean = false;
    /** The <code>IoConnector</code> that this instance manages. */
    private var _service:IoConnector;

    /** @private */
    private var _managedSessions:Dictionary;

    /**
     * Tracks managed sessions.
     */
    public function get managedSessions():Dictionary {
        return _managedSessions;
    }

    /** @private */
    private var _cumulativeManagedSessionCount:Number = 0;

    /**
     * A global counter to count the number of sessions managed since the start.
     */
    public function get cumulativeManagedSessionCount():Number {
        return _cumulativeManagedSessionCount;
    }

    /** @private */
    private var _largestManagedSessionCount:int = 0;

    /**
     * A counter used to store the maximum sessions we managed since the listenerSupport has been activated.
     */
    public function get largestManagedSessionCount():int {
        return _largestManagedSessionCount;
    }

    /** @private */
    private var _activationTime:Number;

    /**
     * The time (in ms) this instance has been activated.
     */
    public function get activationTime():Number {
        return _activationTime;
    }

    /** @private */
    private var _managedSessionCount:int = 0;

    /**
     * The number of sessions managed since the listenerSupport has been activated.
     */
    public function get managedSessionCount():int {
        return _managedSessionCount;
    }

    /**
     * @private
     * Close all the sessions.
     */
    private function disconnectSessions():void {
        for each(var s:IoSession in _managedSessions) {
            s.close(true);
        }
    }

    /**
     * @private
     */
    flexus_internal function fireSessionCreated(session:IoSession):void {
        var first:Boolean = !_managedSessions;

        if (!_managedSessions)
            _managedSessions = new Dictionary;

        if (!(session.sessionId in _managedSessions)) {
            _managedSessions[session.sessionId] = session;
            _managedSessionCount++;
        } else // Already registered, ignore.
            return;

        // If the first connector session, fire a virtual service activation event.
        if (first) {
            fireServiceActivated();
        }

        // Fire session events.
        var chain:IoFilterChain = session.filterChain;
        chain.fireSessionCreated();

        if (managedSessionCount > _largestManagedSessionCount) {
            _largestManagedSessionCount = managedSessionCount;
        }

        _cumulativeManagedSessionCount++;

        _service.dispatchEvent(new IoServiceEvent(IoServiceEvent.SESSION_CREATED,
                session));
    }

    /**
     * @private
     */
    flexus_internal function fireSessionDestoryed(session:IoSession):void {
        // Try to remove the remaining empty session set after removal.
        if (!(session.sessionId in _managedSessions)) {
            return;
        }

        // Count down for _managedSessions.
        _managedSessionCount--;
        // Removes from the managedSessions.
        delete _managedSessions[session.sessionId];

        // Fire session events.
        session.close(true);

        session.filterChain.fireSessionClosed();

        // Notify to unload instance.
        session.dispatchEvent(new Event(Event.UNLOAD));

        // trace statistics if in debug mode.
        AbstractIoSession.flexus_internal::traceStatistics();

        // Fire listener events.
        if (_service) {
            try {
                _service.dispatchEvent(new IoServiceEvent(IoServiceEvent.SESSION_DESTORYED));
            } finally {
                // Fire a virtual service deactivation event for the last session of the connector.
                if (_managedSessionCount == 0) {
                    fireServiceDeactivated();
                }
            }
        }
    }

    /**
     * @private
     */
    flexus_internal function fireServiceActivated():void {
        if (activated) {
            // The instance is already active.
            return;
        }

        // Records the activation time.
        _activationTime = new Date().valueOf();
        activated = true;

        // Dispatches the activated event and log some data.
        if (_service) {
            _service.dispatchEvent(new IoServiceEvent(IoServiceEvent.SERVICE_ACTIVATED));
        }
    }

    /**
     * @private
     */
    flexus_internal function fireServiceDeactivated():void {
        if (!activated) {
            // The instance is already deactivated.
            return;
        }

        activated = false;

        // Deactivate all the listeners.
        try {
            if (_service) {
                _service.dispatchEvent(new IoServiceEvent(IoServiceEvent.SERVICE_DEACTIVATED));
            }
        } finally {
            disconnectSessions();
            _managedSessions = null;
        }
    }
}
}
// vim:ft=actionscript
