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

package flexus.message.codec
{

import flexus.core.xwork.service.IoHandler;
import flexus.core.xwork.service.IoServiceEvent;
import flexus.core.xwork.session.IoSession;
import flexus.logging.LoggerFactory;
import flexus.xwork.filters.codec.ProtocolCodecFactory;
import flexus.xwork.filters.codec.ProtocolDecoder;
import flexus.xwork.filters.codec.ProtocolEncoder;

import mx.logging.ILogger;
import flash.utils.Endian;

/**
 *
 * @author keyhom.c
 */
public class McProtocolCodecFactory extends IoHandler implements ProtocolCodecFactory
{

	static private const LOGGER:ILogger = LoggerFactory.getLogger(McProtocolCodecFactory);

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 */
	public function McProtocolCodecFactory()
	{
		super();
		this._decoder = new McProtocolCodecDecoder;
		this._encoder = new McProtocolCodecEncoder;
	}

	//--------------------------------------------------------------------------
	//
	//  Variables.
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  decoder.
	 */
	private var _decoder:ProtocolDecoder;

	/**
	 *  @private
	 *  encoder.
	 */
	private var _encoder:ProtocolEncoder;

	private var _endian:String = Endian.BIG_ENDIAN;

	public function get order():String
	{
		return this._endian;
	}

	public function set order(value:String):void
	{
		this._endian = value;
	}

	//--------------------------------------------------------------------------
	//
	//  Methods 
	//
	//--------------------------------------------------------------------------

	/**
	 * Retrieves the deocder.
	 *
	 * @param session
	 */
	public function getDecoder(session:IoSession):ProtocolDecoder
	{
		session.setAttribute(Endian, order);
		return _decoder;
	}

	/**
	 * Retrieves the encoder.
	 *
	 * @param session
	 */
	public function getEncoder(session:IoSession):ProtocolEncoder
	{
		session.setAttribute(Endian, order);
		return _encoder;
	}

}
}
