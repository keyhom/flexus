package flexus.inject
{


/**
 * @author keyhom.c
 */
public interface ILinkedBuilder extends IScopeBuilder
{
	/**
	 * With named annotation.
	 */
	function withNamed(named:String):ILinkedBuilder;

	/**
	 * Binds to the specifical provider.
	 */
	function toProvider(provider:IProvider):IScopeBuilder;

	/**
	 * Binds to the specifical instance, also be singleton bindings.
	 */
	function toInstance(instance:Object):void;

	/**
	 * Binds to the specifical target.
	 */
	function toImpl(target:Class):IScopeBuilder;

}
}
