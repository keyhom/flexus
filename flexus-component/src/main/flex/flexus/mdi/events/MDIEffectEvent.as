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

package flexus.mdi.events
{

import mx.events.EffectEvent;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class MDIEffectEvent extends EffectEvent
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 * Constructor
	 *
	 * @param type EffectEvent.EFFECT_START or EfectEvent.EFFECT_END
	 * @param mdiEventType Corresponding mdi event type like minimize, maximize, tile, etc. Will be one of MDIManagerEvent's static types.
	 * @param windows List of windows involved in effect. Will be a single element except for cascade and tile.
	 */
	public function MDIEffectEvent(type:String, mdiEventType:String, windows:Array)
	{
		super(type);

		this.mdiEventType = mdiEventType;
		this.windows = windows;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// mdiEventType 
	//----------------------------------

	/**
	 * Corresponds to type property of corresponding MDIManagerEvent.
	 */
	public var mdiEventType:String;

	//----------------------------------
	// windows 
	//----------------------------------

	/**
	 * List of windows involved in effect.
	 */
	public var windows:Array;
}
}
