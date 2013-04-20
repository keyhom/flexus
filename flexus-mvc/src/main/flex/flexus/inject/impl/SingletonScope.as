package flexus.inject.impl
{

import flash.utils.Dictionary;

import flexus.inject.*;

/**
 * @author keyhom.c
 */
public class SingletonScope implements IScope
{
	/**
	 * @private
	 */
	static private const singletons:Dictionary = new Dictionary(true);
	
	/**
	 * Constructor.
	 */
	public function SingletonScope()
	{
		super();
	}

	/**
	 * @{inheritDoc}
	 */
	public function runScope(key:IKey, unScope:IProvider):IProvider
	{
		if(!(key.forClass in singletons))
		{
			singletons[key.forClass] = new Dictionary(false);
		}

		var d:Dictionary = singletons[key.forClass] as Dictionary;

		var singletonProvider:IProvider = lookup(d, key);

		if(!singletonProvider)
		{
			singletonProvider = new InstanceProvider(unScope.getInstance());
			d[key] = singletonProvider;
		}

		return singletonProvider;
	}

	private function lookup(d:Dictionary, key:IKey):IProvider
	{
		if(!d)
			throw new ArgumentError("Lookuping the invalid singeltons scopes!");

		for(var _k:* in d)
		{
			var k:IKey = IKey(_k);
			if(k.equals(key))
			{
				return d[_k] as IProvider;
			}
		}

		return null;
	}
}
}
