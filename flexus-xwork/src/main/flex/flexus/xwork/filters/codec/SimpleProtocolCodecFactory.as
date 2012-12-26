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

package flexus.xwork.filters.codec
{
import flexus.core.xwork.session.IoSession;

/**
 *
 *  @author keyhom.c
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SimpleProtocolCodecFactory implements ProtocolCodecFactory
{

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param encoder
	 *  @param decoder
	 *  @throws ArgumentError
	 *  @throws ArgumentError
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function SimpleProtocolCodecFactory(encoder:ProtocolEncoder, decoder:ProtocolDecoder)
	{
		super();

		if (encoder == null)
			throw new ArgumentError("encoder");

		if (decoder == null)
			throw new ArgumentError("decoder");

		this._decoder = decoder;
		this._encoder = encoder;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// _decoder 
	//----------------------------------

	private var _decoder:ProtocolDecoder;

	//----------------------------------
	// _encoder 
	//----------------------------------

	private var _encoder:ProtocolEncoder;

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 *
	 *  @param session
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getDecoder(session:IoSession):ProtocolDecoder
	{
		return _decoder;
	}

	/**
	 *
	 *  @param session
	 *  @return
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getEncoder(session:IoSession):ProtocolEncoder
	{
		return _encoder;
	}
}
}
