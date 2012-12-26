package flexus.inject.impl
{

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

import flexus.inject.*;

[ExcludeClass]
/**
 * A internal implementation for <code>IBinder</code>.
 *
 * @author keyhom.c
 */
internal class BindingBuilder implements IScopeBuilder, ILinkedBuilder
{

	/**
	 * @private
	 */
	private var _impl:BindingImpl;

	private var map:Dictionary;

	/**
	 * Constructor.
	 */
	public function BindingBuilder(binder:IBinder, map:Dictionary, clazz:Class)
	{
		super();
		_impl = new BindingImpl(new SimpleKey(clazz));
		this.map = map;
		binder.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
	}

	private function setBinding(impl:BindingImpl):void
	{
		this._impl = impl;
	}

	/**
	 * @{inheritDoc}
	 */
	public function withNamed(named:String):ILinkedBuilder
	{
		setBinding(_impl.withNamed(named));
		return this;
	}

	/**
	 * @{inheritDoc}
	 */
	public function toImpl(target:Class):IScopeBuilder
	{
		setBinding(_impl.toProvider(new InternalProvider(target)));
		return this;
	}

	/**
	 * @{inheritDoc}
	 */
	public function toProvider(provider:IProvider):IScopeBuilder
	{
		setBinding(_impl.toProvider(provider));
		return this;
	}

	/**
	 * @{inheritDoc}
	 */
	public function toInstance(instance:Object):void
	{
		setBinding(_impl.toProvider(new InternalProvider(instance)));
	}

	/**
	 * @{inheritDoc}
	 */
	public function inScope(scope:IScope):void
	{
		setBinding(_impl.withScope(scope));
	}

	/**
	 * @private
	 */
	static internal function newBinder(map:Dictionary):IBinder
	{
		if (!BinderImpl.builderClass)
			BinderImpl.builderClass = BindingBuilder;

		return new BinderImpl(map);
	}

	private function onComplete(event:Event):void
	{
		IEventDispatcher(event.currentTarget).removeEventListener(Event.COMPLETE, onComplete);
		// check scope

		if(!_impl.scope)
		{
			_impl.scope = Scopes.NO_SCOPE;
		}

		if(!_impl.provider)
		{
			_impl.provider = new SimpleProvider(_impl.key.forClass);
		}

		map[_impl.key] = _impl;
	}
}
}

import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import flexus.inject.*;
import flexus.inject.impl.*;

/**
 * The binder implementation.
 *
 * @author keyhom.c
 */
class BinderImpl extends EventDispatcher implements IBinder
{

	/**
	 * @private
	 */
	static internal var builderClass:Class;

	internal var map:Dictionary;

	/**
	 * Constructor.
	 *
	 * @param map
	 */
	public function BinderImpl(map:Dictionary):void
	{
		super();
		this.map = map;
	}

	/**
	 * @{inheritDoc}
	 */
	public function bind(clazz:Class):ILinkedBuilder
	{
		if (!clazz)
			throw new ArgumentError("Invalid binding class!");

		if (!(clazz in map))
		{
			map[clazz] = new Dictionary(true);
		}

		return new builderClass(this, map[clazz], clazz);
	}

	/**
	 * @{inheritDoc}
	 */
	public function bindScope(scopeType:Class, scopeInstance:IScope):void
	{
	}

	/**
	 * @{inheritDoc}
	 */
	public function bindListener(clazz:Class, listener:Function):void
	{
	}

}

/**
 * @internal
 *
 * @author keyhom.c
 */
class InternalProvider implements IProvider
{

	private var _p:IProvider;

	/**
	 * Constructor.
	 *
	 * @param impl
	 */
	public function InternalProvider(impl:*)
	{
		super();

		if (impl is Class)
			_p = new SimpleProvider(impl as Class);
		else
			_p = new InstanceProvider(impl as Object);
	}

	/**
	 * @{inheritDoc}
	 */
	public function getInstance():*
	{
		return _p.getInstance();
	}
}
