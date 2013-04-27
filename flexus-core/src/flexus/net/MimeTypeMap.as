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

package flexus.net {

/**
 * @author keyhom
 */
public class MimeTypeMap {

    /**
     * Creates a MimeTypeMap instance.
     */
    public function MimeTypeMap() {
    }

    private var types:Array = [
        ["application/andrew-inset", "ez"],
        ["application/atom+xml", "atom"],
        ["application/mac-binhex40", "hqx"],
        ["application/mac-compactpro", "cpt"],
        ["application/mathml+xml", "mathml"],
        ["application/msword", "doc"],
        ["application/octet-stream", "bin", "dms", "lha", "lzh", "exe", "class", "so", "dll", "dmg"],
        ["application/oda", "oda"],
        ["application/ogg", "ogg"],
        ["application/pdf", "pdf"],
        ["application/postscript", "ai", "eps", "ps"],
        ["application/rdf+xml", "rdf"],
        ["application/smil", "smi", "smil"],
        ["application/srgs", "gram"],
        ["application/srgs+xml", "grxml"],
        ["application/vnd.adobe.apollo-application-installer-package+zip", "air"],
        ["application/vnd.mif", "mif"],
        ["application/vnd.mozilla.xul+xml", "xul"],
        ["application/vnd.ms-excel", "xls"],
        ["application/vnd.ms-powerpoint", "ppt"],
        ["application/vnd.rn-realmedia", "rm"],
        ["application/vnd.wap.wbxml", "wbxml"],
        ["application/vnd.wap.wmlc", "wmlc"],
        ["application/vnd.wap.wmlscriptc", "wmlsc"],
        ["application/voicexml+xml", "vxml"],
        ["application/x-bcpio", "bcpio"],
        ["application/x-cdlink", "vcd"],
        ["application/x-chess-pgn", "pgn"],
        ["application/x-cpio", "cpio"],
        ["application/x-csh", "csh"],
        ["application/x-director", "dcr", "dir", "dxr"],
        ["application/x-dvi", "dvi"],
        ["application/x-futuresplash", "spl"],
        ["application/x-gtar", "gtar"],
        ["application/x-hdf", "hdf"],
        ["application/x-javascript", "js"],
        ["application/x-koan", "skp", "skd", "skt", "skm"],
        ["application/x-latex", "latex"],
        ["application/x-netcdf", "nc", "cdf"],
        ["application/x-sh", "sh"],
        ["application/x-shar", "shar"],
        ["application/x-shockwave-flash", "swf"],
        ["application/x-stuffit", "sit"],
        ["application/x-sv4cpio", "sv4cpio"],
        ["application/x-sv4crc", "sv4crc"],
        ["application/x-tar", "tar"],
        ["application/x-tcl", "tcl"],
        ["application/x-tex", "tex"],
        ["application/x-texinfo", "texinfo", "texi"],
        ["application/x-troff", "t", "tr", "roff"],
        ["application/x-troff-man", "man"],
        ["application/x-troff-me", "me"],
        ["application/x-troff-ms", "ms"],
        ["application/x-ustar", "ustar"],
        ["application/x-wais-source", "src"],
        ["application/xhtml+xml", "xhtml", "xht"],
        ["application/xml", "xml", "xsl"],
        ["application/xml-dtd", "dtd"],
        ["application/xslt+xml", "xslt"],
        ["application/zip", "zip"],
        ["audio/basic", "au", "snd"],
        ["audio/midi", "mid", "midi", "kar"],
        ["audio/mp4", "f4a"],
        ["audio/mp4", "f4b"],
        ["audio/mpeg", "mp3", "mpga", "mp2"],
        ["audio/x-aiff", "aif", "aiff", "aifc"],
        ["audio/x-mpegurl", "m3u"],
        ["audio/x-pn-realaudio", "ram", "ra"],
        ["audio/x-wav", "wav"],
        ["chemical/x-pdb", "pdb"],
        ["chemical/x-xyz", "xyz"],
        ["image/bmp", "bmp"],
        ["image/cgm", "cgm"],
        ["image/gif", "gif"],
        ["image/ief", "ief"],
        ["image/jpeg", "jpg", "jpeg", "jpe"],
        ["image/png", "png"],
        ["image/svg+xml", "svg"],
        ["image/tiff", "tiff", "tif"],
        ["image/vnd.djvu", "djvu", "djv"],
        ["image/vnd.wap.wbmp", "wbmp"],
        ["image/x-cmu-raster", "ras"],
        ["image/x-icon", "ico"],
        ["image/x-portable-anymap", "pnm"],
        ["image/x-portable-bitmap", "pbm"],
        ["image/x-portable-graymap", "pgm"],
        ["image/x-portable-pixmap", "ppm"],
        ["image/x-rgb", "rgb"],
        ["image/x-xbitmap", "xbm"],
        ["image/x-xpixmap", "xpm"],
        ["image/x-xwindowdump", "xwd"],
        ["model/iges", "igs", "iges"],
        ["model/mesh", "msh", "mesh", "silo"],
        ["model/vrml", "wrl", "vrml"],
        ["text/calendar", "ics", "ifb"],
        ["text/css", "css"],
        ["text/html", "html", "htm"],
        ["text/plain", "txt", "asc"],
        ["text/richtext", "rtx"],
        ["text/rtf", "rtf"],
        ["text/sgml", "sgml", "sgm"],
        ["text/tab-separated-values", "tsv"],
        ["text/vnd.wap.wml", "wml"],
        ["text/vnd.wap.wmlscript", "wmls"],
        ["text/x-setext", "etx"],
        ["video/mp4", "f4v"],
        ["video/mp4", "f4p"],
        ["video/mpeg", "mpg", "mpeg", "mpe"],
        ["video/quicktime", "mov", "qt"],
        ["video/vnd.mpegurl", "m4u", "mxu"],
        ["video/x-flv", "flv"],
        ["video/x-msvideo", "avi"],
        ["video/x-sgi-movie", "movie"],
        ["x-conference/x-cooltalk", "ice"]
    ];

    /**
     * Adds a mimetype to the map. The order of the extensions matters. The most preferred should come first.
     */
    public function addMimeType(mimetype:String, extensions:Array):void {
        var newType:Array = [mimetype];
        for each (var a:String in extensions) {
            newType.push(a);
        }
        types.push(newType);
    }

    /**
     * Returns the prefered extension for the given mimetype.
     */
    public function getExtension(mimetype:String):String {
        mimetype = mimetype.toLocaleLowerCase();
        for each (var a:Array in types) {
            if (a[0] == mimetype) {
                return a[1];
            }
        }
        return null;
    }

    /**
     * Returns the mimetype for the given extension.
     */
    public function getMimeType(extension:String):String {
        extension = extension.toLocaleLowerCase();
        for each (var a:Array in types) {
            for each (var b:String in a) {
                if (b == extension) {
                    return a[0];
                }
            }
        }
        return null;
    }
}
}
