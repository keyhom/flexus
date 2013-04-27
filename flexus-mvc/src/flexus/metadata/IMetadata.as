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
 * Metadata entry
 *
 * @author keyhom.c
 */
public interface IMetadata
{
	//----------------------------------
	// element 
	//----------------------------------

	/**
	 * Returns the metadata binding element.
	 *
	 * @return
	 */
	function get element():IMetaElement;
	//----------------------------------
	// keys 
	//----------------------------------

	/**
	 * Returns the key collection.
	 *
	 * @return key collection
	 */
	function get keys():Vector.<String>;
	//----------------------------------
	// metaName 
	//----------------------------------

	/**
	 * Returns the metadata tag name.
	 *
	 * @return tag name.
	 */
	function get metaName():String;
	//----------------------------------
	// name 
	//----------------------------------

	/**
	 * Returns the default key as name.
	 *
	 * @return name
	 */
	function get name():String;
	//----------------------------------
	// properties 
	//----------------------------------

	/**
	 * Returns the properties key=>value.
	 *
	 * @return key/value pairs.
	 */
	function get properties():Object;
	//----------------------------------
	// value 
	//----------------------------------

	/**
	 * Returns the default value.
	 *
	 * @return default value.
	 */
	function get value():String;
	//----------------------------------
	// values 
	//----------------------------------

	/**
	 * Returns the value collection.
	 *
	 * @return value collection.
	 */
	function get values():Array;
}
}
