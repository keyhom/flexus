package flexus.inject.impl
{

import flexus.inject.*;

/**
 * @author keyhom.c
 */
public class SimpleKey implements IKey
{
	//--------------------------------------------------------------------------
	//
	// Properties
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	// forClass
	//----------------------------------

	/**
	 * @private
	 * Storage for the forClass property.
	 */
	private var _forClass:Class;

	/**
	 * @{inheritDoc}
	 */
	public function get forClass():Class
	{
		return _forClass;
	}

	//----------------------------------
	// forNamed
	//----------------------------------

	/**
	 * @private
	 * Storage for the forNamed property.
	 */
	private var _forNamed:String;

	/**
	 * @{inheritDoc}
	 */
	public function get forNamed():String
	{
		return _forNamed;
	}

	/**
	 * Constructor.
	 */
	public function SimpleKey(forClass:Class, forNamed:String = null)
	{
		super();
		if(!forClass)
			throw new ArgumentError("Invalid \"forClass\" to construct SimpleKey!");

		this._forClass = forClass;
		this._forNamed = forNamed;
	}

	//--------------------------------------------------------------------------
	//
	// Methods
	//
	//--------------------------------------------------------------------------

	/**
	 * @{inheritDoc}
	 */
	public function equals(key:IKey):Boolean
	{
		if(!key)
			return false;
		if(key == this)
			return true;

		if(key.forClass == this.forClass && key.forNamed == this.forNamed)
			return true;

		return false;
	}

}
}
