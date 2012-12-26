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

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ArrayQueue implements IQueue
{

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
	public function ArrayQueue(capacity:uint = 65535)
	{
		super();
		this._capacity = capacity;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// empty 
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
	public function get empty():Boolean
	{
		return _index == _tailIndex;
	}

	//----------------------------------
	// _capacity 
	//----------------------------------

	private var _capacity:uint;

	//----------------------------------
	// _index 
	//----------------------------------

	private var _index:int = 0;

	//----------------------------------
	// _queue 
	//----------------------------------

	private var _queue:Array = new Array;

	//----------------------------------
	// _tailIndex 
	//----------------------------------

	private var _tailIndex:int = 0;

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param o
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function offer(o:Object):void
	{
		if (_queue.length == _capacity)
		{
			// put the object to the first index.
			_queue[0] = o;
			_tailIndex = 0;
		}
		else
		{
			// default strategy.
			_queue.push(o);
			_tailIndex++;
		}
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function peek():Object
	{
		checkIndex();
		return _queue[_index];
	}

	/**
	 *
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function poll():Object
	{
		checkIndex();
		var o:Object = _queue[_index];
		_queue[_index] = null;
		_index++;
		return o;
	}

	/**
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private function checkIndex():void
	{
		if (_index == _capacity)
			_index = 0;
	}

	public function get size():uint
	{
		if (_index <= _tailIndex)
			return _tailIndex - _index;
		else
		{
			return _capacity - _index + _tailIndex;
		}
	}

	public function clear():void
	{
		_index = 0;
		_tailIndex = 0;
		_queue = [];
	}
}
}
