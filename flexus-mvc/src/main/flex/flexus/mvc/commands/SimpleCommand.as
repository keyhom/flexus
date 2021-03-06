package flexus.mvc.commands
{

import flexus.mvc.interfaces.INotification;
import flexus.mvc.interfaces.ICommand;

/**
 * A simple interface implementation for <code>ICommand</code>.
 *
 * @author keyhom.c
 */
public class SimpleCommand implements ICommand
{
	/**
	 * Constructor.
	 */
	public function SimpleCommand()
	{
		super();
	}

	public function execute(notification:INotification):void
	{
		// nothing to do...
	}
}
}
