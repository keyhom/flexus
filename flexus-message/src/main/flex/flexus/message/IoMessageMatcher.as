package flexus.message {
import mx.events.Request;

/**
 *  @author keyhom.c
 */
public interface IoMessageMatcher {

    /**
     * Processing the logic to match the information interface with the contract.
     *
     * @param req the specifial request for the client.
     * @param o the specifial container of information interface.
     */
    function match(req:Request, o:Object):IoMessageInfo;
}
}
