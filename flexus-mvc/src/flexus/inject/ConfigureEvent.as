package flexus.inject
{

import flash.events.Event;

[ExcludeClass]
/**
 * @author keyhom.c
 */
public dynamic class ConfigureEvent extends Event
{
	/**
	 * Constructor.
	 *
	 * @param type
	 */
	public function ConfigureEvent(type:String)
	{
		super(type, false, false);
	}
}
}
