/*
 * Copyright (c) 2013 keyhom.c@gmail.com.
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from
 * the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose
 * excluding commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 *     1. The origin of this software must not be misrepresented; you must not
 *     claim that you wrote the original software. If you use this software
 *     in a product, an acknowledgment in the product documentation would be
 *     appreciated but is not required.
 *
 *     2. Altered source versions must be plainly marked as such, and must not
 *     be misrepresented as being the original software.
 *
 *     3. This notice may not be removed or altered from any source
 *     distribution.
 */

package flexus.net {

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
public interface IURIResolver {
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
