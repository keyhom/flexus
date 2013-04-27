package flexus.inject.entities
{
	[Bindable]
	public class UserInfo
	{
		static private var idGen:int = 0;

		public var userId:int;
		public var userName:String;
		public var userPass:String;

		public const hashCode:int = ++idGen;

		public function UserInfo()
		{
			super();
		}

		public function toString():String
		{
			return "Entity [ USER#" + hashCode + ": userId=" + userId + ", userName=" + userName + ", userPass=" + userPass + " ].";
		}
	}
}
