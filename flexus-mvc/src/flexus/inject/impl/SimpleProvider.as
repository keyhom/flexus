package flexus.inject.impl
{

import flexus.inject.*;

/**
 * A simple implementation for the <code>Provider</code>.
 *
 * @author keyhom.c
 */
public class SimpleProvider implements IProvider
{

	/**
	 * @private
	 * Just storage for the impl property.
	 */
	private var impl:Class;


	/**
	 * Constructor.
	 */
	public function SimpleProvider(impl:Class)
	{
		super();
		if(!impl)
			throw new ArgumentError("Invalid impl for provider!");
		this.impl = impl;
	}

	/**
	 * @{inheritDoc}
	 */
	public function getInstance():*
	{
		var obj:Object = new impl;

		// TODO: inject the new instance object here.
		return obj;
	}
}
}
