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

package flexus.message {

import flash.events.IEventDispatcher;

/**
 *  The event fired when the remote message was resolved by the client
 *  adapter. In the event handling, also make sure to close the session
 *  if short connecting it is, but long connecting should be validating
 *  only.
 */
[Event(name="resolved", type="flexus.message.IoMessageEvent")]

/**
 *  The event fired when the remote message was received and just
 *  ready to handle the message logic.
 */
[Event(name="ready", type="flexus.message.IoMessageEvent")]

/**
 *  The event fired when the remote message was received and just
 *  staring to decode the data.
 */
[Event(name="messageReceived", type="flexus.message.IoMessageEvent")]

/**
 *  The event fired when the local message was sent and need to
 *  encode the data.
 */
[Event(name="messageSent", type="flexus.message.IoMessageEvent")]

/**
 * Represents an information object of IoMessage.
 *
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public interface IoMessageInfo extends IEventDispatcher {
    /**
     *  Retrieves the contract object which binding with the
     *  information interface.
     */
    function get contract():*;

    /**
     *  Retrieves the derive type of the IoMessage.
     */
    function get deriveType():Class;

    /**
     *  Retrieves the instance object of the IoMessage.
     */
    function get message():IoMessage;

}
}
// vim:ft=actionscript
