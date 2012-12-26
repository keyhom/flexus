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

import flexus.metadata.Metadata;

[ExcludeClass]
/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class EventHandler extends Metadata
{

	static private const USE_WEAK_REFERENCE:String = "useWeakReference";

	static private const EVENT_TARGET:String = "target";

	static private const EVENT_NAME:String = "name";

	static private const BUBBLES:String = "bubbles";

	static private const PRIORITY:String = "priority";

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function EventHandler()
	{
		super();
	}

	public function get target():String
	{
		if (EVENT_TARGET in properties)
			return properties[EVENT_TARGET];
		return null;
	}

	public function get bubbles():Boolean
	{
		if (BUBBLES in properties)
			return properties[BUBBLES];
		return false;
	}

	public function get priority():int
	{
		if (PRIORITY in properties)
			return parseInt(properties[PRIORITY]);
		return 0;
	}

	public function get useWeakReference():Boolean
	{
		if (USE_WEAK_REFERENCE in properties)
			return properties[USE_WEAK_REFERENCE] as Boolean;
		return false;
	}

}
}
