package flexus.message
{

import mx.logging.ILogger;
import flexus.logging.LoggerFactory;
import flash.events.EventDispatcher;
import flexus.core.xwork.service.IoConnector;

/**
 *  @author keyhom.c 
 */
public class IoMessageService extends EventDispatcher
{

	//--------------------------------------------------------------------------
	//
	//  Class Variables 
	//
	//--------------------------------------------------------------------------

	static private const LOGGER:ILogger = LoggerFactory.getLogger(IoMessageService);

	//--------------------------------------------------------------------------
	//
	//  Constructor 
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor. 
	 */
	public function IoMessageService()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties 
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  connector
	//----------------------------------

	/**
	 *  @private
	 */
	private var _connector:IoConnector;

	/**
	 *  Retrieves the connector of the service.
	 *
	 *  @return connector
	 */
	public function connector():IoConnector
	{
		return _connector;
	}

}
}
