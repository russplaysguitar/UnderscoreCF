/** 
* @name Underscore.cfc 
* @hint A port of Underscore.js for Coldfusion
* @introduction Underscore.cfc is a port of <a href="http://underscorejs.org">Underscore.js</a> for Coldfusion. It is a utility-belt library that provides a lot of the functional programming support that you would expect in Prototype.js (or Ruby). <br /><br />Underscore.cfc provides dozens of functions that support both the usual functional suspects: map, select, <s>invoke</s> - as well as more specialized helpers: function binding, <s>templating, deep equality testing,</s> and so on. It delegates to built-in functions where applicable.<br /><br />Underscore.cfc is currently only tested on Adobe Coldfusion 10. <b>It is still in progress (very beta), so please be careful using it.</b> I recommend <a href="https://github.com/markmandel/Sesame" target="_blank">Sesame</a> if you want something similar but more stable.<br /><br />Some unit tests are included, but much work needs to be done there.<br /><br />The project is <a href="http://github.com/russplaysguitar/underscorecf">hosted on GitHub</a>. Contributions are welcome.<br />
* 
*/ 
component { 

	public any function init(obj = {}) { 
		this.obj = obj;

		variables._ = this;

		_.identity = function(x) { return x; };

		return this;
	}

	/* COLLECTION FUNCTIONS (ARRAYS, STRUCTURES, OR OBJECTS) */

	/**
	* 	@header _.each(list, iterator, [context]) : void
	*	@hint Iterates over a list of elements, yielding each in turn to an iterator function. The iterator is bound to the context object (component), if one is passed. Each invocation of iterator is called with three arguments: (element, index, list). If list is an object/struct, iterator's arguments will be (value, key, list). 
	* 	@example _.each([1, 2, 3], function(num){ writeDump(num); }); <br />=> dumps each number in turn... <br />_.each({one : 1, two : 2, three : 3}, function(num, key){ writeDump(num); });<br />=> dumps each number in turn...
	*/
	public void function each(obj = this.obj, iterator = _.identity, context = new Component()) {
 		context.iterator = iterator;

		if (isArray(obj)) {
			var index = 1;
			for (element in obj) {
				if (isDefined("element")) {
					context.iterator(element, index, obj);
				}
				index++;
			}
		}
		else if (isObject(obj) || isStruct(obj)) {	
			for (key in obj) {
				var val = obj[key];
				context.iterator(val, key, obj);
			}
		}
		else {
			// query or something else? convert to array and recurse
			_.each(toArray(obj), iterator, context);			
		}
 	}

 	/**
 	* 	@alias each
 	*/
	public void function forEach(obj, iterator, context) {
	    _.each(argumentCollection = arguments);
 	}

	/**
	* 	@header _.map(list, iterator, [context]) : array
	*	@hint Produces a new array of values by mapping each value in list through a transformation function (iterator). If list is an object/struct, iterator's arguments will be (value, key, list).
	* 	@example _.map([1, 2, 3], function(num){ return num * 3; }); <br />=> [3, 6, 9] <br />_.map({one : 1, two : 2, three : 3}, function(num, key){ return num * 3; });<br />=> [3, 6, 9]
	*/
 	public array function map(obj = this.obj, iterator = _.identity, context = new Component()) {
 		var result = [];
 		context.iterator = iterator;

		if (isArray(obj)) {
			var index = 1;
			for (element in obj) {
				var local = {};
				local.tmp = context.iterator(element, index, obj);
				if (structKeyExists(local, "tmp")) {
					result[index] = context.iterator(element, index, obj);
				}
				index++;
			}
		}
		else if (isObject(obj) || isStruct(obj)) {	
			var index = 1;
			for (key in obj) {
				var val = obj[key];
				var local = {};
				local.tmp = context.iterator(val, key, obj);
				if (structKeyExists(local, "tmp")) {
					result[index] = local.tmp;
				}
				index++;
			}
		}
		else {
			// query or something else? convert to array and recurse
			result = _.map(toArray(obj), iterator, context);			
		}

		return result;
 	}
 	
 	/**
 	* 	@alias map
 	*/
  	public array function collect(obj, iterator, context) {
 		return _.map(argumentCollection = arguments);
 	}

	/**
	* 	@header _.reduce(list, iterator, memo, [context]) : any
	*	@hint Also known as inject and foldl, reduce boils down a list of values into a single value. Memo is the initial state of the reduction, and each successive step of it should be returned by iterator.
	* 	@example sum = _.reduce([1, 2, 3], function(memo, num){ return memo + num; }, 0);<br />=> 6
	*/
 	public any function reduce(obj = this.obj, iterator = _.identity, memo, context = new Component()) {
 		context.iterator = iterator;

 		var outer = {};
 		if (structKeyExists(arguments, "memo")) {
	 		outer.initial = memo;
 		}
		_.each(obj, function(value, index, list) {
			if (!structKeyExists(outer, "initial")) {
				memo = value;
				outer.initial = true;
			} 
			else {
				memo = context.iterator(memo, value, index, list);
			}
		});

		return memo;		
 	}
 	
 	/**
 	*	@alias reduce
 	*/
  	public any function foldl(obj, iterator, memo, context) {
 		return _.reduce(argumentCollection = arguments);
 	}
 	
 	/**
 	*	@alias reduce
 	*/
   	public any function inject(obj, iterator, memo, context) {
 		return _.reduce(argumentCollection = arguments);
 	}

 	/*
		The right-associative version of reduce. 
		@header _.reduceRight(list, iterator, memo, [context])
 	*/
  	public any function reduceRight(obj = this.obj, iterator = _.identity, memo, context = new Component()) {
  		// TODO
   	}

   	// alias of reduceRight
 	public any function foldr(obj, iterator, memo, context) {
 		return _.reduceRight(argumentCollection = arguments);
 	}
 	
 	/**
	* 	@header _.find(list, iterator, [context]) : any
	*	@hint Looks through each value in the list, returning the first one that passes a truth test (iterator). The function returns as soon as it finds an acceptable element, and doesn't traverse the entire list.
	* 	@example even = _.find([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });<br />=> 2
 	*/
 	public any function find(obj = this.obj, iterator = _.identity, context = new Component()) { 
 		var result = 0;
 		context.iterator = iterator;

		if (isArray(obj)) {
			var index = 1;
			for (val in obj) {
				if (context.iterator(val, index, obj)) {
					result = val;
					break;
				}
				index++;
			}
		}
		else if (isObject(obj) || isStruct(obj)) {	
			var index  = 1;
			for (key in obj) {
				var val = obj[key];
				if (context.iterator(val, index, obj)) {
					result = val;
					break;
				}
				index++;
			}
		}
		else {
			// query or something else? convert to array and recurse
			return _.find(toArray(obj), iterator, context);			
		}

		return result;
 	}
 	
 	/**
 	* 	@alias find
 	*/
  	public any function detect(obj, iterator, context) { 
 		return _.find(argumentCollection = arguments);
 	}

 	/**
	* 	@header _.filter(list, iterator, [context]) : array
	*	@hint Looks through each value in the list, returning an array of all the values that pass a truth test (iterator). 
	* 	@example evens = _.filter([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });<br />=> [2, 4, 6]
 	*/
 	public array function filter(obj = this.obj, iterator = _.identity, context = new Component()) {
		var result = [];
 		context.iterator = iterator;

		if (isArray(obj)) {
			var index = 1;
			for (val in obj) {
				var success = context.iterator(val, index, obj);
				if (success) {
					result[index] = val;
					index++;
				}
			}
		}
		else if (isObject(obj) || isStruct(obj)) {	
			var index = 1;
			for (key in obj) {
				var val = obj[key];
				var success = context.iterator(val, index, obj);
				if (success) {
					result[index] = val;
					index++;
				}
			}
		}
		else {
			// query or something else? convert to array and recurse
			return _.filter(toArray(obj), iterator, context);			
		}

		return result;
 	}

 	/**
 	*	@alias filter
 	*/
	public array function select(obj, iterator, context) {
		return _.filter(argumentCollection = arguments);
	}
	
	/**
	* 	@header _.reject(list, iterator, [context]) : array
	*	@hint Returns the values in list without the elements that the truth test (iterator) passes. The opposite of filter.
	* 	@example odds = _.reject([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });<br />=> [1, 3, 5]
	*/
	public array function reject(obj = this.obj, iterator = _.identity, context = new Component()) {
		var result = [];
 		context.iterator = iterator;

		if (isArray(obj)) {
			var index = 1;
			for (val in obj) {
				var success = context.iterator(val, index, obj);
				if (!success) {
					result[index] = val;
					index++;
				}
			}
		}
		else if (isObject(obj) || isStruct(obj)) {	
			var index = 1;
			for (key in obj) {
				var val = obj[key];
				var success = context.iterator(val, index, obj);
				if (!success) {
					result[index] = val;
					index++;
				}
			}
		}
		else {
			// query or something else? convert to array and recurse
			return _.reject(toArray(obj), iterator, context);			
		}

		return result;		
	}


	/**
	* 	@header _.all(list, iterator, [context]) : boolean
	*	@hint Returns true if all of the values in the list pass the iterator truth test. 
	* 	@example _.all([true, 1, 'no'], _.identity);<br />=> false
	*/
	public boolean function all(obj = this.obj, iterator = _.identity, context = new Component()) {
		var result = false;
 		context.iterator = iterator;

		if (isArray(obj)) {
			var index = 1;
			for (val in obj) {
				result = context.iterator(val, index, obj);
				if (!result) {
					break;
				}
				index++;
			}
		}
		else if (isObject(obj) || isStruct(obj)) {	
			var index  = 1;
			for (key in obj) {
				var val = obj[key];
				result = context.iterator(val, index, obj);
				if (!result) {
					break;
				}
				index++;
			}
		}
		else {
			return _.all(toArray(obj), iterator, context);			
		}

		return toBoolean(result);		
	}
	
	/** 
	*	@alias all
	*/
	public boolean function every(obj, iterator, context) {
		return _.all(argumentCollection = arguments);
	}
	
	/**
	* 	@header _.any(list, [iterator], [context]) : boolean
	*	@hint Returns true if any of the values in the list pass the iterator truth test. Short-circuits and stops traversing the list if a true element is found. 
	* 	@example _.any([0, 'yes', false]);<br />=> true
	*/
	public boolean function any(obj = this.obj, iterator = _.identity, context = new Component()) {
		var result = false;
 		context.iterator = iterator;

		if (isArray(obj)) {
			var index = 1;
			for (value in obj) {
				result = context.iterator(value, index, obj);
				if (result) {
					break;
				}
				index++;
			}
		}
		else if (isObject(obj) || isStruct(obj)) {	
			var index  = 1;
			for (key in obj) {
				var value = obj[key];
				result = context.iterator(value, index, obj);
				if (result) {
					break;
				}
				index++;
			}
		}
		else {
			return _.any(toArray(obj), iterator, context);			
		}

		return toBoolean(result);
	}
	
	/**
	* 	@alias any
	*/ 
	public boolean function some(obj, iterator, context) {
		return _.any(argumentCollection = arguments);
	}	

	/**
	* 	@header _.include(list, value) : boolean
	*	@hint Returns true if the value is present in the list.
	* 	@example _.include([1, 2, 3], 3);<br />=> true
	*/
	public boolean function include(obj = this.obj, target) {
		return _.any(obj, function(value) {
			if (!isSimpleValue(value) || !isSimpleValue(target)) {
				var obj1 = serializeJSON(value);
				var obj2 = serializeJSON(target);
				return obj1 == obj2;
			}
			else {
				return value == target;
			}
		});
	}

	/**
	* 	@header _.invoke(list, methodName, [arguments]) : array
	*	@hint Calls the method named by methodName on each value in the list. The arguments struct passed to invoke will be forwarded on to the method invocation. 
	* 	@example _.invoke([{fun: function(){ return 1; }}], 'fun');<br />=> [1]
	*/
	// TODO: make sure this works right
	// TODO: decide whether or not to replace with native invoke()
	public array function invoke(obj = this.obj, method, args = {}) {
	    return _.map(obj, function(value) {
	    	if (_.isFunction(method)) {
	    		// try to call method() directly
	    		var result = method(args);
	    		if (isDefined('result')) {
	    			return result;
	    		}
	    		else {
	    			return value;
	    		}
	    	}
	    	else if((isObject(value) || isStruct(value)) && structKeyExists(value, method)) {
	    		// call method as member of obj item
	    		var fun = value[method];
	    		return fun(args);
	    	}
	    	else {
	    		// no idea what method() is all about, return value instead
	    		// note: this might be dangerous
	    		return value;
	    	}
	    });
	}

	/**
	* 	@header _.pluck(list, propertyName) : array
	*	@hint A convenient version of what is perhaps the most common use-case for map: extracting a list of property values.
	* 	@example stooges = [{name : 'moe', age : 40}, {name : 'larry', age : 50}, {name : 'curly', age : 60}];<br />_.pluck(stooges, 'name');<br />=> ["moe", "larry", "curly"]
	*/
	public array function pluck(obj = this.obj, key) {
    	return _.map(obj, function(value){
    		if (_.isFunction(key)) {
    			return key(value);
    		}
    		else if (isArray(value) && arrayLen(value) >= key) {
	    		return value[key];    			
    		}
    		else if ((isStruct(value) || isObject(value)) && structKeyExists(value, key)) {
	    		return value[key];
    		}
    		else if (isQuery(value)) {
    			return _.pluck(_.toArray(value), key);
    		}
    		else {
    			return;
    		}
    	});				
	}

	/**
	* 	@header _.max(list, [iterator], [context]) : any
	*	@hint Returns the maximum value in list. If iterator is passed, it will be used on each value to generate the criterion by which the value is ranked.
	* 	@example stooges = [{name : 'moe', age : 40}, {name : 'larry', age : 50}, {name : 'curly', age : 60}];<br />_.max(stooges, function(stooge){ return stooge.age; });<br />=> {name : 'curly', age : 60};
	*/
	public any function max(obj = this.obj, iterator = _.identity, context = new Component()) {
		var result = {};
 		context.iterator = iterator;

	    _.each(obj, function(value, index, obj) {
    		var computed = context.iterator(value, index, obj);
	    	if (isNumeric(computed)) {
		    	if (!structKeyExists(result, 'computed') || computed >= result.computed) {
		    		result = {value : value, computed : computed};
		    	}
	    	}
	    });
	    if (structKeyExists(result, 'value')) {
		    return result.value;
	    }
	}

	/**
	* 	@header _.min(list, [iterator], [context]) : any
	*	@hint Returns the minimum value in list. If iterator is passed, it will be used on each value to generate the criterion by which the value is ranked.
	* 	@example numbers = [10, 5, 100, 2, 1000];<br />_.min(numbers);<br />=> 2
	*/
	public any function min(obj = this.obj, iterator = _.identity, context = new Component()) {
		var result = {};
 		context.iterator = iterator;

	    _.each(obj, function(value, index, obj) {
    		var computed = context.iterator(value, index, obj);
	    	if (isNumeric(computed)) {
		    	if (!structKeyExists(result, 'computed') || computed <= result.computed) {
		    		result = {value : value, computed : computed};
		    	}
	    	}
	    });
	    if (structKeyExists(result, 'value')) {
		    return result.value;
	    }		
	}

	/**
	* 	@header _.sortBy(list, iterator, [context]) : array
	*	@hint Returns a sorted copy of list, ranked in ascending order by the results of running each value through iterator. Iterator may also be the string name of the property to sort by (eg. length).
	* 	@example _.sortBy([6, 2, 4, 3, 5, 1], function(num){ return num; });<br />=> [1, 2, 3, 4, 5, 6]
	*/
	public array function sortBy(obj = this.obj, val, context = new Component()) {
		if (_.isFunction(val)) {
			var iterator = val;
		}
		else {
			var iterator = function(obj) {
				return obj[val];
			};
		}
 		context.iterator = iterator;
		var toSort = _.map(obj, function(value, index, list, context) {
			return {
				value : value,
				criteria : context.iterator(value, index, list, context)
			};
		});
		var sorted = this.sort(toSort, function(left, right) {
			if (!structKeyExists(left, 'criteria')) {
				return 1;
			}
			else if (!structKeyExists(right, 'criteria')) {
				return -1;
			}
			var a = left.criteria;
			var b = right.criteria;	
			return _.comparison(a, b);
		});
		return _.pluck(sorted, 'value');
	}

	// for sortBy()
	// note: this isn't part of UnderscoreJS, but CF doesn't have a sort() that can use a custom comparison function
	public array function sort(obj = this.obj, iterator = this.comparison) {
		var array = _.toArray(obj);
		if(arraylen(array) < 2) {
			return array;
		}
		var middle = ceiling(arraylen(array) / 2);
		var left = sort(_.slice(array, 1, middle), iterator);
		var right = sort(_.slice(array, middle+1), iterator);
		var merge = this.merge(left, right, iterator);
		return merge;
	}

	// for sort()
	public array function merge(left, right, comparison = this.comparison)
	{
		var result = [];
		while((arraylen(left) > 0) && (arraylen(right) > 0))
		{
			if(comparison(left[1], right[1]) <= 0) {
				var item = left[1];
				arrayDeleteAt(left, 1);
				arrayAppend(result, item);
			}
			else {
				var item = right[1];
				arrayDeleteAt(right, 1);
				arrayAppend(result, item);
			}
		}
		while(arraylen(left) > 0) {
			var item = left[1];
			arrayDeleteAt(left, 1);
			arrayAppend(result, item);
		}
		while(arraylen(right) > 0) {
			var item = right[1];
			arrayDeleteAt(right, 1);
			arrayAppend(result, item);
		}
		return result;
	}

	// for merge()
	public numeric function comparison(left, right) {		
		if(left == right)
			return 0;
		else if(left < right)
			return -1;
		else
			return 1;
	}
	
	/**
	* 	@header _.groupBy(list, iterator) : struct
	*	@hint Splits a collection into sets, grouped by the result of running each value through iterator. If iterator is a string instead of a function, groups by the property named by iterator on each of the values.
	*	@example _.groupBy([1.3, 2.1, 2.4], function(num){ return fix(num); });<br />=> {1: [1.3], 2: [2.1, 2.4]}<br /><br />_.groupBy(['one', 'two', 'three'], function(num) { return len(num); });<br />=> {3: ["one", "two"], 5: ["three"]}
	*/
	public struct function groupBy(obj = this.obj, val) {
		var result = {};
		if (_.isFunction(val)) {
			var iterator = val;
		}
		else {
			var iterator = function(obj) { return obj[val]; };
		}
		_.each(obj, function(value, index) {
			var key = iterator(value, index);
			if (!structKeyExists(result, key)) {
				result[key] = [];
			}
			arrayAppend(result[key], value);
		});
		return result;
	}

	/**
	* 	@header _.sortedIndex(list, value, [iterator]) : numeric
	*	@hint Uses a binary search to determine the index at which the value should be inserted into the list in order to maintain the list's sorted order. If an iterator is passed, it will be used to compute the sort ranking of each value.
	* 	@example _.sortedIndex([10, 20, 30, 40, 50], 35);<br />=> 4
	*/
	public numeric function sortedIndex(array = this.obj, obj, iterator = _.identity) {
		var low = 0;
		var high = arrayLen(array);
		while (low < high) {
			var mid = BitSHRN((low + high), 1);
			if (iterator(array[mid]) < iterator(obj) ) {
				low = mid + 1;
			}
			else {
				high = mid;
			}
		}
		return low;				
	}

	/**
	* 	@header _.shuffle(array) : array
	*	@hint Returns a shuffled copy of the array, using a version of the Fisher-Yates shuffle.
	* 	@example _.shuffle([1, 2, 3, 4, 5, 6]);<br />=> [4, 1, 6, 3, 5, 2]
	*/
	public array function shuffle(obj = this.obj) {
	    var shuffled = obj;
	    var rand = 0;
	    _.each(obj, function(value, index, list) {
			rand = fix(1 + (rand() * (index)));
			shuffled[index] = shuffled[rand];
			shuffled[rand] = value;
	    });
	    return shuffled;		
	}

	/**
	*	@header _.toArray(list) : array
	*	@hint Converts the list (object, query or struct), into an array. Useful for transmuting the arguments object.
	* 	@example _.toArray({a:10,b:20});<br />=> [10, 20]
	*/
	public array function toArray(obj = this.obj) {
		if (isArray(obj)) {
			return obj;
		}
		else if (isQuery(obj)) {
			var result = [];
			for (index = 1; index <= obj.RecordCount; index++) {
				var row = {};
				for (var colName in obj.columnList) {
					row[colName] = obj[colName][index];
				}
				result[index] = row;
			}
			return result;	
		}
		else if (isObject(obj) || isStruct(obj)) {
			return _.values(obj);
		}
		else {
			// TODO: make sure this is right
			return [];
		}
	}
	
	/**
	* 	@header _.size(list) : numeric
	*	@hint Return the number of values in the list.
	* 	@example _.size({one : 1, two : 2, three : 3});<br />=> 3
	*/
	public numeric function size(obj = this.obj) {
		if (isObject(obj) || isStruct(obj)) {
			return structCount(obj);
		}
		else if (isArray(obj)) {
			return arrayLen(obj);
		}
		else if (isQuery(obj)) {
			return obj.recordCount;
		}
		else {
			throw "size() is only compatible with objects, structs, and arrays.";
		}
	}

	/* ARRAY FUNCTIONS */

	/**
	* 	@header _.first(array, [n]) : any
	*	@hint Returns the first element of an array. Passing n will return the first n elements of the array.
	* 	@example _.first([5, 4, 3, 2, 1]);<br />=> 5
	*/
	public any function first(array = this.obj, n, guard = false) {
		if (structKeyExists(arguments, 'n') && !guard) {
			return _.slice(array, 1, n);
		}
		else {
			return array[1];
		}
	}
	
	/**
	*	@alias first
	*/ 
	public any function head(array, n, guard) {
		return _.first(argumentCollection = arguments);
	}
		
	/**
	*	@alias first
	*/ 
	public any function take(array, n, guard) {
		return _.first(argumentCollection = arguments);
	}
	
	// note: I originally wrote this because I didn't know about CF 10's arraySlice()
	// TODO: replace this with native arraySlice()
	public any function slice(array = [], from = 2, to) {
		var result = [];
		var j = 1;
		var arrLen = arrayLen(array);

		if (!structKeyExists(arguments, 'to')) {
			arguments.to = arrLen;
		}
		else if (to > arrLen) {
			to = arrLen;
		}

		for (var i = from; i <= to; i++) {
			result[j] = array[i];
			j++;
		}
		return result;
	}

	// wrote this for some reason, then didn't end up needing it?
	public any function unshift(obj = this.obj) {
		var elements = _.slice(arguments, 2);
		for (var i = arrayLen(elements); i > 0; i--) {
			arrayPrepend(obj, elements[i]);
		}
		return obj;
	}
	
	/**
	* 	@header _.initial(array, [n]) : array
	*	@hint Returns everything but the last entry of the array. Especially useful on the arguments object. Pass n to exclude the last n elements from the result. Note: CF arrays start at an index of 1
	* 	@example _.initial([5, 4, 3, 2, 1]);<br />=> [5, 4, 3, 2]
	*/
	public array function initial(array = this.obj, n = 1, guard = false) {
		if (guard) {
			var exclude = 1;
		}
		else {
			var exclude = n;
		}
		return _.slice(array, 1, arrayLen(array) - exclude);
	}
	

	/**
	* 	@header _.last(array, [n]) : any
	*	@hint Returns the last element of an array. Passing n will return the last n elements of the array.
	* 	@example _.last([5, 4, 3, 2, 1]);<br />=> 1
	*/
	public any function last(array = this.obj, n, guard = false) {
		if (structKeyExists(arguments,'n') && !guard) {
			return _.slice(array, max(ArrayLen(array) - n + 1, 1));
		} else if (arrayLen(array)) {
			return array[ArrayLen(array)];
		}
		else {
			return JavaCast("null", 0);
		}
	}
	
	/**
	* 	@header _.rest(array, [index]) : array
	*	@hint Returns the rest of the elements in an array. Pass an index to return the values of the array from that index onward.
	* 	@example _.rest([5, 4, 3, 2, 1]);<br />=> [4, 3, 2, 1]
	*/
	public array function rest(array = this.obj, index = 2, guard = false) {
		if (guard) {
			index = 1;
		}
		return _.slice(array, index);
	}
	
	/**
	*	@alias rest
	*/ 
	public array function tail(array, index, guard) {
		return _.rest(argumentCollection = arguments);
	}
	
	/**
	* 	@header _.compact(array) : array
	*	@hint Returns a copy of the array with all falsy values removed. In Coldfusion, false, 0, and "" are all falsy.
	* 	@example _.compact([0, 1, false, 2, '', 3]);<br />=> [1, 2, 3]
	*/
	public array function compact(array = this.obj) {
		return _.filter(array, function(value){ 
			return val(value);
		});
	}
	
	/** 
	* 	@header _.flatten(array, [shallow]) : array 
	*	@hint Flattens a nested array (the nesting can be to any depth). If you pass shallow, the array will only be flattened a single level.
	* 	@example _.flatten([1, [2], [3, [[4]]]]);<br />=> [1, 2, 3, 4];<br /><br />_.flatten([1, [2], [3, [[4]]]], true);<br />=> [1, 2, 3, [[4]]];
	*/
	public array function flatten(array = this.obj, shallow = false) {
		return _.reduce(array, function(memo, value) {
			if (isArray(value)) {
				if (shallow) {
					memo = _.arrayConcat(memo, value);
				}
				else {
					memo = _.arrayConcat(memo, _.flatten(value));
				}
			}
			else {
				var index = arrayLen(memo) + 1;
				memo[index] = value;
			}
			return memo;
		}, []);
	}
	
	// note: this isn't part of UnderscoreJS, but it is missing in Coldfusion
	public array function arrayConcat(array1, array2) {
		var result = [];

		// add all of array1 to result array
		_.each(array1, function(element, index, list) {
			var newIndex = arrayLen(result) + 1;
			result[newIndex] = element;
		});

		// add all of array2 to result array
		_.each(array2, function(element, index, list) {
			var newIndex = arrayLen(result) + 1;
			result[newIndex] = element;
		});

		return result;
	}
	
	/**
	* 	@header _.without(array, [values]) : array 
	*	@hint Returns a copy of the array with all instances of the values removed. 
	* 	@example _.without([1, 2, 1, 0, 3, 1, 4], [0, 1]);<br />=> [2, 3, 4]
	*/
	public array function without(array = this.obj, others = []) {
		return _.difference(array, others);
	}
	
	/**
	* 	@header _.union(*arrays) : array
	*	@hint Computes the union of the passed-in arrays: the list of unique items, in order, that are present in one or more of the arrays.
	* 	@example _.union([1, 2, 3], [101, 2, 1, 10], [2, 1]);<br />=> [1, 2, 3, 101, 10]
	*/
	public array function union() {
		var numArgs = _.size(arguments);
		var arrays = [];
		for(var i = 1; i <= numArgs; i++) {
			arrays[i] = arguments[i];
		}
		return _.uniq(_.flatten(arrays, true));
	}

	/**
	* 	@header _.intersection(*arrays) : array
	*	@hint Computes the list of values that are the intersection of all the arrays. Each value in the result is present in each of the arrays.
	* 	@example _.intersection([1, 2, 3], [101, 2, 1, 10], [2, 1]);<br />=> [1, 2]
	*/
	public array function intersection(array = this.obj) {
		var numArgs = _.size(arguments);
		var args = [];
		for(var i = 1; i <= numArgs; i++) {
			args[i] = arguments[i];
		}
		var rest = _.rest(args);
		return _.filter(_.uniq(array), function(item) {
			return _.every(rest, function(other) {
				return arrayContains(other, item);
			});
		});
	}

	/**
	* 	@alias intersection
	*/ 
	public array function intersect(array) {
		return _.intersection(argumentCollection = arguments);
	}

	/**
	* 	@header _.difference(array, others) : array 
	*	@hint Similar to without, but returns the values from array that are not present in the other arrays.
	* 	@example _.difference([1, 2, 3, 4, 5], [5, 2, 10]);<br />=> [1, 3, 4]
	*/
	public array function difference(array = this.obj, others = []) {
		var rest = _.flatten(others, true);
		return _.filter(array, function(value){
			return !_.include(rest, value);
		});
	}
	
	/**
	* 	@header _.uniq(array, [isSorted], [iterator]) : array
	*	@hint Produces a duplicate-free version of the array. If you know in advance that the array is sorted, passing true for isSorted will run a much faster algorithm. If you want to compute unique items based on a transformation, pass an iterator function.
	* 	@example _.uniq([1, 2, 1, 3, 1, 4]);<br />=> [1, 2, 3, 4]
	*/
	public array function uniq(array = this.obj, isSorted = false, iterator) {
		if (structKeyExists(arguments, 'iterator')) {
			var initial = _.map(array, iterator);
		}
		else {
			var initial = array;
		}
		var results = [];
		
		if (arrayLen(array) < 3) {
			isSorted = true;
		}
		_.reduce(initial, function (memo, value, index) {
			if(isSorted && (_.last(memo) != value || !arrayLen(memo))) {
			    arrayAppend(memo, value);
			    arrayAppend(results, array[index]);
			}
			else if (!isSorted && !_.include(memo, value)) {
			    arrayAppend(memo, value);
			    arrayAppend(results, array[index]);
			}
			return memo;
		}, []);
		return results;
	}
	
	/**
	* 	@header _.zip(*arrays) : array
	*	@hint Merges together the values of each of the arrays with the values at the corresponding position. Useful when you have separate data sources that are coordinated through matching array indexes. If you're working with a matrix of nested arrays, zip.apply can transpose the matrix in a similar fashion.
	* 	@example _.zip(['moe', 'larry', 'curly'], [30, 40, 50], [true, false, false]);<br />=> [["moe", 30, true], ["larry", 40, false], ["curly", 50, false]]
	*/
	public array function zip() {
	    var args = _.slice(arguments, 1);
	    var length = _.max(_.pluck(args, function (array) {
	    		return arrayLen(array);
	    	})
	    );
	    var results = [];
	    for (var i = 1; i <= length; i++) {
	    	results[i] = _.pluck(args, i);
	    }
	    return results;
	}
	
	/**
	* 	@header _.indexOf(array, value, [isSorted]) : numeric
	*	@hint Returns the index at which value can be found in the array, or -1 if value is not present in the array. Uses the native ArrayFind() function. If you're working with a large array, and you know that the array is already sorted, pass true for isSorted to use a faster binary search.
	* 	@example _.indexOf([1, 2, 3], 2);<br />=> 2
	*/
	public numeric function indexOf(array = this.obj, item, isSorted = false) {
		if (isSorted) {
			var i = _.sortedIndex(array, item);
			if (array[i] == item) {
				return i;
			}
			else {
				return -1;
			}
		}
		else {
			return ArrayFind(array, item);
		}
	}
	
	/**
	* 	@header _.lastIndexOf(array, value) : numeric  
	*	@hint Returns the index of the last occurrence of value in the array, or -1 if value is not present. 
	* 	@example _.lastIndexOf([1, 2, 3, 1, 2, 3], 2);<br />=> 5
	*/
	public numeric function lastIndexOf(array = this.obj, item) {
		if (!structKeyExists(arguments, 'array')) {
			return -1;
		}
		for(var i = arrayLen(array); i > 0; i--) {
			if (array[i] == item) {
				return i;
			}
		}
		return -1;
	}
	
	/**
	* 	@header _.range([start], stop, [step]) : array
	*	@hint A function to create flexibly-numbered lists of integers, handy for each and map loops. start, if omitted, defaults to 0; step defaults to 1. Returns a list of integers from start to stop, incremented (or decremented) by step, exclusive.
	* 	@example _.range(10);<br />=> [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]<br />_.range(1, 11);<br />=> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]<br />_.range(0, 30, 5);<br />=> [0, 5, 10, 15, 20, 25]<br />_.range(0, -10, -1);<br />=> [0, -1, -2, -3, -4, -5, -6, -7, -8, -9]<br />_.range(0);<br />=> []
	*/
	public array function range(start = 0, stop, step = 1) {
		if (!structKeyExists(arguments, 'stop')) {
			stop = start;
			start = 0;
		}

	    var len = max(ceiling((stop - start) / step), 0);
	    var idx = 1;
	    var range = [];

	    while(idx <= len) {
			range[idx++] = start;
			start += step;
	    }

		return range;
	}
			
	/**
	* 	@header _.bind(function, object, arguments) : any
	*	@hint Bind a function to a structure, meaning that whenever the function is called, the value of "this" will be the structure. Optionally, bind arguments to the function to pre-fill them, also known as partial application.
	* 	@example "func = function(greeting){ return greeting & ': ' & this.name; };<br />func = _.bind(func, {name : 'moe'}, {greeting: 'hi'});<br />func();<br />=> 'hi: moe'"
	*/
	public any function bind(func, context = {}, args = {}) {
		// TODO: convert arguments after func and context into an arguments struct, rather than forcing the user to pass args as a struct
		return function () {
			return func(argumentCollection = args, this = context);
		};
	}

	/**
	* 	@header _.bindAll(object, [*methodNames]) : any
	*	@hint Bind all of an object's methods to that object. Useful for ensuring that all callbacks defined on an object belong to it.
	* 	@example "buttonView = {label: 'button', onClick : function(){ return 'clicked: ' & this.label; }};<br />_.bindAll(buttonView);<br />buttonView.onClick();<br />=> 'clicked: button'"
	*/
	public any function bindAll(obj) {
		var funcs = _.slice(arguments, 2);
		if (arrayLen(funcs) == 0) {
			funcs = _.functions(obj);
		}
		_.each(funcs, function(f) { 
			var fun =  _.bind(obj[f], obj); 
			obj[f] = fun;
		});
		return obj;
	}
	
	/**
	* 	@header _.memoize(function, [hashFunction]) : any
	*	@hint Memoizes a given function by caching the computed result. Useful for speeding up slow-running computations. If passed an optional hashFunction, it will be used to compute the hash key for storing the result, based on the arguments to the original function. The default hashFunction just uses the first argument to the memoized function as the key.
	* 	@example fibonacci = _.memoize(function(n) {  return n < 2 ? n : fibonacci(n - 1) + fibonacci(n - 2); });
	*/
	public any function memoize(func, hasher) {
		var memo = {};
		if (!structKeyExists(arguments, 'hasher')) {
			arguments.hasher = function(x) {
				return _.first(x);
			};
		}
		return function() {
			var key = hasher(arguments);
			if (!structKeyExists(memo, key)) {
				memo[key] = func(argumentCollection = arguments);
			}
			return memo[key];
		};
	}
	
	/**
	* 	@header _.delay(function, wait, arguments) : any
	*	@hint Delays a function for the given number of milliseconds, and then calls it with the arguments supplied in the args struct.
	* 	@example _.delay(function (msg) {return msg;}, 1000, {msg = "hi"});<br />=> "hi" // appears after one second
  	*/
	public any function delay(func, wait, args) {
		// TODO: make this accept multiple arguments after func and wait, which will get put into an args struct instead of forcing the user to pass arguments as a struct
	    sleep(wait);
	    return arguments.func(argumentCollection = args);
	}
	
	/*
	* 	@header _.defer(function, arguments) : any
	*	@hint Defers a function, scheduling it to run after the current call stack has cleared.
	* 	@example 
	*/
	public any function defer(func, args) {
		// TODO: make sure this works, if it is possible in CF
		return _.delay(func, 0, args);
	}
	
	/*
		Returns a function, that, when invoked, will only be triggered at most once
		during a given window of time.
  	*/
	public any function throttle(func, wait) {
		// TODO
		return;
	}
	
	/*
		Returns a function, that, as long as it continues to be invoked, will not
		be triggered. The function will be called after it stops being called for
		N milliseconds. If `immediate` is passed, trigger the function on the
		leading edge, instead of the trailing.
	*/
	public any function debounce(func, wait, immediate) {
		// TODO
		return;
	}

	/**
	* 	@header _.once(function) : any
	*	@hint Returns a function that will be executed at most one time, no matter how often you call it. Useful for lazy initialization.
	* 	@example i = 0;<br />once = _.once(function () { i = i+1; return i; });<br />once();<br />=> 1<br />once();<br />=> 1
	*/
	public any function once(func) {
		var ran = false; 
		var memo = {};
		return function() {
			if (ran) {
				return memo;
			}
			ran = true;
			memo = func(arguments);
			return memo;
		};
	}

	/**
	* 	@header _.wrap(function, wrapper) : any
	*	@hint Returns the first function passed as an argument to the second, allowing you to adjust arguments, run code before and after, and conditionally execute the original function.
	* 	@example "hello = function(name) { return "hello: " & name; };<br />hello = _.wrap(hello, function(func) {<br />return "before, " & func("moe") & ", after";<br />});<br />hello();<br />=> 'before, hello: moe, after'"
	*/
	public any function wrap(func, wrapper) {
		// TODO make sure this handles arguments correctly
		var args = arguments;
		return function() {
			return wrapper(argumentCollection=arguments, func=args.func);
		};
	}

	/*
		@hint Returns a function that is the composition of a list of functions, each
		consuming the return value of the function that follows.
	*/
	public any function compose() {
		// TODO	
		return;
	}

	/**
	* 	@header _.after(count, function) : any
	*	@hint Returns a function that will only be executed after being called N times.
	* 	@example "func = function () { writeOutput("hi"); };<br />callFuncAfterTwo = _.after(2, func);<br />callFuncAfterTwo();<br />=> // nothing<br />callFuncAfterTwo();<br />=> 'hi'"
	*/
	public any function after(times, func) {
		if (times <= 0) {
			return func();
		}
		return function() {
			if (--times < 1) { 
				return func(arguments); 
			}
		};
	}




	/* OBJECT FUNCTIONS */
	// TODO: stub out all object functions

	/**
	* 	@header _.keys(object) : array
	*	@hint Retrieve all the names of the object's properties.
	* 	@example _.keys({one : 1, two : 2, three : 3});<br />=> ["one", "two", "three"]
	*/
	public array function keys(obj = this.obj) {
		return listToArray(structKeyList(obj));
	}

	/**
	* 	@header _.values(object) : array
	*	@hint Returns true if any of the values in the list pass the iterator truth test. Short-circuits and stops traversing the list if a true element is found. 
	* 	@example _.values({one : 1, two : 2, three : 3});<br />=> [1, 2, 3]
	*/
	public array function values(obj = this.obj) {
		return _.map(obj);
	}
	
	/**
	* 	@header _.functions(object) : array
	*	@hint Returns a sorted array of the names of every method in an object -- that is to say, the name of every function property of the object.
	* 	@example _.functions(_);<br />=> ["all", "any", "bind", "bindAll", "clone", "compact", "compose" ...
	*/
	public array function functions(obj = this.obj) {
		var names = [];
		for (var key in obj) {
			if (_.isFunction(obj[key])) {
				arrayAppend(names, key);
			}
		}
		ArraySort(names, "textnocase");
		return names;
	}

	/**
	* 	@alias functions
	*/ 
	public array function methods() {
		return functions(argumentCollection = arguments);
	}
	
	/**
	* 	@header _.extend(destination, *sources) : any 
	*	@hint Copy all of the properties in the source objects over to the destination object, and return the destination object. It's in-order, so the last source will override properties of the same name in previous arguments.
	* 	@example _.extend({name : 'moe'}, {age : 50});<br />=> {name : 'moe', age : 50}
	*/
	public any function extend(obj = this.obj) {
		_.each(slice(arguments, 2), function(source) {
			for (var prop in source) {
				obj[prop] = source[prop];
			}
		});
		return obj;
	}

	/**
	* 	@header _.pick(object, *keys) : struct
	*	@hint Return a copy of the object, filtered to only have values for the whitelisted keys (or array of valid keys).
	* 	@example _.pick({name : 'moe', age: 50, userid : 'moe1'}, 'name', 'age');<br />=> {name : 'moe', age : 50}
	*/
	public struct function pick(obj = this.obj) {
		var result = {};
		_.each(_.flatten(slice(arguments, 2)), function(key) {
			if (structKeyExists(obj, key)) {
				result[key] = obj[key];
			}
		});
		return result;
	}
	
	/**
	* 	@header _.defaults(object, *defaults) : any
	*	@hint Fill in missing properties in object with default values from the defaults objects, and return the object. As soon as the property is filled, further defaults will have no effect.
	* 	@example iceCream = {flavor : "chocolate"};<br />_.defaults(iceCream, {flavor : "vanilla", sprinkles : "lots"});<br />=> {flavor : "chocolate", sprinkles : "lots"}
	*/
	public any function defaults(obj = this.obj) {
		_.each(_.slice(arguments, 2), function(source) {
			for (var prop in source) {
				if (!structKeyExists(obj, prop)) {
					obj[prop] = source[prop];
				}
			}
		});
		return obj;
	}
		
	/**
	* 	@header _.clone(object) : any
	*	@hint Create a shallow-copied clone of the object. Any nested objects or arrays will be copied by reference, not duplicated (note: this is yet to be tested).
	* 	@example _.clone({name : 'moe'});<br />=> {name : 'moe'}
	*/
	public any function clone(obj = this.obj) {
		// TODO: ensure this adds references to nested objects or arrays...
		if (!_.isObject(obj)) {
			return obj;
		}
		else if (_.isArray(obj)) {
			return _.slice(obj, 1);
		}
		else {
			return _.extend({}, obj);
		}
	}
		
	/*
	* 	@header _.tap(object, interceptor) 
	*	@hint Invokes interceptor with the object, and then returns object. The primary purpose of this method is to "tap into" a method chain, in order to perform operations on intermediate results within the chain.
	* 	@example 
	*/
	// TODO: make this work
	public any function tap(obj = this.obj, interceptor = _.identity) {
		interceptor(obj);
		return obj;
	}
	
	/**
	* 	@header _.has(object, key) : boolean
	*	@hint Does the object contain the given key? Delegates to _.include() for arrays or native structKeyExists() for objects.
	* 	@example _.has({a: 1, b: 2, c: 3}, "b");<br />=> true
	*/
	public boolean function has(obj = this.obj, key) {
		// TODO: implement this better?
		if (isArray(obj)) {
			return _.include(obj, key);
		}
		else if (isObject(obj) || isStruct(obj)) {
			return structKeyExists(obj, key);
		}
		else {
			return _.has(toArray(obj), key);
		}
	}

	/*
	*	@header _.isEqual(object, other) 
	*	@hint Performs an optimized deep comparison between the two objects, to determine if they should be considered equal.
	*	@example moe = {name : 'moe', luckyNumbers : [13, 27, 34]};<br />clone = {name : 'moe', luckyNumbers : [13, 27, 34]};<br />moe == clone;<br />=> false<br />_.isEqual(moe, clone);<br />=> true
	*/
	// TODO: implement this
	public any function isEqual(a = this.obj, b) {
		// return eq(a, b, []);
	}

	/**
	* 	@header _.isEmpty(object) : boolean
	*	@hint Returns true if object contains no values. Delegates ArrayLen for arrays, structIsEmpty() otherwise.
	* 	@example _.isEmpty([1, 2, 3]);<br />=> false<br />_.isEmpty({});<br />=> true
	*/
	public boolean function isEmpty(obj = this.obj) {
		if (isArray(obj)) {
			return (ArrayLen(obj) == 0);
		}	
		else {
			return structIsEmpty(obj);
		}	
	}

	/**
	* 	@header _.isArray(object) : boolean
	*	@hint Returns true if object is an Array. Delegates to native isArray();
	* 	@example _.isArray({one: 1});<br />=> false<br />_.isArray([1,2,3]);<br />=> true
	*/
	public boolean function isArray(obj = this.obj) {
		return isArray(obj);
	}
	
	/** 
	* 	@header _.isObject(object) : boolean
	*	@hint Returns true if value is an Object. Delegates to native isObject()
	* 	@example _.isObject(new Component());<br />=> true <br />_.isObject({});<br />=> false
	*/
	public boolean function isObject(obj = this.obj) {
		return isObject(obj);
	}
	
	/**
	* 	@header _.isFunction(object) : boolean
	*	@hint Returns true if object is a Function.	Delegates to native isClosure()
	* 	@example _.isFunction(function(){return 1;});<br />=> true
	*/	
	public boolean function isFunction(obj = this.obj) {
		// TODO: find a better way to do this in Coldfusion?
		return isClosure(obj);
	}
	
	/**
	* 	@header _.isString(object) : boolean
	*	@hint Returns true if object is a String. 
	* 	@example _.isString("moe");<br />=> true
	*/
	public boolean function isString(obj = this.obj) {
		// Note: There is no isString() is CF, so we use process of elimination.
		return isSimpleValue(obj) && !isBinary(obj) && !isNumeric(obj) && !isBoolean(obj) && !isDate(obj);
	}

	/**
	* 	@header _.isNumber(object) : boolean
	*	@hint Returns true if object is a number. Delegates to native isNumeric()
	* 	@example _.isNumber(8.4 + 5);<br />=> true
	*/
	public boolean function isNumber(obj = this.obj) {
		return isNumeric(obj);
	}
	
	/**
	* 	@header _.isBoolean(object) : boolean
	*	@hint Returns true if object is a boolean. Delegates to native isBoolean()
	* 	@example _.isBoolean(false);<br />=> true
	*/
	public boolean function isBoolean(obj = this.obj) {
		return isBoolean(obj);
	}
	
	/**
	* 	@header _.isDate(object) : boolean
	*	@hint Returns true if object is a date. Delegates to native isDate()
	* 	@example _.isDate(now());<br />=> true
	*/
	public boolean function isDate(obj = this.obj) {
		return isDate(obj);
	}
	
	/*
		Returns true if object is null.
		Compares object to Java null.
	*/
	// TODO: implement this
	public boolean function isNull(obj = this.obj) {
		// return obj == JavaCast("null", 0);
	}
	
	/*
		Returns true if key is undefined in context.
	*/	
	// TODO: determine if this is necessary or rewrite it
	public boolean function isUndefined(variableName, context) {
		return structKeyExists(context, variableName);
	}

	/*
		Returns a wrapped object. Calling methods on this object will continue to return wrapped objects until value is used.
	*/
	// TODO: make this work
	public any function chain(obj) {
		var _obj = new Underscore(obj);
		return _.wrap(_obj, function (func) {
			return new Underscore(func(arguments));
		});
 	}
							
	
	/* UTILITY FUNCTIONS */
	// TODO: stub out all utlity functions
	/*
		Returns the same value that is used as the argument. In math: f(x) = x
		This function looks useless, but is used throughout UnderscoreCF as a default iterator.
	*/
	// pointless: noConflict()
	
	/**
	* 	@header _.times(n, iterator) : void
	*	@hint Invokes the given iterator function n times.
	* 	@example _.times(3, function(){ genie.grantWish(); });
	*/
	public void function times(n, iterator, context) {
		context.iterator = iterator;

		for (var i = 0; i < n; i++) {
			context.iterator(i);
		}
	}
	
	/**
	* 	@header _.mixin(object) : void
	*	@hint Allows you to extend Underscore with your own utility functions. Pass a struct of {name: function} definitions to have your functions added to the Underscore object, <s>as well as the OOP wrapper.</s>
	* 	@example _.mixin({ <br />upper: function(string) { return uCase(string); }<br />});<br />_.upper("fabio");<br />=> "Fabio"'
	*/
	public void function mixin(object) {
		// TODO: make this also work for the OOP wrapper
		_.each(object, function (val, key, obj) {
			_[key] = val;
		});			
	}
	
	/**
	* 	@header _.result(object, property) : any
	*	@hint If the value of the named property is a function then invoke it; otherwise, return it.
	* 	@example 'object = {cheese: 'crumpets', stuff: function(){ return 'nonsense'; }};<br />_.result(object, 'cheese');<br />=> "crumpets"<br />_.result(object, 'stuff');<br />=> "nonsense"'
	*/
	public any function result(object, property) {
		// if (_.isNull(object)) {
		// 	return JavaCast("null", 0);
		// }
		var value = object[property];

		if (_.isFunction(value)) {
			return value(object);
		}
		else {
			return value;
		}
	}

	// useful
	private boolean function toBoolean(obj) {
		return !!obj;
	}
}
