//------------------------------------------------------------------------------
//
//   PureArt Archetype. Make any work easier. 
// 
//   Copyright (C) 2011  pureart.org 
// 
//   This program is free software: you can redistribute it and/or modify 
//   it under the terms of the GNU General Public License as published by 
//   the Free Software Foundation, either version 3 of the License, or 
//   (at your option) any later version. 
// 
//   This program is distributed in the hope that it will be useful, 
//   but WITHOUT ANY WARRANTY; without even the implied warranty of 
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
//   GNU General Public License for more details. 
// 
//   You should have received a copy of the GNU General Public License 
//   along with this program.  If not, see <http://www.gnu.org/licenses/>. 
//
//------------------------------------------------------------------------------

package flexus.core.xwork.filterChain
{

import flash.utils.Dictionary;
import flexus.core.xwork.future.FutureEvent;
import flexus.core.xwork.session.AbstractIoSession;
import flexus.core.xwork.session.IoSession;
import flexus.errors.IllegalStateError;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class IoFilterChain
{
	//----------------------------------
	// SESSION_CREATE_FUTURE 
	//----------------------------------

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public const SESSION_CREATE_FUTURE:String = "_sessionCreateFuture";

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param session
	 *  @throws ArgumentError
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function IoFilterChain(session:AbstractIoSession)
	{
		if (session == null)
			throw new ArgumentError("session");
		this._session = session;
		this.head = new EntryImpl(this, null, null, "head", new HeadFilter());
		this.tail = new EntryImpl(this, this.head, null, "tail", new TailFilter());
		head.nextEntry = tail;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// session 
	//----------------------------------

	private var _session:AbstractIoSession;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get session():IoSession
	{
		return this._session;
	}

	//----------------------------------
	// head 
	//----------------------------------

	private var head:EntryImpl;

	//----------------------------------
	// name2entry 
	//----------------------------------

	private var name2entry:Dictionary = new Dictionary();

	//----------------------------------
	// tail 
	//----------------------------------

	private var tail:EntryImpl;

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param target
	 *  @param name
	 *  @param filter
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function addAfter(target:String, name:String, filter:IoFilter):void
	{
		var entry:EntryImpl = checkOldName(target);
		checkAddable(name);
		register(entry, name, filter);
	}

	/**
	 *
	 *  @param target
	 *  @param name
	 *  @param filter
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function addBefore(target:String, name:String, filter:IoFilter):void
	{
		var entry:EntryImpl = checkOldName(target);
		checkAddable(name);
		register(entry.preEntry, name, filter);
	}

	/**
	 *
	 *  @param name
	 *  @param filter
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function addFirst(name:String, filter:IoFilter):void
	{
		checkAddable(name);
		register(head, name, filter);
	}

	/**
	 *
	 *  @param name
	 *  @param filter
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function addLast(name:String, filter:IoFilter):void
	{
		checkAddable(name);
		register(tail.preEntry, name, filter);
	}

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function clear():void
	{
		for each (var n:* in name2entry)
		{
			deregister(n as EntryImpl);
		}
	}

	/**
	 *
	 *  @param x
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function contains(x:Object):Boolean
	{
		return getEntry(x) != null;
	}

	/**
	 *
	 *  @param exception
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function exceptionCaught(exception:Error):void
	{
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

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function fireFilterClose():void
	{
		tail.filter.filterClose(tail.nextFilter, session);
	}

	/**
	 *
	 *  @param request
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function fireFilterWirte(message:Object):void
	{
		tail.filter.filterWrite(tail.nextFilter, session, message);
	}

	/**
	 *
	 *  @param message
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function fireMessageRecieved(message:Object):void
	{
		head.filter.messageRecieved(head.nextFilter, session, message);
	}

	/**
	 *
	 *  @param request
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function fireMessageSent(message:Object):void
	{
		try
		{
			//				request.future.setWritten();
		}
		catch (e:Error)
		{
			exceptionCaught(e);
		}

//		if (!message.encoded)
		head.filter.messageSent(head.nextFilter, session, message);
	}

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function fireSessionClosed():void
	{
		session.dispatchEvent(new FutureEvent(FutureEvent.CLOSED, session));

		head.filter.sessionClosed(head.nextFilter, session);
	}

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function fireSessionCreated():void
	{
		head.filter.sessionCreated(head.nextFilter, session);
	}

	/**
	 *
	 *  @param status
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function fireSessionIdle(status:int):void
	{
		head.filter.sessionIdle(head.nextFilter, session, status);
	}

	/**
	 *
	 *  @param x
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get(x:Object):IoFilter
	{
		var e:IoFilterChainEntry = getEntry(x);

		if (e == null)
			return null;
		return e.filter;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getAll():Vector.<IoFilterChainEntry>
	{
		var arr:Vector.<IoFilterChainEntry> = new Vector.<IoFilterChainEntry>();
		var e:EntryImpl = head.nextEntry;

		while (e != tail)
		{
			arr.push(e);
			e = e.nextEntry;
		}
		return arr;
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getAllReversed():Vector.<IoFilterChainEntry>
	{
		var arr:Vector.<IoFilterChainEntry> = new Vector.<IoFilterChainEntry>();
		var e:EntryImpl = tail.preEntry;

		while (e != head)
		{
			arr.push(e);
			e = e.preEntry;
		}
		return arr;
	}

	/**
	 *
	 *  @param x
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getEntry(x:Object):IoFilterChainEntry
	{
		if (x is String)
		{
			var e:IoFilterChainEntry = name2entry[(x as String)];

			if (e == null)
				return null;
			return e;
		}
		else if (x is IoFilter)
		{
			var e1:EntryImpl = head.nextEntry;

			while (e1 != tail)
			{
				if (e1.filter == x as IoFilter)
					return e1;
				e1 = e1.nextEntry;
			}
			return null;
		}
		else if (x is Class)
		{
			var e2:EntryImpl = head.nextEntry;

			while (e2 != tail)
			{
				if (e2.isPrototypeOf(x))
					return e2;
				e2 = e2.nextEntry;
			}
			return null;
		}
		return null;
	}

	/**
	 *
	 *  @param x
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getNextFilter(x:Object):NextFilter
	{
		var e:IoFilterChainEntry = getEntry(x);

		if (e == null)
			return null;
		return e.nextFilter;
	}

	/**
	 *
	 *  @param x
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function remove(x:Object):IoFilter
	{
		return null;
	}

	/**
	 *
	 *  @param x
	 *  @param filter
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function replace(x:Object, filter:IoFilter):IoFilter
	{
		return null;
	}

	/**
	 *
	 *  @param name
	 *  @throws ArgumentError
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function checkAddable(name:String):void
	{
		if ((name in name2entry))
		{
			throw new ArgumentError("Other filter is using the same name '" +
									name + "'");
		}
	}

	/**
	 *
	 *  @param name
	 *  @return
	 *  @throws ArgumentError
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function checkOldName(name:String):EntryImpl
	{
		var e:EntryImpl = name2entry[name] as EntryImpl;

		if (e == null)
			throw new ArgumentError("IoFilter not found: " + name);
		return e;
	}

	/**
	 *
	 *  @param entry
	 *  @throws IllegalStateError
	 *  @throws IllegalStateError
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function deregister(entry:EntryImpl):void
	{
		var filter:IoFilter = entry.filter;

		try
		{
			filter.onPreRemove(this, entry.name, entry.nextFilter);
		}
		catch (e:Error)
		{
			throw new IllegalStateError("IoFilterLifeCycleException");
		}
		deregister0(entry);

		try
		{
			filter.onPostRemove(this, entry.name, entry.nextFilter);
		}
		catch (e:Error)
		{
			throw new IllegalStateError("IoFilterLifeCycleException");
		}
	}

	/**
	 *
	 *  @param entry
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function deregister0(entry:EntryImpl):void
	{
		var preEntry:EntryImpl = entry.preEntry;
		var nextEntry:EntryImpl = entry.nextEntry;
		preEntry.nextEntry = nextEntry;
		nextEntry.preEntry = preEntry;
		delete name2entry[entry.name];
	}

	/**
	 *
	 *  @param preEntry
	 *  @param name
	 *  @param filter
	 *  @throws IllegalStateError
	 *  @throws IllegalStateError
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function register(preEntry:EntryImpl, name:String, filter:IoFilter):void
	{
		var newEntry:EntryImpl = new EntryImpl(this, preEntry, preEntry.nextEntry,
											   name, filter);

		try
		{
			filter.onPreAdd(this, name, newEntry.nextFilter);
		}
		catch (e:Error)
		{
			throw new IllegalStateError("IoFilterLifeCycleException");
		}

		preEntry.nextEntry.preEntry = newEntry;
		preEntry.nextEntry = newEntry;
		name2entry[name] = newEntry;

		try
		{
			filter.onPostAdd(this, name, newEntry.nextFilter);
		}
		catch (e:Error)
		{
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

class HeadFilter extends IoFilter
{

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override public function filterClose(nextFilter:NextFilter, session:IoSession):void
	{
		// nothing to be done.
	}

	override public function filterWrite(nextFilter:NextFilter, session:IoSession,
										 message:Object):void
	{
		var s:AbstractIoSession = session as AbstractIoSession;

		// Maintain counters.
		if (message is ByteBuffer)
		{
			// I/O processor implementation will call buffer.reset()
			// it after the write operation is finished, because
			// the buffer will be specified with messageSent event.
			var buf:ByteBuffer = message as ByteBuffer;
			buf.mark();
		}

		s.flush(message);
	}
}

class TailFilter extends IoFilter
{

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override public function exceptionCaught(nextFilter:NextFilter, session:IoSession,
											 exception:Error):void
	{
		const event:IoServiceEvent = new IoServiceEvent(IoServiceEvent.EXCEPTION_CAUSED,
													  session, exception);
		session.handler.dispatchEvent(event);
	}

	override public function filterClose(nextFilter:NextFilter, session:IoSession):void
	{
		nextFilter.filterClose(session);
	}

	override public function filterWrite(nextFilter:NextFilter, session:IoSession,
										 message:Object):void
	{
		nextFilter.filterWrite(session, message);
	}

	override public function messageRecieved(nextFilter:NextFilter, session:IoSession,
											 message:Object):void
	{
		const event:IoServiceEvent = new IoServiceEvent(IoServiceEvent.MESSAGE_RECIEVED,
													  session, message);
		session.handler.dispatchEvent(event);
	}

	override public function messageSent(nextFilter:NextFilter, session:IoSession,
										 message:Object):void
	{
		const event:IoServiceEvent = new IoServiceEvent(IoServiceEvent.MESSAGE_SENT,
													  session, message);
		session.handler.dispatchEvent(event);
	}

	override public function sessionClosed(nextFilter:NextFilter, session:IoSession):void
	{
		try
		{
			const event:IoServiceEvent = new IoServiceEvent(IoServiceEvent.SESSION_CLOSED,
														  session);
			session.handler.dispatchEvent(event);
		}
		finally
		{
			try
			{
				session.filterChain.clear();
			}
			finally
			{
				// fuck.
			}
		}
	}

	override public function sessionCreated(nextFilter:NextFilter, session:IoSession):void
	{
		const event:IoServiceEvent = new IoServiceEvent(IoServiceEvent.SESSION_CREATED,
													  session);
		session.handler.dispatchEvent(event);
	}

	override public function sessionIdle(nextFilter:NextFilter, session:IoSession,
										 status:int):void
	{
		const event:IoServiceEvent = new IoServiceEvent(IoServiceEvent.SESSION_IDLED,
													  session, status);
		session.handler.dispatchEvent(event);
	}
}

/**
 *
 *  @author keyhom.c
 */
class EntryImpl implements IoFilterChainEntry
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param context
	 *  @param preEntry
	 *  @param nextEntry
	 *  @param name
	 *  @param filter
	 *  @throws ArgumentError
	 *  @throws ArgumentError
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function EntryImpl(context:IoFilterChain, preEntry:EntryImpl, nextEntry:EntryImpl,
							  name:String, filter:IoFilter)
	{
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

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// filter 
	//----------------------------------

	private var _filter:IoFilter;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get filter():IoFilter
	{
		return _filter;
	}

	/**
	 *
	 *  @param filter
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function set filter(filter:IoFilter):void
	{
		this._filter = filter;
	}

	//----------------------------------
	// name 
	//----------------------------------

	private var _name:String;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get name():String
	{
		return _name;
	}

	/**
	 *
	 *  @param value
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function set name(value:String):void
	{
		this._name = name;
	}

	//----------------------------------
	// nextEntry 
	//----------------------------------

	private var _nextEntry:EntryImpl;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get nextEntry():EntryImpl
	{
		return this._nextEntry;
	}

	/**
	 *
	 *  @param value
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function set nextEntry(value:EntryImpl):void
	{
		this._nextEntry = value;
	}

	//----------------------------------
	// nextFilter 
	//----------------------------------

	private var _nextFilter:NextFilter;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get nextFilter():NextFilter
	{
		return _nextFilter;
	}

	/**
	 *
	 *  @param filter
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function set nextFilter(filter:NextFilter):void
	{
		this._nextFilter = filter;
	}

	//----------------------------------
	// preEntry 
	//----------------------------------

	private var _preEntry:EntryImpl;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get preEntry():EntryImpl
	{
		return this._preEntry;
	}

	/**
	 *
	 *  @param value
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function set preEntry(value:EntryImpl):void
	{
		this._preEntry = value;
	}

	//----------------------------------
	// othis 
	//----------------------------------

	private var othis:IoFilterChain;

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param name
	 *  @param filter
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function addAfter(name:String, filter:IoFilter):void
	{
		othis.addAfter(this.name, name, filter);
	}

	/**
	 *
	 *  @param name
	 *  @param filter
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function addBefore(name:String, filter:IoFilter):void
	{
		othis.addBefore(this.name, name, filter);
	}

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function remove():void
	{
		othis.remove(this.name);
	}

	/**
	 *
	 *  @param filter
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function replace(filter:IoFilter):void
	{
		othis.replace(this.name, filter);
	}
}

class XNextFilter implements NextFilter
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param othis
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function XNextFilter(othis:EntryImpl)
	{
		super();
		this.othis = othis;
	}

	//----------------------------------
	// othis 
	//----------------------------------

	private var othis:EntryImpl;

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param session
	 *  @param cause
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function exceptionCaught(session:IoSession, cause:Error):void
	{
		var entry:IoFilterChainEntry = othis.nextEntry;
		entry.filter.exceptionCaught(entry.nextFilter, session, cause);
	}

	/**
	 *
	 *  @param session
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function filterClose(session:IoSession):void
	{
		var entry:IoFilterChainEntry = othis.preEntry;
		entry.filter.filterClose(entry.nextFilter, session);
	}

	/**
	 *
	 *  @param session
	 *  @param request
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function filterWrite(session:IoSession, message:Object):void
	{
		var entry:IoFilterChainEntry = othis.preEntry;
		entry.filter.filterWrite(entry.nextFilter, session, message);
	}

	/**
	 *
	 *  @param session
	 *  @param message
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function messageRecieved(session:IoSession, message:Object):void
	{
		var entry:IoFilterChainEntry = othis.nextEntry;
		entry.filter.messageRecieved(entry.nextFilter, session, message);
	}

	/**
	 *
	 *  @param session
	 *  @param request
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function messageSent(session:IoSession, message:Object):void
	{
		var entry:IoFilterChainEntry = othis.nextEntry;
		entry.filter.messageSent(entry.nextFilter, session, message);
	}

	/**
	 *
	 *  @param session
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function sessionClosed(session:IoSession):void
	{
		var entry:IoFilterChainEntry = othis.nextEntry;
		entry.filter.sessionClosed(entry.nextFilter, session);
	}

	/**
	 *
	 *  @param session
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function sessionCreated(session:IoSession):void
	{
		var entry:IoFilterChainEntry = othis.nextEntry;
		entry.filter.sessionCreated(entry.nextFilter, session);
	}

	/**
	 *
	 *  @param session
	 *  @param status
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function sessionIdle(session:IoSession, status:int):void
	{
		var entry:IoFilterChainEntry = othis.nextEntry;
		entry.filter.sessionIdle(entry.nextFilter, session, status);
	}

}

