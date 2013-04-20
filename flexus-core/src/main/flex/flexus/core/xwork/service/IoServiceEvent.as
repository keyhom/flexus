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

import flexus.core.xwork.session.IoSession;

/**
 * @author keyhom
 */
public class IoServiceEvent extends Event {

    static public const EXCEPTION_CAUSED:String = "exceptionCaused";
    static public const MESSAGE_RECIEVED:String = "messageRecieved";
    static public const MESSAGE_SENT:String = "messageSent";
    static public const SERVICE_ACTIVATED:String = "serviceActivated";
    static public const SERVICE_CLOSED:String = "serviceClosed";
    static public const SERVICE_DEACTIVATED:String = "serviceDeactivated";
    static public const SESSION_CLOSED:String = "sessionClosed";
    static public const SESSION_CREATED:String = "sessionCreated";
    static public const SESSION_IDLED:String = "sessionIdled";

    /**
     * Creates a IoServiceEvent instance.
     */
    public function IoServiceEvent(type:String, session:IoSession = null, attachment:Object =
            null) {
        super(type, false, false);
        this.session = session;
        this.attachment = attachment;
    }

    public var attachment:Object;
    public var session:IoSession;
}
}
