package flexus.inject
{
import flash.events.IEventDispatcher;

/**
 * @author keyhom.c
 */
public interface IBinder extends IEventDispatcher
{
	function bind(clazz:Class):ILinkedBuilder;
	function bindScope(scopeType:Class, scopeInstance:IScope):void;
	function bindListener(clazz:Class, listener:Function):void;
}
}
