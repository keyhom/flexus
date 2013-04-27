package flexus.mvc.interfaces
{
	/**
	 * The event definitation fired when the target was registered to the context.
	 */
	[Event(name="register", type="flexus.mvc.events.ContextEvent")]
	
	/**
	 * The event definitation fired when the target was removed from the context.
	 */
	[Event(name="remove", type="flexus.mvn.events.ContextEvent")]

	/**
	 * The interface definitation for MVC proxy.
	 *
	 * @author keyhom.c
	 */
	public interface IProxy
	{
		function get name():String;

		function get data():Object;

		function set data(value:Object):void;
	}
}
