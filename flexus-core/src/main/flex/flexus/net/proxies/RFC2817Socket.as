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

package flexus.net.proxies
{

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.Socket;

/**
 * This class allows TCP socket connections through HTTP proxies in accordance with
 * RFC 2817:
 *
 * ftp://ftp.rfc-editor.org/in-notes/rfc2817.txt
 *
 * It can also be used to make direct connections to a destination, as well. If you
 * pass the host and port into the constructor, no proxy will be used. You can also
 * call connect, passing in the host and the port, and if you didn't set the proxy
 * info, a direct connection will be made. A proxy is only used after you have called
 * the setProxyInfo function.
 *
 * The connection to and negotiation with the proxy is completely hidden. All the
 * same events are thrown whether you are using a proxy or not, and the data you
 * receive from the target server will look exact as it would if you were connected
 * to it directly rather than through a proxy.
 *
 * @author Christian Cantrell
 *
 **/
public class RFC2817Socket extends Socket
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 * Construct a new RFC2817Socket object. If you pass in the host and the port,
	 * no proxy will be used. If you want to use a proxy, instantiate with no
	 * arguments, call setProxyInfo, then call connect.
	 **/
	public function RFC2817Socket(host:String = null, port:int = 0)
	{
		super(host, port);
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// buffer 
	//----------------------------------

	private var buffer:String = new String();

	//----------------------------------
	// deferredEventHandlers 
	//----------------------------------

	private var deferredEventHandlers:Object = new Object();

	//----------------------------------
	// host 
	//----------------------------------

	private var host:String = null;

	//----------------------------------
	// port 
	//----------------------------------

	private var port:int = 0;

	//----------------------------------
	// proxyHost 
	//----------------------------------

	private var proxyHost:String = null;

	//----------------------------------
	// proxyPort 
	//----------------------------------

	private var proxyPort:int = 0;

	//--------------------------------------------------------------------------
	//
	//  Overridden methods 
	//
	//--------------------------------------------------------------------------

	override public function addEventListener(type:String, listener:Function,
											  useCapture:Boolean = false, priority:int =
											  0.0, useWeakReference:Boolean =
											  false):void
	{
		if (type == Event.CONNECT || type == ProgressEvent.SOCKET_DATA)
		{
			this.deferredEventHandlers[type] = {listener:listener,useCapture:useCapture, priority:priority, useWeakReference:useWeakReference};
		}
		else
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	}

	/**
	 * Connect to the specified host over the specified port. If you want your
	 * connection proxied, call the setProxyInfo function first.
	 **/
	override public function connect(host:String, port:int):void
	{
		if (this.proxyHost == null)
		{
			this.redirectConnectEvent();
			this.redirectSocketDataEvent();
			super.connect(host, port);
		}
		else
		{
			this.host = host;
			this.port = port;
			super.addEventListener(Event.CONNECT, this.onConnect);
			super.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
			super.connect(this.proxyHost, this.proxyPort);
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 * Set the proxy host and port number. Your connection will only proxied if
	 * this function has been called.
	 **/
	public function setProxyInfo(host:String, port:int):void
	{
		this.proxyHost = host;
		this.proxyPort = port;

		var deferredSocketDataHandler:Object = this.deferredEventHandlers[ProgressEvent.
			SOCKET_DATA];
		var deferredConnectHandler:Object = this.deferredEventHandlers[Event.
			CONNECT];

		if (deferredSocketDataHandler != null)
		{
			super.removeEventListener(ProgressEvent.SOCKET_DATA, deferredSocketDataHandler.
									  listener, deferredSocketDataHandler.useCapture);
		}

		if (deferredConnectHandler != null)
		{
			super.removeEventListener(Event.CONNECT, deferredConnectHandler.
									  listener, deferredConnectHandler.useCapture);
		}
	}

	private function checkResponse(event:ProgressEvent):void
	{
		var responseCode:String = this.buffer.substr(this.buffer.indexOf(" ") +
													 1, 3);

		if (responseCode.search(/^2/) == -1)
		{
			var ioError:IOErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR);
			ioError.text = "Error connecting to the proxy [" + this.proxyHost +
				"] on port [" + this.proxyPort + "]: " + this.buffer;
			this.dispatchEvent(ioError);
		}
		else
		{
			this.redirectSocketDataEvent();
			this.dispatchEvent(new Event(Event.CONNECT));
			if (this.bytesAvailable > 0)
			{
				this.dispatchEvent(event);
			}
		}
		this.buffer = null;
	}

	private function onConnect(event:Event):void
	{
		this.writeUTFBytes("CONNECT " + this.host + ":" + this.port + " HTTP/1.1\n\n");
		this.flush();
		this.redirectConnectEvent();
	}

	private function onSocketData(event:ProgressEvent):void
	{
		while (this.bytesAvailable != 0)
		{
			this.buffer += this.readUTFBytes(1);
			if (this.buffer.search(/\r?\n\r?\n$/) != -1)
			{
				this.checkResponse(event);
				break;
			}
		}
	}

	private function redirectConnectEvent():void
	{
		super.removeEventListener(Event.CONNECT, onConnect);
		var deferredEventHandler:Object = this.deferredEventHandlers[Event.CONNECT];
		if (deferredEventHandler != null)
		{
			super.addEventListener(Event.CONNECT, deferredEventHandler.listener,
								   deferredEventHandler.useCapture, deferredEventHandler.
								   priority, deferredEventHandler.useWeakReference);
		}
	}

	private function redirectSocketDataEvent():void
	{
		super.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		var deferredEventHandler:Object = this.deferredEventHandlers[ProgressEvent.
			SOCKET_DATA];
		if (deferredEventHandler != null)
		{
			super.addEventListener(ProgressEvent.SOCKET_DATA, deferredEventHandler.
								   listener, deferredEventHandler.useCapture,
								   deferredEventHandler.priority, deferredEventHandler.
								   useWeakReference);
		}
	}
}
}
