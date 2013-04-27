package flexus.inject.model
{

import flash.events.IEventDispatcher;

import flexus.inject.entities.UserInfo;

public interface IUser extends IEventDispatcher
{

	function login(userName:String, passWord:String):Object;

	function logout():Boolean;

	function isValidRight(... params:Array):Boolean;

	function get userInfo():UserInfo;

	function updatePassword(old:String, newPass:String):Object;

}
}
