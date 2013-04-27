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

package flexus.context
{

import flash.events.IEventDispatcher;
import flash.net.registerClassAlias;

import flexus.metadata.IMetaElement;
import flexus.metadata.IMetaInfo;
import flexus.metadata.IMetadata;
import flexus.metadata.MetadataParser;

import mx.core.IMXMLObject;
import mx.core.UIComponent;

use namespace AS3;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Context implements IMXMLObject
{
	staticLoad();

	private static function staticLoad():void
	{
		registerClassAlias("EventHandler", EventHandler);
	}

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function Context()
	{
		super();
	}

	private var _handlers:Array;

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get handlers():Array
	{
		return _handlers;
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
	public function set handlers(value:Array):void
	{
		this._handlers = value;
	}

	/**
	 *
	 *  @default
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var document:UIComponent;

	/**
	 *
	 *  @param document
	 *  @param id
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function initialized(document:Object, id:String):void
	{
		this.document = document as UIComponent;

		if (this.document)
		{
			initializedHandlers();
		}
	}

	protected function initializedHandlers():void
	{
		if (this.handlers && this.handlers.length > 0)
		{
			var parser:MetadataParser = new MetadataParser;

			// needs to parse handlers.
			for each (var handler:Object in handlers)
			{
				var info:IMetaInfo = parser.parse(handler);
				var metas:Vector.<IMetadata> = info.get(EventHandler) as Vector.<IMetadata>;

				if (metas && metas.length > 0 && this.document)
				{
					for each (var m:IMetadata in metas)
					{
						var meta:EventHandler = m as EventHandler;
						var target:IEventDispatcher = null;

						if (meta.target in document)
						{
							target = document[meta.target] as IEventDispatcher;
						}
						else
							target = document as IEventDispatcher;

						var element:IMetaElement = m.element;
						var func:Function = handler[element.name] as Function;
						target.addEventListener(meta.value, func, meta.bubbles,
												meta.priority, meta.useWeakReference);
					}
				}
			}
		}
	}
}
}
