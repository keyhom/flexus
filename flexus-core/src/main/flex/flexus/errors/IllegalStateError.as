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

package flexus.errors {

/**
 * This class represents an Error that is thrown when a method is called when
 * the receiving instance is in an invalid state.
 *
 * For example, this may occur if a method has been called, and other properties
 * in the instance have not been initialized properly.
 *
 * @author keyhom
 */
public dynamic class IllegalStateError extends Error {

    /**
     * Creates an IllegalStateError error instance.
     *
     * @param message A message describing the error in detail.
     * @param id The ID of error or NaN.
     */
    public function IllegalStateError(message:String, id:Number = NaN) {
        super(message, id);
    }
}
}
