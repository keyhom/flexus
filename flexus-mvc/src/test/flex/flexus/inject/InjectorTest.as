package flexus.inject
{

import flash.system.ApplicationDomain;

import flexus.inject.entities.*;
import flexus.inject.facade.config.SystemConfig;
import flexus.inject.model.*;
import flexus.logging.LoggerFactory;

import mx.logging.ILogger;

import org.flexunit.Assert;

public class InjectorTest
{
	static private var LOGGER:ILogger = LoggerFactory.getLogger(InjectorTest);

	[BeforeClass]
	static public function loggerInit():void
	{
//		const TARGET:TraceTarget = new TraceTarget;
//		TARGET.includeCategory = true;
//		TARGET.includeDate = true;
//		TARGET.includeLevel = true;
//		TARGET.includeTime = true;
//		TARGET.level = LogEventLevel.ALL;
//
//		LOGGER = new LogLogger(getQualifiedClassName(InjectorTest));
//
//		TARGET.addLogger(LOGGER);
	}

	private var injector:IInjector;

	public function InjectorTest()
	{
		LOGGER.info("For InjectorTest log.");
	}

	private function getConfigurations():Vector.<IConfiguration>
	{
		var configs:Vector.<IConfiguration> = new Vector.<IConfiguration>;
		configs.push(new SystemConfig());
		return configs;
	}

	[Before]
	public function initInjector():void
	{
		injector = InjectionGlobals.getOrCreateInjector(getConfigurations());
	}

	[Test(order=1, description="Initialization test...")]
	public function createTest():void
	{
		Assert.assertNotNull("Injector creation!", injector);
	}

	[Inject]
	public var user:IUser;
	[Inject]
	public var userInfo:UserInfo;
	[Inject(named="forTest")]
	public var userInfoEvenyNew:UserInfo;

	[Test(order=2, description="Common injection test...")]
	public function commonInject():void
	{
		injector.injectInstance(this, ApplicationDomain.currentDomain);

		LOGGER.info("After first common injection...");
		LOGGER.info("The IUser -> {0}", user);
		LOGGER.info("The ST UserInfo -> {0}", userInfo);
		LOGGER.info("The EN UserInfo -> {0}", userInfoEvenyNew);

		// first must run null checks.
		Assert.assertNotNull("User", user);
		Assert.assertNotNull("Singleton UserInfo", userInfo);
		Assert.assertNotNull("ForTest UserInfo", userInfoEvenyNew);

		// if all instanced.
		Assert.assertTrue("HashCode to Equals", userInfo.hashCode != userInfoEvenyNew.hashCode);

		// storage the hashCode now, will use to match after next injection.
		const singletonUserInfoHashCode:int = userInfo.hashCode;
		var oldUserInfoHashCode:int = userInfoEvenyNew.hashCode;

		// run next injection, for reinject the instances.
		injector.injectInstance(this, ApplicationDomain.currentDomain);

		LOGGER.info("After second common injection...");
		LOGGER.info("The IUser -> {0}", user);
		LOGGER.info("The ST UserInfo -> {0}", userInfo);
		LOGGER.info("The EN UserInfo -> {0}", userInfoEvenyNew);

		Assert.assertTrue("Singleton UserInfo hashCode", singletonUserInfoHashCode == userInfo.hashCode);
		Assert.assertTrue("ForTest UserInfo hashCode", oldUserInfoHashCode != userInfoEvenyNew.hashCode);
	}

}
}
