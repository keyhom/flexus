package flexus.mvc.interfaces
{

	/**
	 * The interface definition for MVC command.
	 *
	 * @see flexus.mvn.interfaces.INotification
	 */
	public interface ICommand
	{
		/**
		 * Excute the <code>ICommand</code>'s logic to handle the specifical
		 * <code>INotification</code>.
		 *
		 * @param notification note an <code>INotification</code> to handle.
		 */
		function execute(notification:INotification):void;
	}
}
