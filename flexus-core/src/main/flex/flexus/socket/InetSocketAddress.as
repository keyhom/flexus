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

package flexus.socket {

import flexus.net.IpAddress;
import flexus.utils.StringUtil;

/**
 * Represents the socket address for Internet.
 *
 * @author keyhom
 */
public class InetSocketAddress implements SocketAddress {

    /**
     * Creates an InetSocketAddress instance.
     */
    public function InetSocketAddress(host:*, port:Number = 80) {
        if (host is String) {
            if (!StringUtil.isEmpty(host)) {
                if (host == '*')
                    _host = new IpAddress;
                else if (IpAddress.isValid(host))
                    _host = new IpAddress(host);
            }
        }

        this._port = port;
    }

    private var _host:IpAddress;

    public function get host():IpAddress {
        return _host;
    }

    private var _port:Number;

    public function get port():uint {
        return _port;
    }

    public function toString():String {
        return host.toString() + ':' + port;
    }
}
}
