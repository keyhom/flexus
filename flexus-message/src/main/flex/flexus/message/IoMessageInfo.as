package flexus.message
{

import flash.events.IEventDispatcher;

/**
 *  The event fired when the remote message was resolved by the client
 *  adapter. In the event handling, also make sure to close the session
 *  if short connecting it is, but long connecting should be validating
 *  only.
 */
[Event(name = "resolved", type = "flexus.message.IoMessageEvent")]

/**
 *  The event fired when the remote message was received and just
 *  ready to handle the message logic.
 */
[Event(name = "ready", type = "flexus.message.IoMessageEvent")]

/**
 *  The event fired when the remote message was received and just
 *  staring to decode the data.
 */
[Event(name = "messageReceived", type = "flexus.message.IoMessageEvent")]

/**
 *  The event fired when the local message was sent and need to
 *  encode the data.
 */
[Event(name = "messageSent", type = "flexus.message.IoMessageEvent")]

/**
 *
 *  @author keyhom.c
 */
public interface IoMessageInfo extends IEventDispatcher
{
	/**
	 *  Retrieves the contract object which binding with the 
	 *  information interface.
	 */
	function get contract():*;

	/**
	 *  Retrieves the derive type of the IoMessage.
	 */
	function get deriveType():Class;

	/**
	 *  Retrieves the instance object of the IoMessage.
	 */
	function get message():IoMessage;

}
}
