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
package flexus.web.aplist;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.net.SocketAddress;

/**
 * @author pureart.org
 * 
 */
@XmlRootElement(name = "ap")
@XmlAccessorType(XmlAccessType.FIELD)
public class AccessPoint implements Serializable
{

	private static final long serialVersionUID = 1L;

	private int id;
	private String name;
	private SocketAddress address;
	private String comment;

	/**
	 * @return the id
	 */
	public int getId()
	{
		return id;
	}

	/**
	 * @return the name
	 */
	public String getName()
	{
		return name;
	}

	/**
	 * @return the address
	 */
	public SocketAddress getAddress()
	{
		return address;
	}

	/**
	 * @return the comment
	 */
	public String getComment()
	{
		return comment;
	}

}
