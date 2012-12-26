package flexus.mvc.interfaces
{
	/**
	 * The interface definitation for MVC <code>IMediator</code>.
	 *
	 * @author keyhom.c
	 */
	public interface IMediator
	{

		function get name():String;

		function get viewComponent():Object;

		function set viewComponent(value:Object):void;

		function hanleNotification(notification:INotification):void;

	}
}
