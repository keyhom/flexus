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

package flexus.core.xwork.session {

import flash.events.IEventDispatcher;

import flexus.core.xwork.filterChain.IoFilterChain;
import flexus.core.xwork.service.IoConnector;
import flexus.core.xwork.service.IoHandler;

/**
 * @author keyhom
 */
public interface IoSession extends IEventDispatcher {
    // connected
    function get connected():Boolean;

    // filterChain
    function get filterChain():IoFilterChain;

    // handler
    function get handler():IoHandler;

    // service
    function get service():IoConnector;

    // sessionId
    function get sessionId():uint;

    function close(now:Boolean = false, closeFuture:Function = null):void;

    function containsAttribute(key:Object):Boolean;

    function getAttribute(key:Object, defaultValue:Object = null):Object;

    function getAttributeKeys():Array;

    function removeAttribute(key:Object, value:Object = null):Object;

    function replaceAttribute(key:Object, oldValue:Object, newValue:Object):Object;

    function setAttribute(key:Object, value:Object):Object;

    function setAttributeIfAbsent(key:Object, value:Object):Object;

    function write(message:Object, writeFuture:Function = null):void;
}
}
