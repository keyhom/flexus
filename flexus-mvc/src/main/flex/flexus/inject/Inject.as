package flexus.inject
{

import flexus.metadata.Metadata;

[ExcludeClass]
/**
 * @author keyhom.c
 */
public class Inject extends Metadata
{

	public function Inject()
	{
		super();
	}

	override protected function get defaultKey():String
	{
		return "value";
	}

	public function get optional():Boolean
	{
		if('optional' in properties)
			return Boolean(properties['optional']);
		return false;
	}

	public function get named():String
	{
		if('named' in properties)
			return String(properties['named']);
		return null;
	}
}
}

