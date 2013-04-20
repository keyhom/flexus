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

package flexus.images {

import flash.display.BitmapData;
import flash.utils.ByteArray;

/**
 * Class that converts BitmapData into a valid PNG
 */
public class PNGEncoder {

    static private var crcTable:Array;
    static private var crcTableComputed:Boolean = false;

    /**
     * Created a PNG image from the specified BitmapData
     *
     * @param img The BitmapData that will be converted into the PNG format.
     * @return a ByteArray representing the PNG encoded image data.
     */
    static public function encode(img:BitmapData):ByteArray {
        // Create output byte array
        var png:ByteArray = new ByteArray();
        // Write PNG signature
        png.writeUnsignedInt(0x89504e47);
        png.writeUnsignedInt(0x0D0A1A0A);
        // Build IHDR chunk
        var IHDR:ByteArray = new ByteArray();
        IHDR.writeInt(img.width);
        IHDR.writeInt(img.height);
        IHDR.writeUnsignedInt(0x08060000); // 32bit RGBA
        IHDR.writeByte(0);
        writeChunk(png, 0x49484452, IHDR);
        // Build IDAT chunk
        var IDAT:ByteArray = new ByteArray();
        for (var i:int = 0; i < img.height; i++) {
            // no filter
            IDAT.writeByte(0);
            var p:uint;
            var j:int;
            if (!img.transparent) {
                for (j = 0; j < img.width; j++) {
                    p = img.getPixel(j, i);
                    IDAT.writeUnsignedInt(uint(((p & 0xFFFFFF) << 8) | 0xFF));
                }
            }
            else {
                for (j = 0; j < img.width; j++) {
                    p = img.getPixel32(j, i);
                    IDAT.writeUnsignedInt(uint(((p & 0xFFFFFF) << 8) | (p >>>
                            24)));
                }
            }
        }
        IDAT.compress();
        writeChunk(png, 0x49444154, IDAT);
        // Build IEND chunk
        writeChunk(png, 0x49454E44, null);
        // return PNG
        return png;
    }

    static private function writeChunk(png:ByteArray, type:uint, data:ByteArray):void {
        if (!crcTableComputed) {
            crcTableComputed = true;
            crcTable = [];
            var c:uint;
            for (var n:uint = 0; n < 256; n++) {
                c = n;
                for (var k:uint = 0; k < 8; k++) {
                    if (c & 1) {
                        c = uint(uint(0xedb88320) ^ uint(c >>> 1));
                    }
                    else {
                        c = uint(c >>> 1);
                    }
                }
                crcTable[n] = c;
            }
        }
        var len:uint = 0;
        if (data != null) {
            len = data.length;
        }
        png.writeUnsignedInt(len);
        var p:uint = png.position;
        png.writeUnsignedInt(type);
        if (data != null) {
            png.writeBytes(data);
        }
        var e:uint = png.position;
        png.position = p;
        c = 0xffffffff;
        for (var i:int = 0; i < (e - p); i++) {
            c = uint(crcTable[(c ^ png.readUnsignedByte()) & uint(0xff)] ^ uint(c >>>
                    8));
        }
        c = uint(c ^ uint(0xffffffff));
        png.position = e;
        png.writeUnsignedInt(c);
    }
}
}
