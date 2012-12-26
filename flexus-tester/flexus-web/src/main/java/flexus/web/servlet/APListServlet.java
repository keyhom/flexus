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
package flexus.web.servlet;

import java.io.IOException;
import java.io.InputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;

/**
 * @author pureart.org
 * 
 */
public class APListServlet extends HttpServlet
{

	private static final long serialVersionUID = 1L;

	/**
	 * {@inheritDoc}
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
			IOException
	{
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/xml");
		response.setCharacterEncoding("utf-8");

		InputStream stream = Thread.currentThread().getContextClassLoader().getResourceAsStream("aps.xml");

		if (stream != null)
		{
			try
			{
				String apDoc = IOUtils.toString(stream, "UTF-8");
				if (apDoc != null && apDoc.trim().length() > 0)
				{
					response.getWriter().write(apDoc);
				}
			}
			finally
			{
				response.getWriter().flush();
				IOUtils.closeQuietly(stream);
			}
		}
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		doPost(request, response);
	}
}
