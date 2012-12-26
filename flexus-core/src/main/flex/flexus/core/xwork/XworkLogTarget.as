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

package flexus.core.xwork
{

import mx.logging.ILogger;
import mx.logging.LogEventLevel;
import mx.logging.targets.TraceTarget;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class XworkLogTarget extends TraceTarget
{
	//----------------------------------
	// _instance 
	//----------------------------------

	static private var _instance:XworkLogTarget = new XworkLogTarget;

	//--------------------------------------------------------------------------
	//
	//  Class methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Add logger to the ENSA logging catagory.
	 *
	 *  @param logger
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public function addLogger(logger:ILogger):ILogger
	{
		_instance.addLogger(logger);
		return logger;
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
	public function XworkLogTarget()
	{
		super();
		this.filters = ['ENSA'];
		this.includeCategory = true;
		this.includeDate = true;
		this.includeLevel = true;
		this.includeTime = true;
		this.level = LogEventLevel.ALL;
	}
}
}
