package flexus.inject.impl
{

import flash.errors.IllegalOperationError;
import flash.events.Event;

import flexus.inject.*;

[ExcludeClass]
/**
 * @author keyhom.c
 */
public class InternalInjectionCreator
{
	/**
	 * @private
	 */
	private var _parentInjector:IInjector;

	/**
	 * Constructor.
	 *
	 * @param parentInjector
	 */
	public function InternalInjectionCreator(parentInjector:IInjector = null)
	{
		super();
		this._parentInjector = parentInjector;
	}

	/**
	 * @private
	 */
	public function build(configs:Vector.<IConfiguration>):IInjector
	{
		if(!configs)
			throw new ArgumentError("Invalid IConfiguration vector!");

		var injt:InjectorImpl = new InjectorImpl(getBindingProxy(_parentInjector as InjectorImpl));
		var binder:IBinder = BindingMgr.getInstance().newBinder(injt);
		for(var i:int = 0, l:int = configs.length; i < l; i++)
		{
			var config:IConfiguration = IConfiguration(configs[i]);

			if(!config)
				throw new IllegalOperationError("Invalid IConfiguration object!");

			var e:ConfigureEvent = new ConfigureEvent("configure");
			e.value = binder;
			config.dispatchEvent(e);
		}

		binder.dispatchEvent(new Event(Event.COMPLETE));
		
		return injt;
	}

	private function getBindingProxy(injt:InjectorImpl):IBindingProxy
	{
		if(injt)
		{
			return injt.proxy;
		}
		return null;
	}

}
}
