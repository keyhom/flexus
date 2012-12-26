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

package flexus.logging
{

import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import flexus.errors.IllegalStateError;

import mx.logging.ILogger;
import mx.logging.LogEventLevel;
import mx.logging.LogLogger;
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
public class LoggerFactory
{

	static private const TARGET:TraceTarget = new TraceTarget;

	static private const facotry:LoggerFactory = new LoggerFactory;

	static private const loggers:Object = {};

	//--------------------------------------------------------------------------
	//
	//  Class methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Retireves the logger object for the specifial <code>clazz</code>.
	 *
	 *  @param clazz
	 *  @return logger
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	static public function getLogger(clazz:Class):ILogger
	{
		var qname:String = getQualifiedClassName(clazz);

		if (!(qname in loggers))
		{
			loggers[qname] = newLogger(qname);
		}
		var dic:Dictionary = loggers[qname] as Dictionary;

		if (dic)
		{
			for (var k:* in dic)
			{
				return k as ILogger;
			}
		}
		else
		{
			delete loggers[qname];
		}
		return getLogger(clazz);
	}

	static protected function newLogger(qname:String):Dictionary
	{
		var dic:Dictionary = new Dictionary;
		var logger:ILogger = new LogLogger(qname);
		TARGET.addLogger(logger);
		dic[logger] = true;
		return dic;
	}

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
	public function LoggerFactory()
	{
		if (facotry)
			throw new IllegalStateError("LoggerFactory is static class!");

		if (TARGET)
		{
			TARGET.includeCategory = true;
			TARGET.includeDate = true;
			TARGET.includeLevel = true;
			TARGET.includeTime = true;
			TARGET.level = LogEventLevel.ALL;
		}

	}
}
}
