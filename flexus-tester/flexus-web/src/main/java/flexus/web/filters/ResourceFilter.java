/* 
 *  PureArt Archetype. Make any work easier.
 *
 *  Copyright (C) 2011  pureart.org
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package flexus.web.filters;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author pureart.org
 * 
 */
public class ResourceFilter implements Filter
{

	/**
	 * LOGGER
	 */
	private static final Logger LOGGER = LoggerFactory.getLogger(ResourceFilter.class);

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void destroy()
	{
		if (LOGGER.isDebugEnabled())
			LOGGER.debug("Destory the resource filter ...");
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException,
			ServletException
	{
		boolean valid = true;

		if (valid)
			chain.doFilter(request, response);
		else
		{
			HttpServletResponse res = (HttpServletResponse)response;
			res.setStatus(403);
			response.getWriter().flush();
		}
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void init(FilterConfig config) throws ServletException
	{
		if (LOGGER.isDebugEnabled())
			LOGGER.debug("Initialize the resource filter ... {}", config);
	}

}
