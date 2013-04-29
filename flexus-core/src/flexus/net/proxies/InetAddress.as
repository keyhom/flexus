/*
 * Copyright (c) 2013. 枫秀网络 All right reserved.
 */

package flexus.net.proxies {

import flexus.utils.StringUtil;

/**
 * Represents an endpoint address of inet.
 *
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class InetAddress {

    /**
     * Provides an InetAddress by the supplied host name.
     *
     * @param host The host name.
     */
    public static function getByName(host:String):InetAddress {
        if (!StringUtil.isEmpty(host)) {
            return new InetAddress(host);
        }
        return null;
    }

    /**
     * @private
     *
     * Creates an InetAddress instance.
     */
    public function InetAddress(host:String) {
        this._hostAddress = host;
    }

    /** @private */
    private var _hostAddress:String;

    /**
     * Represents a string value of host address.
     */
    public function get hostAddress():String {
        return _hostAddress;
    }

}
}
// vim:ft=actionscript
