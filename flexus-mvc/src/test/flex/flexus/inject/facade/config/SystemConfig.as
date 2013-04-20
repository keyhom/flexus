package flexus.inject.facade.config
{
import flexus.inject.*;
import flexus.inject.entities.*;
import flexus.inject.model.*;

public class SystemConfig extends AbstractConfiguration
	{

		override protected function configure():void
		{
			// configure the current facade.
			binder.bind(IUser).toImpl(UserProxy).inScope(Scopes.SINGLETON);
			binder.bind(UserInfo).inScope(Scopes.SINGLETON);
			binder.bind(UserInfo).withNamed("forTest").inScope(Scopes.NO_SCOPE);
		}
	}
}
