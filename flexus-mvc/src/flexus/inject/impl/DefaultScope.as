package flexus.inject.impl
{

import flexus.inject.*;

/**
 * @author keyhom.c
 */
public class DefaultScope implements IScope
{

	/**
	 * Constructor.
	 */
	public function DefaultScope()
	{
	}

	/**
	 * @{inheritDoc}
	 */
	public function runScope(key:IKey, unScope:IProvider):IProvider
	{
		return unScope;
	}
}
}
