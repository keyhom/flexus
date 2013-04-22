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

import flash.utils.Dictionary;

import flexus.core.xwork.future.FutureEvent;
import flexus.core.xwork.session.AbstractIoSession;
import flexus.core.xwork.session.IoSession;
import flexus.errors.IllegalStateError;

/**
 * @author keyhom
 */
public class IoFilterChain {

    static public const SESSION_CREATE_FUTURE:String = "_sessionCreateFuture";

    /**
     * Creates an IoFilterChain instance.
     */
    public function IoFilterChain(session:AbstractIoSession) {
        if (session == null)
            throw new ArgumentError("session");
        this._session = session;
        this.head = new EntryImpl(this, null, null, "head", new HeadFilter());
        this.tail = new EntryImpl(this, this.head, null, "tail", new TailFilter());
        head.nextEntry = tail;
    }

    private var head:EntryImpl;
    private var name2entry:Dictionary = new Dictionary();
    private var tail:EntryImpl;

    private var _session:AbstractIoSession;

    public function get session():IoSession {
        return this._session;
    }

    public function addAfter(target:String, name:String, filter:IoFilter):void {
        var entry:EntryImpl = checkOldName(target);
        checkAddable(name);
        register(entry, name, filter);
    }

    public function addBefore(target:String, name:String, filter:IoFilter):void {
        var entry:EntryImpl = checkOldName(target);
        checkAddable(name);
        register(entry.preEntry, name, filter);
    }

    public function addFirst(name:String, filter:IoFilter):void {
        checkAddable(name);
        register(head, name, filter);
    }

    public function addLast(name:String, filter:IoFilter):void {
        checkAddable(name);
        register(tail.preEntry, name, filter);
    }

    public function clear():void {
        for each (var n:* in name2entry) {
            deregister(n as EntryImpl);
        }
    }

    public function contains(x:Object):Boolean {
        return getEntry(x) != null;
    }

    public function exceptionCaught(exception:Error):void {
//		var future:ConnectFuture = session.removeAttribute(SESSION_CREATE_FUTURE) as
//			ConnectFuture;
//
//		if (future == null)
//		{
        head.filter.exceptionCaught(head.nextFilter, session, exception);
//		}
//		else
//		{
//			session.close(true);
//			future.exception = exception;
//		}
    }

    public function fireFilterClose():void {
        tail.filter.filterClose(tail.nextFilter, session);
    }

    public function fireFilterWirte(message:Object):void {
        tail.filter.filterWrite(tail.nextFilter, session, message);
    }

    public function fireMessageReceived(message:Object):void {
        head.filter.messageReceived(head.nextFilter, session, message);
    }

    public function fireMessageSent(message:Object):void {
        try {
            //				request.future.setWritten();
        }
        catch (e:Error) {
            exceptionCaught(e);
        }

//		if (!message.encoded)
        head.filter.messageSent(head.nextFilter, session, message);
    }

    public function fireSessionClosed():void {
        session.dispatchEvent(new FutureEvent(FutureEvent.CLOSED, session));

        head.filter.sessionClosed(head.nextFilter, session);
    }

    public function fireSessionCreated():void {
        head.filter.sessionCreated(head.nextFilter, session);
    }

    public function fireSessionIdle(status:int):void {
        head.filter.sessionIdle(head.nextFilter, session, status);
    }

    public function get(x:Object):IoFilter {
        var e:IoFilterChainEntry = getEntry(x);

        if (e == null)
            return null;
        return e.filter;
    }

    public function getAll():Vector.<IoFilterChainEntry> {
        var arr:Vector.<IoFilterChainEntry> = new Vector.<IoFilterChainEntry>();
        var e:EntryImpl = head.nextEntry;

        while (e != tail) {
            arr.push(e);
            e = e.nextEntry;
        }
        return arr;
    }

    public function getAllReversed():Vector.<IoFilterChainEntry> {
        var arr:Vector.<IoFilterChainEntry> = new Vector.<IoFilterChainEntry>();
        var e:EntryImpl = tail.preEntry;

        while (e != head) {
            arr.push(e);
            e = e.preEntry;
        }
        return arr;
    }

    public function getEntry(x:Object):IoFilterChainEntry {
        if (x is String) {
            var e:IoFilterChainEntry = name2entry[(x as String)];

            if (e == null)
                return null;
            return e;
        }
        else if (x is IoFilter) {
            var e1:EntryImpl = head.nextEntry;

            while (e1 != tail) {
                if (e1.filter == x as IoFilter)
                    return e1;
                e1 = e1.nextEntry;
            }
            return null;
        }
        else if (x is Class) {
            var e2:EntryImpl = head.nextEntry;

            while (e2 != tail) {
                if (e2.isPrototypeOf(x))
                    return e2;
                e2 = e2.nextEntry;
            }
            return null;
        }
        return null;
    }

    public function getNextFilter(x:Object):NextFilter {
        var e:IoFilterChainEntry = getEntry(x);

        if (e == null)
            return null;
        return e.nextFilter;
    }

    public function remove(x:Object):IoFilter {
        return null;
    }

    public function replace(x:Object, filter:IoFilter):IoFilter {
        return null;
    }

    private function checkAddable(name:String):void {
        if ((name in name2entry)) {
            throw new ArgumentError("Other filter is using the same name '" +
                    name + "'");
        }
    }

    private function checkOldName(name:String):EntryImpl {
        var e:EntryImpl = name2entry[name] as EntryImpl;

        if (e == null)
            throw new ArgumentError("IoFilter not found: " + name);
        return e;
    }

    private function deregister(entry:EntryImpl):void {
        var filter:IoFilter = entry.filter;

        try {
            filter.onPreRemove(this, entry.name, entry.nextFilter);
        }
        catch (e:Error) {
            throw new IllegalStateError("IoFilterLifeCycleException");
        }
        deregister0(entry);

        try {
            filter.onPostRemove(this, entry.name, entry.nextFilter);
        }
        catch (e:Error) {
            throw new IllegalStateError("IoFilterLifeCycleException");
        }
    }

    private function deregister0(entry:EntryImpl):void {
        var preEntry:EntryImpl = entry.preEntry;
        var nextEntry:EntryImpl = entry.nextEntry;
        preEntry.nextEntry = nextEntry;
        nextEntry.preEntry = preEntry;
        delete name2entry[entry.name];
    }

    private function register(preEntry:EntryImpl, name:String, filter:IoFilter):void {
        var newEntry:EntryImpl = new EntryImpl(this, preEntry, preEntry.nextEntry,
                name, filter);

        try {
            filter.onPreAdd(this, name, newEntry.nextFilter);
        }
        catch (e:Error) {
            throw new IllegalStateError("IoFilterLifeCycleException");
        }

        preEntry.nextEntry.preEntry = newEntry;
        preEntry.nextEntry = newEntry;
        name2entry[name] = newEntry;

        try {
            filter.onPostAdd(this, name, newEntry.nextFilter);
        }
        catch (e:Error) {
            throw new IllegalStateError("IoFilterLifeCycleException");
        }
    }
}
}

import flexus.core.xwork.filterChain.IoFilter;
import flexus.core.xwork.filterChain.IoFilterChain;
import flexus.core.xwork.filterChain.IoFilterChainEntry;
import flexus.core.xwork.filterChain.NextFilter;
import flexus.core.xwork.service.IoServiceEvent;
import flexus.core.xwork.session.AbstractIoSession;
import flexus.core.xwork.session.IoSession;
import flexus.io.ByteBuffer;

class HeadFilter extends IoFilter {

    override public function filterClose(nextFilter:NextFilter, session:IoSession):void {
        // nothing to be done.
    }

    override public function filterWrite(nextFilter:NextFilter, session:IoSession, message:Object):void {
        var s:AbstractIoSession = session as AbstractIoSession;

        // Maintain counters.
        if (message is ByteBuffer) {
            // I/O processor implementation will call buffer.reset()
            // it after the write operation is finished, because
            // the buffer will be specified with messageSent event.
            var buf:ByteBuffer = message as ByteBuffer;
            buf.mark();
        }

        s.flush(message);
    }
}

class TailFilter extends IoFilter {

    override public function exceptionCaught(nextFilter:NextFilter, session:IoSession, exception:Error):void {
        const event:IoServiceEvent = new IoServiceEvent(IoServiceEvent.EXCEPTION_CAUSED,
                session, exception);
        session.handler.dispatchEvent(event);
    }

    override public function filterClose(nextFilter:NextFilter, session:IoSession):void {
        nextFilter.filterClose(session);
    }

    override public function filterWrite(nextFilter:NextFilter, session:IoSession, message:Object):void {
        nextFilter.filterWrite(session, message);
    }

    override public function messageReceived(nextFilter:NextFilter, session:IoSession, message:Object):void {
        const event:IoServiceEvent = new IoServiceEvent(IoServiceEvent.MESSAGE_RECEIVED,
                session, message);
        session.handler.dispatchEvent(event);
    }

    override public function messageSent(nextFilter:NextFilter, session:IoSession, message:Object):void {
        const event:IoServiceEvent = new IoServiceEvent(IoServiceEvent.MESSAGE_SENT,
                session, message);
        session.handler.dispatchEvent(event);
    }

    override public function sessionClosed(nextFilter:NextFilter, session:IoSession):void {
        try {
            const event:IoServiceEvent = new IoServiceEvent(IoServiceEvent.SESSION_CLOSED,
                    session);
            session.handler.dispatchEvent(event);
        }
        finally {
            try {
                session.filterChain.clear();
            }
            finally {
                // fuck.
            }
        }
    }

    override public function sessionCreated(nextFilter:NextFilter, session:IoSession):void {
        const event:IoServiceEvent = new IoServiceEvent(IoServiceEvent.SESSION_CREATED,
                session);
        session.handler.dispatchEvent(event);
    }

    override public function sessionIdle(nextFilter:NextFilter, session:IoSession, status:int):void {
        const event:IoServiceEvent = new IoServiceEvent(IoServiceEvent.SESSION_IDLED,
                session, status);
        session.handler.dispatchEvent(event);
    }
}

class EntryImpl implements IoFilterChainEntry {

    /**
     * Creates an EntryImpl instance.
     */
    public function EntryImpl(context:IoFilterChain, preEntry:EntryImpl, nextEntry:EntryImpl, name:String, filter:IoFilter) {
        super();

        if (filter == null)
            throw new ArgumentError("filter");

        if (name == null)
            throw new ArgumentError("name");

        this.othis = context;
        this._preEntry = preEntry;
        this._nextEntry = nextEntry;
        this._name = name;
        this._filter = filter;
        this._nextFilter = new XNextFilter(this);
    }

    private var _filter:IoFilter;

    public function get filter():IoFilter {
        return _filter;
    }


    public function set filter(filter:IoFilter):void {
        this._filter = filter;
    }

    private var _name:String;

    public function get name():String {
        return _name;
    }

    public function set name(value:String):void {
        this._name = name;
    }

    private var _nextEntry:EntryImpl;

    public function get nextEntry():EntryImpl {
        return this._nextEntry;
    }

    public function set nextEntry(value:EntryImpl):void {
        this._nextEntry = value;
    }

    private var _nextFilter:NextFilter;

    public function get nextFilter():NextFilter {
        return _nextFilter;
    }

    public function set nextFilter(filter:NextFilter):void {
        this._nextFilter = filter;
    }

    private var _preEntry:EntryImpl;

    public function get preEntry():EntryImpl {
        return this._preEntry;
    }

    public function set preEntry(value:EntryImpl):void {
        this._preEntry = value;
    }

    private var othis:IoFilterChain;


    public function addAfter(name:String, filter:IoFilter):void {
        othis.addAfter(this.name, name, filter);
    }

    public function addBefore(name:String, filter:IoFilter):void {
        othis.addBefore(this.name, name, filter);
    }

    public function remove():void {
        othis.remove(this.name);
    }

    public function replace(filter:IoFilter):void {
        othis.replace(this.name, filter);
    }
}

class XNextFilter implements NextFilter {

    /**
     * Creates a XNextFilter instance.
     */
    public function XNextFilter(othis:EntryImpl) {
        super();
        this.othis = othis;
    }

    private var othis:EntryImpl;

    public function exceptionCaught(session:IoSession, cause:Error):void {
        var entry:IoFilterChainEntry = othis.nextEntry;
        entry.filter.exceptionCaught(entry.nextFilter, session, cause);
    }

    public function filterClose(session:IoSession):void {
        var entry:IoFilterChainEntry = othis.preEntry;
        entry.filter.filterClose(entry.nextFilter, session);
    }

    public function filterWrite(session:IoSession, message:Object):void {
        var entry:IoFilterChainEntry = othis.preEntry;
        entry.filter.filterWrite(entry.nextFilter, session, message);
    }

    public function messageReceived(session:IoSession, message:Object):void {
        var entry:IoFilterChainEntry = othis.nextEntry;
        entry.filter.messageReceived(entry.nextFilter, session, message);
    }

    public function messageSent(session:IoSession, message:Object):void {
        var entry:IoFilterChainEntry = othis.nextEntry;
        entry.filter.messageSent(entry.nextFilter, session, message);
    }

    public function sessionClosed(session:IoSession):void {
        var entry:IoFilterChainEntry = othis.nextEntry;
        entry.filter.sessionClosed(entry.nextFilter, session);
    }

    public function sessionCreated(session:IoSession):void {
        var entry:IoFilterChainEntry = othis.nextEntry;
        entry.filter.sessionCreated(entry.nextFilter, session);
    }

    public function sessionIdle(session:IoSession, status:int):void {
        var entry:IoFilterChainEntry = othis.nextEntry;
        entry.filter.sessionIdle(entry.nextFilter, session, status);
    }
}

