package flexus.inject
{

import flash.events.EventDispatcher;

/**
 * @author keyhom.c
 */
public class AbstractConfiguration extends EventDispatcher implements IConfiguration
{

	/**
	 * @private
	 */
	protected var binder:IBinder;

	/**
	 * Constructor.
	 */
	public function AbstractConfiguration() 
	{
		super();
		this.addEventListener("configure", onConfigure);
	}

	private function onConfigure(event:ConfigureEvent):void
	{
		this.removeEventListener("configure", onConfigure);

		const value:IBinder = event.value as IBinder;

		if(value)
		{
			this.binder = value;
		}

		event.preventDefault();
		
		configure();
	}

	protected function configure():void
	{
		// wait for implementation.
		throw new Error("Invalid configuration!");
	}

}
}
