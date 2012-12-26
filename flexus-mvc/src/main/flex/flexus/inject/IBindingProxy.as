package flexus.inject
{
/**
 * A proxy declaration for <code>Binding</code>.
 *
 * @author keyhom.c
 */
public interface IBindingProxy
{
	/**
	 * Lookups the configured binding of the specifical <code>key</code>.
	 *
	 * @return a array contains the provider and the scope.
	 */
	function lookup(key:IKey):Array;
}
}
