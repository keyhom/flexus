package flexus.inject.impl
{

import flexus.inject.*;

/**
 * The implementation for binding's value object, just storage the bindings elements.
 *
 * @author keyhom.c
 */
internal class BindingImpl
{

	public var key:IKey;
	public var provider:IProvider;
	public var scope:IScope;

	/**
	 * Constructor.
	 *
	 * @param key
	 * @param provider
	 * @param scope
	 */
	public function BindingImpl(key:IKey, provider:IProvider = null, scope:IScope = null)
	{
		super();
		construct(key, provider, scope);
	}

	public function construct(key:IKey, provider:IProvider = null, scope:IScope = null):void
	{
		this.key = key;
		this.provider = provider;
		this.scope = scope;
	}

	public function withNamed(named:String):BindingImpl
	{
		var k:IKey = new SimpleKey(key.forClass, named);
		return new BindingImpl(k, provider, scope);
	}

	public function toProvider(provider:IProvider):BindingImpl
	{
		return new BindingImpl(key, provider, scope);
	}

	public function withScope(scope:IScope):BindingImpl
	{
		return new BindingImpl(key, provider, scope);
	}
}
}
