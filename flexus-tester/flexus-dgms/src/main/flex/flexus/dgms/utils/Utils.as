package flexus.dgms.utils
{
	import mx.core.FlexGlobals;

	/**
	 * @author keyhom.c
	 */
	public class Utils
	{

		/**
		 * Constructor.
		 */
		public function Utils()
		{
			super();
		}

		static public function getCurrentURLEntries():Object
		{
			var entries:Object = {};
			var url:String = FlexGlobals.topLevelApplication.url;
			trace("The url is: ", url);
			var regex:RegExp = /^http:\/\/([\w.]+)(?:\:(\d{2,5}))?\/(?:(.*)\?)?(.*)/i;
			if(regex.test(url))
			{
				var result:Array = regex.exec(url);
				if(result && result.length > 1)
				{
					entries['host'] = result[1];
					entries['port'] = result[2] ? parseInt(result[2]) : 80;
					entries['page'] = result[3];
					entries['parameters'] = result[4];
					trace("perfect match all...", entries['host']);
				}
			}
			return entries;
		}
	}
}
