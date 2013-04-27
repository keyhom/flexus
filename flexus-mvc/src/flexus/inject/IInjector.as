package flexus.inject
{
import flash.system.ApplicationDomain;

/**
 * Injector for binding references.
 * 
 * @author keyhom.c
 */
public interface IInjector
{

	/**
	 * Injects the specifial <code>instance</code> with the configured bindings.
	 *
	 * @param instance the specifial instance.
	 */
	function injectInstance(instance:Object, domain:ApplicationDomain = null):void;

}
}
