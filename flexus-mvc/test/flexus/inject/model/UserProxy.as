package flexus.inject.model
{

import flash.events.EventDispatcher;

import flexus.inject.entities.UserInfo;

public class UserProxy extends EventDispatcher implements IUser
{
	static private var idGen:int = 0;

	public const hashCode:int = ++idGen;

	/**
	 * Constructor.
	 */
	public function UserProxy()
	{
		super();
	}

	private var _user:UserInfo;

	[Inject]
	public function get userInfo():UserInfo
	{
		return _user;
	}

	public function set userInfo(value:UserInfo):void
	{
		this._user = value;
	}

	public function login(userName:String, passWord:String):Object
	{
		return null;
	}

	public function logout():Boolean
	{
		return false;
	}

	public function isValidRight(... params:Array):Boolean
	{
		return false;
	}

	public function updatePassword(old:String, newPass:String):Object
	{
		return null;
	}

	override public function toString():String
	{
		return "IUser => UserProxy#" + hashCode + " [ " + userInfo + " ]";
	}
}
}
