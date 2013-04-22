/*
 * Copyright (c) 2013 keyhom.c@gmail.com.
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from
 * the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose
 * excluding commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 *     1. The origin of this software must not be misrepresented; you must not
 *     claim that you wrote the original software. If you use this software
 *     in a product, an acknowledgment in the product documentation would be
 *     appreciated but is not required.
 *
 *     2. Altered source versions must be plainly marked as such, and must not
 *     be misrepresented as being the original software.
 *
 *     3. This notice may not be removed or altered from any source
 *     distribution.
 */

package flexus.inject {

import flash.system.ApplicationDomain;

import flexus.inject.entities.*;
import flexus.inject.facade.config.SystemConfig;
import flexus.inject.model.*;
import flexus.logging.LoggerFactory;

import mx.logging.ILogger;

import org.flexunit.Assert;

/**
 * @version $Revision$
 * @author keyhom
 */
public class InjectorTest {

    static private var LOGGER:ILogger = LoggerFactory.getLogger(InjectorTest);

    [BeforeClass]
    static public function loggerInit():void {
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

    public function InjectorTest() {
        LOGGER.info("For InjectorTest log.");
    }

    [Inject]
    public var user:IUser;
    [Inject]
    public var userInfo:UserInfo;
    [Inject(name="forTest")]
    public var userInfoEvenyNew:UserInfo;
    private var injector:IInjector;

    [Before]
    public function initInjector():void {
        injector = InjectionGlobals.getOrCreateInjector(getConfigurations());
    }

    [Test(order=1, description="Initialization test...")]
    public function createTest():void {
        Assert.assertNotNull("Injector creation!", injector);
    }

    [Test(order=2, description="Common injection test...")]
    public function commonInject():void {
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

    private function getConfigurations():Vector.<IConfiguration> {
        var configs:Vector.<IConfiguration> = new Vector.<IConfiguration>;
        configs.push(new SystemConfig());
        return configs;
    }

}
}
