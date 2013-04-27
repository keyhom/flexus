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

import flash.events.Event;

import flexus.core.xwork.filterChain.DefaultIoFilterChainBuilder;
import flexus.core.xwork.future.FutureEvent;
import flexus.core.xwork.service.IoConnector;
import flexus.core.xwork.service.IoHandler;
import flexus.core.xwork.service.IoServiceEvent;
import flexus.core.xwork.session.IoSession;
import flexus.errors.IllegalStateError;
import flexus.events.Request;
import flexus.logging.ILogger;
import flexus.logging.LoggerFactory;
import flexus.socket.SocketAddress;
import flexus.socket.SocketConnector;
import flexus.utils.WeakReference;
import flexus.xwork.filters.codec.ProtocolCodecFactory;
import flexus.xwork.filters.codec.ProtocolCodecFilter;
import flexus.xwork.filters.logging.LoggingFilter;

/**
 * Fired when connected to the remote endpoint.
 */
[Event(name="connect", type="flash.events.Event")]
/**
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class IoMessageClient extends IoHandler {

    /**
     * @private
     */
    static private const _LOGGING:String = "logging";
    /**
     * @private
     */
    static private const _PROTOCOL_CODEC:String = "protocolCodec";
    /**
     * @private
     */
    static private const _LOGGER:ILogger = LoggerFactory.getLogger(IoMessageClient);
    /**
     * @private
     */
    static protected const INFOS:Object = {};

    /**
     * Creates an IoMessageClient instance.
     */
    public function IoMessageClient() {
        super();
        init();
    }

    /**
     * A factory for providing protocol-codec decoder/encoder.
     */
    public function get factory():ProtocolCodecFactory {
        var chain:DefaultIoFilterChainBuilder = client.filterChain;

        if (chain && chain.contains(_PROTOCOL_CODEC)) {
            return ProtocolCodecFilter(chain.get(_PROTOCOL_CODEC)).factory;
        }

        return null;
    }

    /**
     *  @private
     */
    public function set factory(value:ProtocolCodecFactory):void {
        if (!value)
            throw new ArgumentError("Invalid factory value!");

        if (!client)
            throw new IllegalStateError("Invalid client instance!");

        var chain:DefaultIoFilterChainBuilder = client.filterChain;

        if (chain) {
            if (chain.contains(_PROTOCOL_CODEC))
                chain.replace(_PROTOCOL_CODEC, new ProtocolCodecFilter(value));
            else
                chain.addLast(_PROTOCOL_CODEC, new ProtocolCodecFilter(value));
        }
    }

    /**
     * @private
     */
    private var _remoteAddress:SocketAddress;

    /**
     * Inet-Address of remote host.
     */
    public function get remoteAddress():SocketAddress {
        return _remoteAddress;
    }

    /**
     * @private
     */
    public function set remoteAddress(value:SocketAddress):void {
        _remoteAddress = value;
    }

    /**
     * @private
     * Storage for the matcher property.
     */
    private var _matcher:IoMessageMatcher;

    /**
     * The matcher of the client object.
     */
    public function get matcher():IoMessageMatcher {
        return _matcher;
    }

    /**
     * @private
     */
    public function set matcher(value:IoMessageMatcher):void {
        if (!value)
            throw new ArgumentError("Invalid value for IoMessageMatcher!");

        this._matcher = value;
    }

    /**
     * @private
     * Storage for the useWeakContext property.
     */
    private var _useWeakContext:Boolean = false;

    [Inspectable(enumeration="true,false", defaultValue="false")]

    /**
     * Checks if the client use the weak context storing is.
     */
    public function get useWeakContext():Boolean {
        return _useWeakContext;
    }

    /**
     * @private
     */
    public function set useWeakContext(value:Boolean):void {
        _useWeakContext = value;
    }

    /**
     * Determines if enable the logging writing.
     */
    public function get enableLogging():Boolean {
        return true;
    }

    /**
     * @private
     */
    private var _client:IoConnector;

    /**
     * Client connector instance.
     */
    protected function get client():IoConnector {
        return _client;
    }

    /**
     *  @private
     */
    protected function set client(value:IoConnector):void {
        if (!value)
            throw new ArgumentError("Invalid value for IoConnector!");

        _client = value;
    }

    /**
     * Bind with contract to the <code>IoMessage</code> and return the info
     * interface for processing.
     *
     * @param contract the specific contract bind with the specified message.
     * @param clazz the specific class derived from the IoMessage
     *
     * @throw ArgumentError
     * @throw IllegalStateError
     */
    public function bind(contract:*, clazz:Class = null):IoMessageInfo {
        return new IoMessageInfoImpl(contract, clazz);
    }

    /**
     * @inheritDoc
     */
    public function send(info:IoMessageInfo, remoteAddress:SocketAddress = null):void {
        if (!remoteAddress)
            remoteAddress = this.remoteAddress;

        if (!remoteAddress)
            throw new IllegalStateError("Invalid remoteAddress to connect!");

        client.connect(remoteAddress, function (future:FutureEvent):void {
            if (future && future.session && future.session.connected) {
                injectSession(info, future.session);
                dispatchEvent(new Event(Event.CONNECT));
                future.session.write(info);
            }
        });
    }

    /**
     * @private
     */
    public function listen(info:IoMessageInfo):void {
        if (!info) {
            throw new ArgumentError("Invalid message info object to listen!");
        }

        if (useWeakContext) {
            var wr:WeakReference = new WeakReference(info);
            INFOS[info.contract] = wr;
        }
        else {
            INFOS[info.contract] = info;
        }
    }

    /**
     * Injects the specific session to the target message.
     */
    protected function injectSession(info:IoMessageInfo, session:IoSession):void {
        if (info is IoMessageInfoImpl) {
            IoMessageInfoImpl(info).session = session;
        }
    }

    /**
     * @inheritDoc
     */
    protected function init():void {
        // initialize.
        if (!client)
            client = new SocketConnector;

        const chain:DefaultIoFilterChainBuilder = client.filterChain;
        if (enableLogging)
            chain.addLast(_LOGGING, new LoggingFilter);

        if (factory)
            chain.addLast(_PROTOCOL_CODEC, new ProtocolCodecFilter(factory));
        client.handler = this;

        if (!this.hasEventListener(IoServiceEvent.MESSAGE_RECEIVED))
            this.addEventListener(IoServiceEvent.MESSAGE_RECEIVED, messageReceivedHandler);
    }

    /**
     * @private
     */
    protected function messageReceivedHandler(e:IoServiceEvent):void {
        const req:Request = e.attachment as Request;

        if (req && req.type == IoMessage.DECODE) {
            if (matcher) {
                const info:IoMessageInfo = matcher.match(req, INFOS);

                if (info && info.message) {
                    if (info is IoMessageInfoImpl)
                        IoMessageInfoImpl(info).session = e.session;

                    info.message.dispatchEvent(req);
                }
            }
        }
        else {
            _LOGGER.warn("unknown message request...");
        }
    }
}
}

import flash.events.EventDispatcher;

import flexus.core.xwork.session.IoSession;
import flexus.errors.IllegalStateError;
import flexus.message.IoMessage;
import flexus.message.IoMessageInfo;

class IoMessageInfoImpl extends EventDispatcher implements IoMessageInfo {

    public function IoMessageInfoImpl(contract:*, clazz:Class = null) {
        super();

        if (!contract)
            throw new ArgumentError("Invalid contract!");

        this._contract = contract;

        if (clazz) {
            this._deriveType = clazz;

            try {
                this._message = new clazz(this);
            }
            catch (e:Error) {
                throw new IllegalStateError("Invalid deriveClass for IoMessage!");
            }
        }
    }

    /**
     *  @private
     *  Storage for the contract property.
     */
    private var _contract:*;

    /**
     * The contract object.
     */
    public function get contract():* {
        return _contract;
    }

    /**
     * @private
     * Storage for the deriveType property.
     */
    private var _deriveType:Class;

    /**
     * The class of the derive type.
     */
    public function get deriveType():Class {
        return _deriveType;
    }

    /**
     * @private
     * Storage for the message property.
     */
    private var _message:IoMessage;

    /**
     * Retrieves the message bind with the info interface.
     */
    public function get message():IoMessage {
        return _message;
    }

    /**
     * @private
     * Storage for the session property.
     */
    private var _session:IoSession;

    /**
     * Retrieves the session object.
     */
    public function get session():IoSession {
        return _session;
    }

    /**
     * @private
     */
    public function set session(value:IoSession):void {
        if (!value)
            throw new ArgumentError("Invalid value for session!");

        this._session = value;
    }
}
// vim:ft=actionscript
