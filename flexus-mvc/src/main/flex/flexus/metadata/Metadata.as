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

package flexus.metadata
{

use namespace AS3;

/**
 * Metadata abstract implemenetation.
 *
 * @author keyhom.c
 */
public class Metadata implements IMetadata
{

	//--------------------------------------------------------------------------
	//
	//  Class properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// FIELD 
	//----------------------------------

	/**
	 * @default
	 */
	static public const FIELD:String = "@Metadata";

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 * Constructor
	 */
	public function Metadata()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// keys 
	//----------------------------------

	private var _keys:Vector.<String>;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get keys():Vector.<String>
	{
		if (_pairs && _keys == null)
		{
			_keys = new Vector.<String>;

			for (var k:Object in _pairs)
			{
				_keys.push(k.toString());
			}
		}

		return _keys;
	}

	//----------------------------------
	// metaName 
	//----------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get metaName():String
	{
		return _tagName;
	}

	//----------------------------------
	// name 
	//----------------------------------

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
		return defaultKey;
	}

	//----------------------------------
	// properties 
	//----------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get properties():Object
	{
		return _pairs;
	}

	//----------------------------------
	// value 
	//----------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get value():String
	{
		if (_pairs)
		{
			return _pairs[defaultKey];
		}
		return null;
	}

	//----------------------------------
	// values 
	//----------------------------------

	private var _values:Array;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get values():Array
	{
		if (_pairs && _values == null)
		{
			_values = new Array;

			for each (var v:Object in _pairs)
			{
				_values.push(v);
			}
		}
		return _values;
	}

	//----------------------------------
	// defaultKey 
	//----------------------------------

	/**
	 * Override specially.
	 *
	 * @return default Key.
	 */
	protected function get defaultKey():String
	{
		return "name";
	}

	//----------------------------------
	// element 
	//----------------------------------

	private var _element:IMetaElement;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get element():IMetaElement
	{
		return _element;
	}

	AS3 function set element(value:IMetaElement):void
	{
		_element = value;
	}

	//----------------------------------
	// pairs 
	//----------------------------------

	private var _pairs:Object;

	AS3 function set pairs(value:Object):void
	{
		this._pairs = value;
	}

	//----------------------------------
	// tagName 
	//----------------------------------

	/**
	 * Storage for metaName property.
	 *
	 * @default
	 */
	private var _tagName:String;

	AS3 function set tagName(value:String):void
	{
		this._tagName = value;
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function toString():String
	{
		var s:String = '';

		if (properties)
		{
			for (var k:* in properties)
			{
				if (s.length > 0)
				{
					s += ', ';
				}
				s += k + '=>' + properties[k];
			}
		}
		s = metaName + "[ " + s + " ]";
		return s;
	}
}
}
