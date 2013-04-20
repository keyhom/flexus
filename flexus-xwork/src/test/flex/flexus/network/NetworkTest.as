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

package flexus.network {

import flexus.core.xwork.filterChain.DefaultIoFilterChainBuilder;
import flexus.core.xwork.future.FutureEvent;
import flexus.core.xwork.service.IoConnector;
import flexus.core.xwork.service.IoHandler;
import flexus.core.xwork.service.IoServiceEvent;
import flexus.io.ByteBuffer;
import flexus.socket.InetSocketAddress;
import flexus.socket.SocketAddress;
import flexus.socket.SocketConnector;
import flexus.xwork.filters.codec.ProtocolCodecFilter;
import flexus.xwork.filters.codec.SimpleProtocolCodecFactory;
import flexus.xwork.filters.logging.LoggingFilter;

import org.flexunit.Assert;
import org.flexunit.async.Async;

/**
 * @version $Revision$
 * @author keyhom
 */
public class NetworkTest {

    internal static function onSessionClosed(e:IoServiceEvent, ptData:Object = null):void {
        Assert.assertNotNull(e.session);
        Assert.assertFalse(e.session.connected);
        Assert.assertNull(e.attachment);
    }

    [Ignore]
    internal static function onSessionIdled(e:IoServiceEvent, ptData:Object = null):void {
        Assert.assertNotNull(e.session);
    }

    internal static function onMessageReceived(e:IoServiceEvent, ptData:Object = null):void {
        Assert.assertNotNull(e.session);
        Assert.assertTrue(e.session.connected);
        Assert.assertNotNull(e.attachment);
        Assert.assertTrue(e.attachment is String);
    }

    internal static function onMessageSent(e:IoServiceEvent, ptData:Object = null):void {
        Assert.assertNotNull(e.session);
        Assert.assertTrue(e.session.connected);
        Assert.assertNotNull(e.attachment);
        Assert.assertTrue(e.attachment is ByteBuffer);
    }

    [Before]
    public function setUp():void {
    }

    [Test]
    public function testCreated():void {
        createConnector();
    }

    [Test(async)]
    public function testConnect():void {
        const ioConnector:IoConnector = createConnector();
        Assert.assertNotNull(ioConnector);

        const remoteAddress:SocketAddress = new InetSocketAddress("220.181.111.147", 80);
        ioConnector.connect(remoteAddress, function (future:FutureEvent = null):void {
            Assert.assertNotNull(future);
            Assert.assertTrue(future.completed);
            Assert.assertNotNull(future.session);
        });

        const handler:IoHandler = ioConnector.handler;
        Assert.assertNotNull(handler);

        var createdHandler:Function = Async.asyncHandler(this, onSessionCreated, 3000);
        handler.addEventListener(IoServiceEvent.SESSION_CREATED, createdHandler);

        var sentHandler:Function = Async.asyncHandler(this, onMessageSent, 4000);
        handler.addEventListener(IoServiceEvent.MESSAGE_SENT, sentHandler);

        // var idledHandler:Function = Async.asyncHandler(this, onSessionIdled, 1000);
        // handler.addEventListener(IoServiceEvent.SESSION_IDLED, onSessionIdled);

        var recvHandler:Function = Async.asyncHandler(this, onMessageReceived, 5000);
        handler.addEventListener(IoServiceEvent.MESSAGE_RECEIVED, recvHandler);

        var closedHandler:Function = Async.asyncHandler(this, onSessionClosed, 6000);
        handler.addEventListener(IoServiceEvent.SESSION_CLOSED, closedHandler);
    }

    public function onSessionCreated(e:IoServiceEvent, ptData:Object = null):void {
        Assert.assertNotNull(e.session);
        Assert.assertTrue(e.session.connected);
        Assert.assertTrue(e.session.sessionId != 0);
        Assert.assertNull(e.attachment);

        var bytes:ByteBuffer = new ByteBuffer;
        bytes.putString("GET / HTTP/1.0\r\n");
        bytes.putString("Host: www.baidu.com\r\n");
        // bytes.putString("Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n");
        // bytes.putString("Accept-Language: zh-CN,zh;q=0.8\r\n");
        bytes.putString("\r\n");
        bytes.flip();

        Assert.assertTrue(bytes.limit > bytes.position);
        Assert.assertTrue(bytes.hasRemaining);
        Assert.assertFalse(bytes.remaining == 0);

        // write ByteBuffer, this isn't passing to the encoder.
        e.session.write(bytes);
    }

    protected function createConnector():IoConnector {
        const ioConnector:IoConnector = new SocketConnector();
        const filterChain:DefaultIoFilterChainBuilder = ioConnector.filterChain;

        // filter chain validation.
        Assert.assertNotNull(filterChain);

        filterChain.addLast("Logging", new LoggingFilter());
        filterChain.addLast("Codec", new ProtocolCodecFilter(new SimpleProtocolCodecFactory(new SimpleProtocolEncoder()
                , new SimpleProtocolDecoder())));
        ioConnector.handler = new IoHandler();
        return ioConnector;
    }
}
}

import flexus.core.xwork.session.IoSession;
import flexus.io.ByteBuffer;
import flexus.xwork.filters.codec.CumulativeProtocolDecoder;
import flexus.xwork.filters.codec.ProtocolDecoderOutput;
import flexus.xwork.filters.codec.ProtocolEncoder;
import flexus.xwork.filters.codec.ProtocolEncoderOutput;

class SimpleProtocolEncoder extends ProtocolEncoder {

    override public function encode(session:IoSession, message:Object, out:ProtocolEncoderOutput):void {
    }
}

class SimpleProtocolDecoder extends CumulativeProtocolDecoder {

    override protected function doDecode(session:IoSession, buf:ByteBuffer, out:ProtocolDecoderOutput):Boolean {
        if (buf.hasRemaining) {
            var data:String = buf.getString();
            if (data.indexOf("\r\n\r\n")) {
                if (!Boolean(session.getAttribute("$_header", false))) {
                    session.setAttribute("$_header", true);
                } else {
                    out.write(data);
                }
                return true;
            }
        }
        return false;
    }
}
