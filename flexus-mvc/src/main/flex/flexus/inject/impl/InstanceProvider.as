package flexus.inject.impl
{

import flash.utils.Dictionary;

import flexus.inject.*;

/**
 * @author keyhom.c
 */
public class InstanceProvider implements IProvider
{

	/**
	 * @private
	 */
	private const context:Dictionary = new Dictionary(true);

	/**
	 * Constructor.
	 *
	 * @param instance
	 */
	public function InstanceProvider(instance:Object)
	{
		super();
		context[instance] = true;
	}

	/**
	 * @{inheritDoc}
	 */
	public function getInstance():*
	{
		for(var k:* in context)
		{
			return k;
		}
	}
}
}
