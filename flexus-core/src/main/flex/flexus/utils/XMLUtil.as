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

package flexus.utils {

/**
 * Utilities for XML.
 *
 * @version $Revision$
 * @author keyhom
 */
public class XMLUtil {

    /**
     * Constant representing an attribute type returned from XML.nodeKind.
     *
     * @see XML.nodeKind()
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     */
    static public const ATTRIBUTE:String = "attribute";
    /**
     * Constant representing a comment node type returned from XML.nodeKind.
     *
     * @see XML.nodeKind()
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     */
    static public const COMMENT:String = "comment";
    /**
     * Constant representing a element type returned from XML.nodeKind.
     *
     * @see XML.nodeKind()
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     */
    static public const ELEMENT:String = "element";
    /**
     * Constant representing a processing instruction type returned from XML.nodeKind.
     *
     * @see XML.nodeKind()
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     */
    static public const PROCESSING_INSTRUCTION:String = "processing-instruction";
    /**
     * Constant representing a text node type returned from XML.nodeKind.
     *
     * @see XML.nodeKind()
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     */
    static public const TEXT:String = "text";

    /**
     * Returns the next sibling of the specified node relative to the node's parent.
     *
     * @param x The node whose next sibling will be returned.
     *
     * @return The next sibling of the node. null if the node does not have
     * a sibling after it, or if the node has no parent.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     */
    static public function getNextSibling(x:XML):XML {
        return XMLUtil.getSiblingByIndex(x, 1);
    }

    /**
     * Returns the sibling before the specified node relative to the node's parent.
     *
     * @param x The node whose sibling before it will be returned.
     *
     * @return The sibling before the node. null if the node does not have
     * a sibling before it, or if the node has no parent.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     */
    static public function getPreviousSibling(x:XML):XML {
        return XMLUtil.getSiblingByIndex(x, -1);
    }

    /**
     * Checks whether the specified string is valid and well formed XML.
     *
     * @param data The string that is being checked to see if it is valid XML.
     *
     * @return A Boolean value indicating whether the specified string is
     * valid XML.
     *
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     */
    static public function isValidXML(data:String):Boolean {
        var xml:XML;

        try {
            xml = new XML(data);
        }
        catch (e:Error) {
            return false;
        }

        if (xml.nodeKind() != XMLUtil.ELEMENT) {
            return false;
        }

        return true;
    }

    static protected function getSiblingByIndex(x:XML, count:int):XML {
        var out:XML;

        try {
            out = x.parent().children()[x.childIndex() + count];
        }
        catch (e:Error) {
            return null;
        }

        return out;
    }
}
}
