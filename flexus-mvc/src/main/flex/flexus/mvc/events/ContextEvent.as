package flexus.mvc.events
{
	import flash.events.Event;

	/**
	 * @author keyhom.c
	 */
	public class ContextEvent extends Event
	{

		/**
		 * Constructor.
		 *
		 * @param type
		 */
		public function ContextEvent(type:String)
		{
			super(type, false, false);
		}
	}
}

