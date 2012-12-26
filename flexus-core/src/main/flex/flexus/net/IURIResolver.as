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

package flexus.net
{

/**
 * The URI class cannot know about DNS aliases, virtual hosts, or
 * symbolic links that may be involved.  The application can provide
 * an implementation of this interface to resolve the URI before the
 * URI class makes any comparisons.  For example, a web host has
 * two aliases:
 *
 * <p><code>
 *    http://www.site.com/
 *    http://www.site.net/
 * </code></p>
 *
 * <p>The application can provide an implementation that automatically
 * resolves site.net to site.com before URI compares two URI objects.
 * Only the application can know and understand the context in which
 * the URI's are being used.</p>
 *
 * <p>Use the URI.resolver accessor to assign a custom resolver to
 * the URI class.  Any resolver specified is global to all instances
 * of URI.</p>
 *
 * <p>URI will call this before performing URI comparisons in the
 * URI.getRelation() and URI.getCommonParent() functions.
 *
 * @see URI.getRelation
 * @see URI.getCommonParent
 *
 * @langversion ActionScript 3.0
 * @playerversion Flash 9.0
 */
public interface IURIResolver
{
	/**
	 * Implement this method to provide custom URI resolution for
	 * your application.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 */
	function resolve(uri:URI):URI;
}
}
