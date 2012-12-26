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

import flash.utils.Dictionary;

/**
 *
 *  @author keyhom.c
 */
public class WeakReference
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param value
	 */
	public function WeakReference(value:* = null)
	{
		super();

		if (value)
			put(value);
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// context 
	//----------------------------------

	/**
	 *  @private
	 */
	private const context:Dictionary = new Dictionary;

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Clear
	 *
	 *  @return this weak reference context object.
	 */
	public function clear():WeakReference
	{
		var o:* = get();

		while (o)
		{
			context[o] = null;
			delete context[o];
			o = get();
		}

		return this;
	}

	/**
	 *  Checks if empty it's.
	 *
	 *  @return true if emtpty it's, false otherwise.
	 */
	public function empty():Boolean
	{
		return get() == null;
	}

	/**
	 *  Retrieves the value of the WeakReference.
	 *
	 *  @return the value
	 */
	public function get():*
	{
		for (var k:* in context)
		{
			return k;
		}
		return null;
	}

	/**
	 *  Puts the value into this WeakReference context.
	 *
	 *  @return this weak reference context object.
	 */
	public function put(value:*):WeakReference
	{
		if (!value)
			throw new ArgumentError("Invalid value for WeakReference!");

		clear();
		context[value] = true;
		return this;
	}
}

}
