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
@SuppressWarnings("serial")
public class StartMenusServlet extends HttpServlet
{

	private static final String charsetName = "UTF-8";

	/**
	 * {@inheritDoc}
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		doProcess(request, response);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
			IOException
	{
		doProcess(request, response);
	}

	/**
	 * @param request
	 * @param response
	 */
	private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException,
			IOException
	{
		request.setCharacterEncoding(charsetName);
		response.setCharacterEncoding(charsetName);

		InputStream stream = Thread.currentThread().getContextClassLoader().getResourceAsStream("startMenus.xml");
		byte[] bytes = null;
		if (stream != null && stream.available() > 0)
		{
			bytes = IOUtils.toByteArray(stream);
		}
		
		response.setContentType("text/xml");

		if (bytes != null)
		{
			response.getOutputStream().write(bytes);
			response.getOutputStream().flush();
		}
	}

}
