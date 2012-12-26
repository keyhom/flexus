package flexus.dgms.dataCenter.view
{

import flexus.inject.AbstractConfiguration;

public class TestConfiguration extends AbstractConfiguration
{
	public function TestConfiguration()
	{
		super();
	}

	override protected function configure():void
	{
		binder.bind(IFoo).toImpl(FooImpl);
	}
}
}
import flexus.dgms.dataCenter.view.IFoo;
import mx.logging.ILogger;
import flexus.logging.LoggerFactory;

class FooImpl implements IFoo
{
	static private const LOGGER:ILogger = LoggerFactory.getLogger(FooImpl);

	public function execute():void
	{
		LOGGER.info("YES, i'm the foo implementation!");
	}
}

