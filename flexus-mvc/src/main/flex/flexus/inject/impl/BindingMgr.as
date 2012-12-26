package flexus.inject.impl
{

import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

import flexus.inject.*;

[ExcludeClass]
/**
 * The injectorBindings facade implemetation.
 *
 * @author keyhom.c
 */
internal class BindingMgr
{
	/**
	 * @singleton
	 */
	static private var instance:BindingMgr;

	/**
	 * Retrieves the singleton instance of <code>BindingMgr</code>.
	 *
	 * @return injectorBindings facade implemetation instance.
	 */
	static public function getInstance():BindingMgr
	{
		if(!instance)
			instance = new BindingMgr;
		return instance;
	}

	/**
	 * @private
	 */
	private const injectorBindings:Dictionary = new Dictionary(false);

	/**
	 * Constructor.
	 */
	public function BindingMgr()
	{
		super();
		if(instance)
			throw new IllegalOperationError("The BindingMgr is singleton!");

		instance = this;
	}

	/**
	 * Retrieves the target binding object.
	 *
	 * @param key
	 * @return binding implemetation object
	 */
	public function getBinding(injector:IInjector, key:IKey):BindingImpl
	{
		var impl:BindingImpl = null;
		if(injector in injectorBindings)
		{
			const binds:Dictionary = Dictionary(injectorBindings[injector]);
			const forClass:Class = key.forClass;

			if(forClass in binds)
			{
				const keys:Dictionary = Dictionary(binds[forClass]);
				for(var _k:* in keys)
				{
					var _key:IKey = IKey(_k);
					if(_key.equals(key))
					{
						impl = keys[_k] as BindingImpl;
						break;
					}
				}
			}
		}

		return impl;
	}

	/**
	 * Registered the binding implemetation object to the specifical <code>injector</code>.
	 *
	 * @param injector
	 * @param impl
	 */
	public function registerBinding(injector:IInjector, impl:BindingImpl):void
	{
		if(!injector)
			throw new ArgumentError("Invalid injector!");
		if(!impl)
			throw new ArgumentError("Invalid binding implemetation!");

		if(!(injector in injectorBindings))
		{
			injectorBindings[injector] = new Dictionary(true);
		}

		var _d:Dictionary = Dictionary(injectorBindings[injector]);

		const key:IKey = impl.key;
		const forClass:Class = key.forClass;

		if(!(forClass in _d))
		{
			_d[forClass] = new Dictionary(true);
		}

		var _n:Dictionary = Dictionary(_d[forClass]);

		checkUnqiue(_n, key);
		_n[key] = impl;
	}

	private function checkUnqiue(dic:Dictionary, key:IKey):void
	{
		var exists:Boolean = false;
		if(key in dic)
			exists = true;
		else
		{
			for(var _k:* in dic)
			{
				var _key:IKey = IKey(_k);
				if(_key.equals(key))
				{
					exists = true;
					break;
				}
			}
		}

		if(exists)
			throw new IllegalOperationError("There's exists binding for " + key);
	}

	public function newBinder(injt:InjectorImpl):IBinder
	{
		if(!(injt in injectorBindings))
		{
			injectorBindings[injt] = new Dictionary(true);
		}
		
		return BindingBuilder.newBinder(injectorBindings[injt] as Dictionary);
	}
}
}
