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

package flexus.dgms.globals.model
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
[Bindable]
public dynamic class UserPM
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
	public function UserPM()
	{
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// email 
	//----------------------------------

	private var _email:String;

	public function get email():String
	{
		return _email;
	}

	public function set email(value:String):void
	{
		_email = value;
	}

	//----------------------------------
	// id 
	//----------------------------------

	private var _id:int;

	public function get id():int
	{
		return _id;
	}

	public function set id(value:int):void
	{
		_id = value;
	}

	//----------------------------------
	// name 
	//----------------------------------

	private var _name:String;

	public function get name():String
	{
		return _name;
	}

	public function set name(value:String):void
	{
		_name = value;
	}

	//----------------------------------
	// passWord 
	//----------------------------------

	private var _passWord:String;

	public function get passWord():String
	{
		return _passWord;
	}

	public function set passWord(value:String):void
	{
		_passWord = value;
	}
}
}
