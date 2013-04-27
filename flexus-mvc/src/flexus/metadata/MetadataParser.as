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

/**
 * @author keyhom.c
 */
public class MetadataParser
{

	//--------------------------------------------------------------------------
	//
	//  Class properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// _impl 
	//----------------------------------

	/**
	 * Implemetation.
	 *
	 * @default
	 */
	static public var _impl:Object;

	//----------------------------------
	// cacheEnabled 
	//----------------------------------

	/**
	 * 是否开启类型信息缓存
	 *
	 * @default
	 */
	static public var cacheEnabled:Boolean = false;

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 * Constructor
	 */
	public function MetadataParser()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 * @param target
	 * @return
	 */
	public function parse(target:Object):IMetaInfo
	{
		if (target is Class || target is Object)
			return _impl.parse(target);
		return null;
	}
}
}

import flash.net.getClassByAlias;
import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import flexus.metadata.IMetaElement;
import flexus.metadata.IMetaInfo;
import flexus.metadata.IMetadata;
import flexus.metadata.Metadata;
import flexus.metadata.MetadataParser;

{
	MetadataParser._impl = new ParserImpl();
}

/**
 *
 * @author jeremy
 */
class ParserImpl
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 * Constructor
	 *
	 */
	public function ParserImpl()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// _typeCache 
	//----------------------------------

	/**
	 * 类型信息缓存对象
	 */
	private var _typeCache:Object = new Object;

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 * @param target
	 * @return
	 */
	public function parse(target:Object):IMetaInfo
	{
		if (target == null)
			return null;

		var type:XML;

		if (MetadataParser.cacheEnabled)
		{
			var _cacheKey:String = getQualifiedClassName(target);

			if (!_typeCache.hasOwnProperty(_cacheKey))
				_typeCache[_cacheKey] = describeType(target);
			type = _typeCache[_cacheKey];
		}
		else
			type = describeType(target);



		var info:MetaInfoImpl = new MetaInfoImpl;

		if (type is XML)
		{
			var metadatas:XMLList = type..metadata.(@name != '__go_to_definition_help' &&
				@name != '__go_to_ctor_definition_help');

			for each (var k:XML in metadatas)
			{
				var mdName:String = k.@name;
				var args:XMLList  = k.arg;
				var mdClass:Class;

				try
				{
					mdClass = getClassByAlias(mdName);
				}
				catch (e:Error)
				{
					mdClass = null;
				}

				if (mdClass)
				{
					var o:* = new mdClass;

					if (o is Metadata)
					{
						var md:Metadata = Metadata(o);
						md.AS3::tagName = mdName;
						var pairs:Object = {};

						if (args && args.length() > 0)
						{
							for each (var arg:XML in args)
							{
								if (arg.@key.toString().length > 0)
									pairs[arg.@key] = arg.@value;
								else
									pairs[md.name] = arg.@value;
							}
						}
						md.AS3::pairs = pairs;
						// resolve the binding element.
						md.AS3::element = resolveElement(k.parent());
						info.put(mdClass, md);
					}
				}
			}
		}
		return info;
	}

	/**
	 * Resolve the binding element
	 *
	 * @param node
	 * @return
	 */
	private function resolveElement(node:XML):IMetaElement
	{
		if (node)
		{
			var name:String = node.@name;
			var type:String = node.@type;
			return new MetaElementImpl(name, type);
		}
		return null;
	}
}

/**
 * MetaElement implementation.
 *
 * @author jeremy
 */
class MetaElementImpl implements IMetaElement
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 * @param name
	 * @param type
	 */
	public function MetaElementImpl(name:String, type:*)
	{
		super();
		this._name = name;

		if (type is Class)
		{
			this._type = type;
			this._typeName = getQualifiedClassName(type);
		}
		else if (type is String)
		{
			this._typeName = type;
			var resolveType:Class;

			try
			{
				resolveType = Class(getDefinitionByName(type));
			}
			catch (e:Error)
			{
				try
				{
					resolveType = Class(getClassByAlias(type));
				}
				catch (e1:Error)
				{
					resolveType = null;
				}
			}

			if (resolveType)
				this._type = resolveType;
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// name 
	//----------------------------------

	/**
	 * @private
	 * Storage for the name property.
	 */
	private var _name:String;

	/**
	 * @{inheritDoc}
	 */
	public function get name():String
	{
		return _name;
	}

	//----------------------------------
	// type 
	//----------------------------------

	/**
	 * @private
	 * Storage for the type property.
	 */
	private var _type:Class;

	/**
	 * @{inheritDoc}
	 */
	public function get type():Class
	{
		return _type;
	}
	
	private var _typeName:String;
	
	public function get typeName():String
	{
		return _typeName;
	}

	//----------------------------------
	// parameters
	//----------------------------------

	/**
	 * @private
	 * Storage for the parameter property.
	 */
	private var _parameters:Array;

	/**
	 * @{inheritDoc}
	 */
	public function get parameters():Array
	{
		return _parameters;
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 * @return
	 */
	public function toString():String
	{
		return "IMetaElement [ name=" + _name + ", type=" + _typeName + ", params=" + _parameters + " ]";
	}
}

/**
 *
 * @author jeremy
 */
class MetaInfoImpl implements IMetaInfo
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 * Constructor
	 */
	public function MetaInfoImpl()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// _maps 
	//----------------------------------

	/**
	 *
	 * @default
	 */
	internal var _maps:Dictionary = new Dictionary(true);

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 * @param key
	 * @return
	 */
	public function get(key:Object):Object
	{
		var _key:* = null;

		if (key is IMetadata)
		{
			_key = getDefinitionByName(getQualifiedClassName(key));
		}
		else if (key is Class)
		{
			_key = key;
		}

		if (_key in _maps)
		{
			return _maps[_key];
		}
		return null;
	}

	/**
	 *
	 * @param mdClass
	 * @param data
	 */
	internal function put(mdClass:Class, data:IMetadata):void
	{
		if (!(mdClass in _maps))
		{
			_maps[mdClass] = new Vector.<IMetadata>;
		}
		Vector.<IMetadata>(_maps[mdClass]).push(data);
	}
}
