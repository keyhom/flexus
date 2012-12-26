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

package flexus.utils
{

public class XMLUtil
{

	//--------------------------------------------------------------------------
	//
	//  Class properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// ATTRIBUTE 
	//----------------------------------

	/**
	 * Constant representing an attribute type returned from XML.nodeKind.
	 *
	 * @see XML.nodeKind()
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 */
	static public const ATTRIBUTE:String = "attribute";

	//----------------------------------
	// COMMENT 
	//----------------------------------

	/**
	 * Constant representing a comment node type returned from XML.nodeKind.
	 *
	 * @see XML.nodeKind()
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 */
	static public const COMMENT:String = "comment";

	//----------------------------------
	// ELEMENT 
	//----------------------------------

	/**
	 * Constant representing a element type returned from XML.nodeKind.
	 *
	 * @see XML.nodeKind()
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 */
	static public const ELEMENT:String = "element";

	//----------------------------------
	// PROCESSING_INSTRUCTION 
	//----------------------------------

	/**
	 * Constant representing a processing instruction type returned from XML.nodeKind.
	 *
	 * @see XML.nodeKind()
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 */
	static public const PROCESSING_INSTRUCTION:String = "processing-instruction";

	//----------------------------------
	// TEXT 
	//----------------------------------

	/**
	 * Constant representing a text node type returned from XML.nodeKind.
	 *
	 * @see XML.nodeKind()
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 */
	static public const TEXT:String = "text";

	//--------------------------------------------------------------------------
	//
	//  Class methods 
	//
	//--------------------------------------------------------------------------

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
	static public function getNextSibling(x:XML):XML
	{
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
	static public function getPreviousSibling(x:XML):XML
	{
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
	static public function isValidXML(data:String):Boolean
	{
		var xml:XML;

		try
		{
			xml = new XML(data);
		}
		catch (e:Error)
		{
			return false;
		}

		if (xml.nodeKind() != XMLUtil.ELEMENT)
		{
			return false;
		}

		return true;
	}

	static protected function getSiblingByIndex(x:XML, count:int):XML
	{
		var out:XML;

		try
		{
			out = x.parent().children()[x.childIndex() + count];
		}
		catch (e:Error)
		{
			return null;
		}

		return out;
	}
}
}
