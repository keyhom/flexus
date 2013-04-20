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

package flexus.core.xwork.filterChain {

import flash.utils.getQualifiedClassName;

import flexus.utils.ArrayQueue;
import flexus.utils.IQueue;

/**
 * @author keyhom
 */
public class DefaultIoFilterChainBuilder implements IoFilterChainBuilder {

    /**
     * Creates a DefaultIoFilterChainBuilder instance..
     */
    public function DefaultIoFilterChainBuilder(filterChain:DefaultIoFilterChainBuilder =
                                                        null) {
        super();
        queue = new ArrayQueue(32);

        if (filterChain == null)
            init0();
        else
            init1(filterChain);
    }

    private var queue:IQueue;
    private var entries:Vector.<IoFilterChainEntry>;

    public function buildFilterChain(filterChain:IoFilterChain):void {
        for each (var entry:IoFilterChainEntry in this.entries) {
            filterChain.addLast(entry.name, entry.filter);
        }
    }

    public function getEntry(x:Object):IoFilterChainEntry {
        if (x is String)
            return getEntryByString(x.toString());
        else if (x is IoFilter)
            return getEntryByIoFilter(x as IoFilter);
        else if (x is Class)
            return getEntryByClass(x as Class);
        return null;
    }

    public function get(x:Object):IoFilter {
        var entry:IoFilterChainEntry = this.getEntry(x);

        if (entry == null)
            return null;

        return entry.filter;
    }

    public function getAll():Vector.<IoFilterChainEntry> {
        // return new Vector.<IoFilterChainEntry>(this.entries);
        return this.entries;
    }

    public function getAllReversed():Vector.<IoFilterChainEntry> {
        // return new Vector.<IoFilterChainEntry>(this.entries.reverse());
        return this.entries.reverse();
    }

    public function contains(x:Object):Boolean {
        return (this.getEntry(x) != null);
    }

    public function addFirst(name:String, filter:IoFilter):void {
        register(0, new EntryImpl(this, name, filter));
    }

    public function addLast(name:String, filter:IoFilter):void {
        register(this.entries.length, new EntryImpl(this, name, filter));
    }

    public function addBefore(target:String, name:String, filter:IoFilter):void {
        this.checkBaseName(target);

        for (var index:String in this.entries) {
            var entry:IoFilterChainEntry = this.entries[index];

            if (entry.name == target) {
                register(parseInt(index), new EntryImpl(this, name, filter));
                return;
            }
        }
    }

    public function addAfter(target:String, name:String, filter:IoFilter):void {
        this.checkBaseName(target);

        for (var index:String in this.entries) {
            var entry:IoFilterChainEntry = this.entries[index];

            if (entry.name == target) {
                register(parseInt(index + 1), new EntryImpl(this, name, filter));
                return;
            }
        }
    }

    public function remove(x:Object):IoFilter {
        if (x == null)
            throw new ArgumentError("x");
        else if (x is String)
            return removeByName(x as String);
        else if (x is IoFilter)
            return removeByFilter(x as IoFilter);
        else if (x is Class)
            return removeByClass(x as Class);
        throw new ArgumentError("x");
    }

    public function removeByName(name:String):IoFilter {
        for (var index:String in this.entries) {
            var entry:IoFilterChainEntry = this.entries[index];

            if (entry.name == name) {
                delete this.entries[index];
                return entry.filter;
            }
        }
        throw new ArgumentError("Unknown filter name: " + name);
    }

    public function removeByFilter(filter:IoFilter):IoFilter {
        for (var index:String in this.entries) {
            var entry:IoFilterChainEntry = this.entries[index];

            if (entry.filter == filter) {
                delete this.entries[index];
                return entry.filter;
            }
        }
        throw new ArgumentError("filter not found: " + getQualifiedClassName(filter));
    }

    public function removeByClass(cla:Class):IoFilter {
        for (var index:String in this.entries) {
            var entry:IoFilterChainEntry = this.entries[index];

            if (entry is cla) {
                delete this.entries[index];
                return entry.filter;
            }
        }

        throw new ArgumentError("filter not found: " + cla);
    }

    public function replace(x:Object, filter:IoFilter):void {
        if (x == null)
            throw new ArgumentError("x");
        else if (filter == null)
            throw new ArgumentError("filter");
        else if (x is String)
            replaceByName(x as String, filter);
        else if (x is IoFilter)
            replaceByFilter(x as IoFilter, filter);
        else if (x is Class)
            replaceByClass(x as Class, filter);

        throw new ArgumentError("Illegal type of x!");
    }

    public function clear():void {
        this.entries = new Vector.<IoFilterChainEntry>();
    }

    private function init0():void {
        this.entries = new Vector.<IoFilterChainEntry>();
    }

    private function init1(filterChain:DefaultIoFilterChainBuilder):void {
        // this.entries = new Vector.<IoFilterChainEntry>(filterChain.entries);
        this.entries = filterChain.entries;
    }

    private function getEntryByString(name:String):IoFilterChainEntry {
        for each (var entry:IoFilterChainEntry in this.entries) {
            if (entry.name == name)
                return entry;
        }
        return null;
    }

    private function getEntryByIoFilter(filter:IoFilter):IoFilterChainEntry {
        for each (var entry:IoFilterChainEntry in this.entries) {
            if (entry.filter == filter)
                return entry;
        }
        return null;
    }

    private function getEntryByClass(cla:Class):IoFilterChainEntry {
        for each (var entry:IoFilterChainEntry in this.entries) {
            if (entry is cla)
                return entry;
        }
        return null;
    }

    private function replaceByName(name:String, newFilter:IoFilter):void {
        this.checkBaseName(name);
        var impl:EntryImpl = getEntry(name) as EntryImpl;
        var old:IoFilter = impl.filter;
        impl.filter = newFilter;
    }

    private function replaceByFilter(filter:IoFilter, newFilter:IoFilter):void {
        for each (var e:IoFilterChainEntry in this.entries) {
            if (e.filter == filter) {
                (e.filter as EntryImpl).filter = newFilter;
                return;
            }
        }
        throw new ArgumentError("filter not found: " + getQualifiedClassName(filter));
    }

    private function replaceByClass(cla:Class, newFilter:IoFilter):void {
        for each (var e:IoFilterChainEntry in this.entries) {
            if (e.filter is cla) {
                (e.filter as EntryImpl).filter = newFilter;
                return;
            }
        }
        throw new ArgumentError("filter not found: " + cla);
    }

    private function checkBaseName(name:String):void {
        if (name == null)
            throw new ArgumentError("baseName");

        if (!contains(name))
            throw new ArgumentError("Unknown filter name: " + name);
    }

    private function register(index:int, entry:IoFilterChainEntry):void {
        if (contains(entry.name))
            throw new ArgumentError("Other filter is using the same name: " +
                    entry.name);

        if (index == 0)
            this.entries.unshift(entry);
        else if (index == this.entries.length)
            this.entries.push(entry);
        else {
            var t1:Vector.<IoFilterChainEntry> = this.entries.slice(0, index);
            var t2:Vector.<IoFilterChainEntry> = this.entries.slice(index);
            t1.push(entry);
            this.entries = t1.concat(t2);
        }
    }
}
}

import flexus.core.xwork.filterChain.DefaultIoFilterChainBuilder;
import flexus.core.xwork.filterChain.IoFilter;
import flexus.core.xwork.filterChain.IoFilterChainEntry;
import flexus.core.xwork.filterChain.NextFilter;

class EntryImpl implements IoFilterChainEntry {

    private var _builder:DefaultIoFilterChainBuilder;

    private var _name:String;

    private var _filter:IoFilter;

    private var _nextFilter:NextFilter;

    public function EntryImpl(builder:DefaultIoFilterChainBuilder, name:String, filter:IoFilter, nextFilter:NextFilter = null) {

        if (name == null)
            throw new ArgumentError("name");

        if (filter == null)
            throw new ArgumentError("filter");

        this._builder = builder;
        this._name = name;
        this._filter = filter;
        this._nextFilter = nextFilter;
    }

    public function get name():String {
        return this._name;
    }

    public function get filter():IoFilter {
        return this._filter;
    }

    public function set filter(filter:IoFilter):void {
        this._filter = filter;
    }

    public function get nextFilter():NextFilter {
        return this._nextFilter;
    }

    public function addAfter(name:String, filter:IoFilter):void {
        this._builder.addAfter(this.name, name, filter);
    }

    public function addBefore(name:String, filter:IoFilter):void {
        this._builder.addBefore(this.name, name, filter);
    }

    public function remove():void {
        this._builder.remove(this.name);
    }

    public function replace(newFilter:IoFilter):void {
        this._builder.replace(this.name, newFilter);
    }

}

