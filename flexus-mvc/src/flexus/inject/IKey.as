package flexus.inject
{

/**
 * @author keyhom.c
 */
public interface IKey
{
	/**
	 * Retrieves the binding class.
	 */
	function get forClass():Class;

	/**
	 * Retrieves the binding named.
	 */
	function get forNamed():String;

	/**
	 * To compare the other key.
	 */
	function equals(key:IKey):Boolean;

}
}
