/*
 * Copyright (c) 2013 keyhom.c@gmail.com.
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from
 * the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose
 * excluding commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 *     1. The origin of this software must not be misrepresented; you must not
 *     claim that you wrote the original software. If you use this software
 *     in a product, an acknowledgment in the product documentation would be
 *     appreciated but is not required.
 *
 *     2. Altered source versions must be plainly marked as such, and must not
 *     be misrepresented as being the original software.
 *
 *     3. This notice may not be removed or altered from any source
 *     distribution.
 */

package flexus.logging.targets {

import flexus.logging.AbstractTarget;
import flexus.logging.ILogger;
import flexus.logging.LogEvent;

/**
 * All logger target implementations that have a formatted line style output should extends this class.
 * It provides default behavior for including date, time, category, and level within the output.
 *
 * @version $Revision$
 * @author keyhom (keyhom.c@gmail.com)
 */
public class LineFormattedTarget extends AbstractTarget {

    /**
     * Creates a LineFormattedTarget instance.
     */
    public function LineFormattedTarget() {
        super();

        includeTime = false;
        includeDate = false;
        includeCategory = false;
        includeLevel = false;
    }


    [Inspectable(category="General", defaultValue=" ")]

    /**
     * The separator string to use between fields (the default is " ")
     */
    public var fieldSeparator:String = " ";

    [Inspectable(category="General", defaultValue="false")]

    /**
     * Indicates if the category for this target should added to the trace.
     */
    public var includeCategory:Boolean;

    [Inspectable(category="General", defaultValue="false")]

    /**
     * Indicates if the date should be added to the trace.
     */
    public var includeDate:Boolean;

    [Inspectable(category="General", defaultValue="false")]

    /**
     * Indicates if the level for the event should added to the trace.
     */
    public var includeLevel:Boolean;

    [Inspectable(category="General", defaultValue="false")]

    /**
     * Indicates if the time should be added to the trace.
     */
    public var includeTime:Boolean;

    /**
     * @inheritDoc
     */
    override public function logEvent(event:Object):void {
        var date:String = "";
        if (includeDate || includeTime) {
            var d:Date = new Date();
            if (includeDate) {
                date = Number(d.getMonth() + 1).toString() + "/" + d.getDate().toString() + "/" + d.getFullYear() + fieldSeparator;
            }

            if (includeTime) {
                date += padTime(d.getHours()) + ":" +
                        padTime(d.getMinutes()) + ":" +
                        padTime(d.getSeconds()) + ":" +
                        padTime(d.getMilliseconds(), true) + fieldSeparator;
            }
        }

        var level:String = "";
        if (includeLevel) {
            level = "[" + LogEvent.getLevelString(event.level) + "]" + fieldSeparator;
        }

        var category:String = includeCategory ? ILogger(event.target).category + fieldSeparator : "";

        internalLog(date + level + category + event.message);
    }

    /**
     * @private
     */
    private function padTime(num:Number, millis:Boolean = false):String {
        if (millis) {
            if (num < 0) {
                return "00" + num.toString();
            } else if (num < 100) {
                return "0" + num.toString();
            } else {
                return num.toString();
            }
        } else {
            return num > 9 ? num.toString() : "0" + num.toString();
        }
    }

    /**
     * Descendants of this class should override this method to direct the specified message to the desired output.
     *
     * @param message String containing preprocessed log message which may include time, date, category, etc.
     *         based on property settings, such as <code>includeDate</code>, <code>includeCategory</code>, etc.
     */
    protected function internalLog(message:String):void {
        // Override this method to perform the redirection to the desired output.
    }
}
}
// vim:ft=actionscript
