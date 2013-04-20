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

package flexus.core.xwork.filterChain {

import flexus.core.xwork.session.IoSession;

/**
 * @author keyhom
 */
public class IoFilter {

    public function destroy():void {
    }

    public function exceptionCaught(nextFilter:NextFilter, session:IoSession, cause:Error):void {
        nextFilter.exceptionCaught(session, cause);
    }

    public function filterClose(nextFilter:NextFilter, session:IoSession):void {
        nextFilter.filterClose(session);
    }

    public function filterWrite(nextFilter:NextFilter, session:IoSession, message:Object):void {
        nextFilter.filterWrite(session, message);
    }

    public function init():void {
    }

    public function messageRecieved(nextFilter:NextFilter, session:IoSession, message:Object):void {
        nextFilter.messageRecieved(session, message);
    }

    public function messageSent(nextFilter:NextFilter, session:IoSession, message:Object):void {
        nextFilter.messageSent(session, message);
    }

    public function onPostAdd(filter:IoFilterChain, name:String, nextFilter:NextFilter):void {
    }

    public function onPostRemove(filter:IoFilterChain, name:String, nextFilter:NextFilter):void {
    }

    public function onPreAdd(filter:IoFilterChain, name:String, nextFilter:NextFilter):void {
    }

    public function onPreRemove(filter:IoFilterChain, name:String, nextFilter:NextFilter):void {
    }

    public function sessionClosed(nextFilter:NextFilter, session:IoSession):void {
        nextFilter.sessionClosed(session);
    }

    public function sessionCreated(nextFilter:NextFilter, session:IoSession):void {
        nextFilter.sessionCreated(session);
    }

    public function sessionIdle(nextFilter:NextFilter, session:IoSession, status:int):void {
        nextFilter.sessionIdle(session, status);
    }

}
}
