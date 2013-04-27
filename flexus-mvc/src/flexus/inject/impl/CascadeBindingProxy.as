package flexus.inject.impl
{

import flexus.inject.IBindingProxy;
import flexus.inject.IInjector;
import flexus.inject.IKey;

[ExcludeClass]
/**
 * @author keyhom.c
 */
internal class CascadeBindingProxy implements IBindingProxy
{

	/**
	 * @private
	 */
	private var parent:IBindingProxy;

	/**
	 * @private
	 */
	private var injector:IInjector;

	/**
	 * Constructor.
	 *
	 * @param parent
	 */
	public function CascadeBindingProxy(injector:IInjector, parent:IBindingProxy)
	{
		super();
		this.injector = injector;
		this.parent = parent;
	}

	/**
	 * @{inheritDoc}
	 */
	public function lookup(key:IKey):Array
	{
		var arr:Array;
		if(parent)
		{
			arr = parent.lookup(key);
		}

		if(!arr)
		{
			arr = [];
			var impl:BindingImpl = BindingMgr.getInstance().getBinding(injector, key);
			if(impl)
			{
				arr.push(impl.provider);
				arr.push(impl.scope);
			}
		}

		return arr;
	}
}
}

