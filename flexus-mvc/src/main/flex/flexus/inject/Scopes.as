package flexus.inject
{

import flexus.inject.impl.*;

/**
 * @author keyhom.c
 */
public class Scopes
{
	static public const NO_SCOPE:IScope = new DefaultScope();
	static public const SINGLETON:IScope = new SingletonScope();
}
}

