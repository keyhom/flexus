package flexus.mvc.interfaces
{

	/**
	 * The interface definition for MVC notification.
	 *
	 * @author keyhom.c
	 */
	public interface INotification
	{

		function get name():String;

		function get type():String;

		function get object():Object;
	}
}
