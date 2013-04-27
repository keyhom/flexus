package flexus.inject
{

import flash.net.registerClassAlias;
import flash.utils.Dictionary;

import flexus.inject.impl.InternalInjectionCreator;

/**
 * A global static class for injection framework.
 *
 * @author keyhom.c
 */
public class InjectionGlobals
{

	// To run the global configuration first.

	globalInitailization();

	/**
	 * @private
	 */
	static private function globalInitailization():void
	{
		// TODO: global class configuration here.
		Scopes.SINGLETON;
		registerClassAlias("Inject", Inject);
	}

	/**
	 * Constructor.
	 *
	 */
	public function InjectionGlobals()
	{
		throw new Error("InjectionGlobals is a static class!");
	}

	/**
	 * @private
	 * Storage for the global root injector instance.
	 */
	static private var _rootInjector:IInjector;

	/**
	 * @private
	 */
	static private var _injectors:Dictionary = new Dictionary(true);

	/**
	 * Retrieves the root injector instance, or create a new root injector instance.
	 *
	 * @param configs
	 * @return injector instance.
	 */
	static public function getOrCreateInjector(configs:Vector.<IConfiguration> = null):IInjector
	{
		if(configs && configs.length > 0)
		{
			// means to create a new child injector or the root injector.
			if(!_rootInjector)
			{
				_rootInjector = new InternalInjectionCreator().build(configs);
				return _rootInjector;
			}
			else
			{
				var _injt:IInjector = new InternalInjectionCreator(_rootInjector).build(configs);
				_injectors[_injt] = true;
				return _injt;
			}
		}

		return _rootInjector;
	}

}
}
