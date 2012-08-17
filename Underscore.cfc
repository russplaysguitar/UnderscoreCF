/**
* @name Underscore.cfc
* @hint A port of Underscore.js for Coldfusion
* @introduction Underscore.cfc is a port of <a href="http://underscorejs.org">Underscore.js</a> for Coldfusion. It is a utility-belt library that provides a lot of the functional programming support that you would expect in Prototype.js (or Ruby). <br /><br />Underscore.cfc provides dozens of functions that support both the usual functional suspects: map, select, invoke - as well as more specialized helpers: function binding, sorting, deep equality testing, and so on. It delegates to built-in functions where applicable.<br /><br />Underscore.cfc is compatible with Adobe Coldfusion 10 and Railo 4.<br /><br />The project is <a href="http://github.com/russplaysguitar/underscorecf">hosted on GitHub</a>. Contributions are welcome.<br />
*/
component {

	public any function init(obj = {}) {
		this.obj = arguments.obj;

		// _ is referenced throughout this cfc
		variables._ = this;

		// used as the default iterator
		_.identity = function(x) { return x; };

		// for uniqueId
		variables.counter = 1;

		return this;
	}

	/* COLLECTION FUNCTIONS (ARRAYS, STRUCTURES, OR OBJECTS) */

	/**
	* 	@header _.each(collection, iterator, [context]) : void
	*	@hint Iterates over a collection of elements, yielding each in turn to an iterator function. The iterator is bound to the context object (component or struct), if one is passed. Each invocation of iterator is called with three arguments: (element, index, collection, this). If collection is an object/struct, iterator's arguments will be (value, key, collection, this).
	* 	@example _.each([1, 2, 3], function(num){ writeDump(num); }); <br />=> dumps each number in turn... <br />_.each({one : 1, two : 2, three : 3}, function(num, key){ writeDump(num); });<br />=> dumps each number in turn...
	*/
	public void function each(obj = this.obj, iterator = _.identity, this = {}) {

		if (isArray(arguments.obj)) {
			var index = 1;
			for (element in arguments.obj) {
				if (arrayIsDefined(arguments.obj, index)) {
					iterator(element, index, arguments.obj, arguments.this);
				}
				index++;
			}
		}
		else if (isObject(arguments.obj) || isStruct(arguments.obj)) {
			for (key in arguments.obj) {
				var val = arguments.obj[key];
				iterator(val, key, arguments.obj, arguments.this);
			}
		}
		else {
			// query or something else? convert to array and recurse
			_.each(toArray(arguments.obj), iterator, arguments.this);
		}
 	}

 	/**
 	* 	@alias each
 	*/
	public void function forEach(obj, iterator, this) {
		_.each(argumentCollection = arguments);
 	}

	/**
	* 	@header _.map(collection, iterator, [context]) : array
	*	@hint Produces a new array of values by mapping each value in collection through a transformation function (iterator). If collection is an object/struct, iterator's arguments will be (value, key, collection, this).
	* 	@example _.map([1, 2, 3], function(num){ return num * 3; }); <br />=> [3, 6, 9] <br />_.map({one : 1, two : 2, three : 3}, function(num, key){ return num * 3; });<br />=> [3, 6, 9]
	*/
 	public array function map(obj = this.obj, iterator = _.identity, this = {}) {
 		var result = [];

		if (isArray(arguments.obj)) {
			var index = 1;
			var resultIndex = 1;
			for (element in arguments.obj) {
				if (!arrayIsDefined(arguments.obj, index)) {
					index++;
					continue;
				}
				var local = {};
				local.tmp = iterator(element, index, arguments.obj, arguments.this);
				if (structKeyExists(local, "tmp")) {
					result[resultIndex] = local.tmp;
				}
				index++;
				resultIndex++;
			}
		}
		else if (isObject(arguments.obj) || isStruct(arguments.obj)) {
			var index = 1;
			for (key in arguments.obj) {
				var val = arguments.obj[key];
				var local = {};
				local.tmp = iterator(val, key, arguments.obj, arguments.this);
				if (structKeyExists(local, "tmp")) {
					result[index] = local.tmp;
				}
				index++;
			}
		}
		else {
			// query or something else? convert to array and recurse
			result = _.map(toArray(arguments.obj), iterator, arguments.this);
		}

		return result;
 	}

 	/**
 	* 	@alias map
 	*/
  	public array function collect(obj, iterator, this) {
 		return _.map(argumentCollection = arguments);
 	}

	/**
	* 	@header _.reduce(collection, iterator, memo, [context]) : any
	*	@hint Also known as inject and foldl, reduce boils down a collection of values into a single value. Memo is the initial state of the reduction, and each successive step of it should be returned by iterator.
	* 	@example sum = _.reduce([1, 2, 3], function(memo, num){ return memo + num; }, 0);<br />=> 6
	*/
 	public any function reduce(obj = this.obj, iterator = _.identity, memo, this = {}) {

 		var outer = {};
 		if (structKeyExists(arguments, "memo")) {
	 		outer.initial = memo;
 		}
		_.each(arguments.obj, function(value, index, collection, this) {
			if (!structKeyExists(outer, "initial")) {
				memo = value;
				outer.initial = true;
			}
			else {
				memo = iterator(memo, value, index, this);
			}
		}, arguments.this);

		return memo;
 	}

 	/**
 	*	@alias reduce
 	*/
  	public any function foldl(obj, iterator, memo, this) {
 		return _.reduce(argumentCollection = arguments);
 	}

 	/**
 	*	@alias reduce
 	*/
   	public any function inject(obj, iterator, memo, this) {
 		return _.reduce(argumentCollection = arguments);
 	}

 	/**
	*	@header _.reduceRight(collection, [iterator], memo, [context])
	*	@hint The right-associative version of reduce.
	* 	@example list = [[0, 1], [2, 3], [4, 5]];<br />flat = _.reduceRight(list, function(a, b) { return _.concat(a, b); }, []);<br />=> [4, 5, 2, 3, 0, 1]
 	*/
  	public any function reduceRight(obj = this.obj, iterator = _.identity, memo, this = {}) {
		var initial = structKeyExists(arguments, 'memo');
		var reversed = _.reverse(_.toArray(arguments.obj));

		if (!_.isEmpty(this) && !initial) {
			iterator = _.bind(iterator, arguments.this);
		}
		return initial ? _.reduce(reversed, iterator, memo, arguments.this) : _.reduce(reversed, iterator);
   	}

   	// alias of reduceRight
 	public any function foldr(obj, iterator, memo, this) {
 		return _.reduceRight(argumentCollection = arguments);
 	}

 	/* ARRAY FUNCTIONS */

 	/**
	* 	@header _.find(collection, iterator, [context]) : any
	*	@hint Looks through each value in the collection, returning the first one that passes a truth test (iterator). The function returns as soon as it finds an acceptable element, and doesn't traverse the entire collection.
	* 	@example even = _.find([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });<br />=> 2
 	*/
 	public any function find(obj = this.obj, iterator = _.identity, this = {}) {
 		var result = 0;

		if (isArray(arguments.obj)) {
			var index = 1;
			for (val in arguments.obj) {
				if (iterator(val, index, arguments.obj, arguments.this)) {
					result = val;
					break;
				}
				index++;
			}
		}
		else if (isObject(arguments.obj) || isStruct(arguments.obj)) {
			var index  = 1;
			for (key in arguments.obj) {
				var val = arguments.obj[key];
				if (iterator(val, key, arguments.obj, arguments.this)) {
					result = val;
					break;
				}
				index++;
			}
		}
		else {
			// query or something else? convert to array and recurse
			return _.find(toArray(arguments.obj), iterator, arguments.this);
		}

		return result;
 	}

 	/**
 	* 	@alias find
 	*/
  	public any function detect(obj, iterator, this) {
 		return _.find(argumentCollection = arguments);
 	}

 	/**
	* 	@header _.filter(collection, iterator, [context]) : array
	*	@hint Looks through each value in the collection, returning an array of all the values that pass a truth test (iterator).
	* 	@example evens = _.filter([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });<br />=> [2, 4, 6]
 	*/
 	public array function filter(obj = this.obj, iterator = _.identity, this = {}) {
		var result = [];

		if (isArray(arguments.obj)) {
			var index = 1;
			var resultIndex = 1;
			for (val in arguments.obj) {
				var success = iterator(val, index, arguments.obj, arguments.this);
				if (success) {
					result[resultIndex] = val;
					resultIndex++;
				}
				index++;
			}
		}
		else if (isObject(arguments.obj) || isStruct(arguments.obj)) {
			var index = 1;
			var resultIndex = 1;
			for (key in arguments.obj) {
				var val = arguments.obj[key];
				var success = iterator(val, key, arguments.obj, arguments.this);
				if (success) {
					result[resultIndex] = val;
					resultIndex++;
				}
				index++;
			}
		}
		else {
			// query or something else? convert to array and recurse
			return _.filter(toArray(arguments.obj), iterator, arguments.this);
		}

		return result;
 	}

 	/**
 	*	@alias filter
 	*/
	public array function select(obj, iterator, this) {
		return _.filter(argumentCollection = arguments);
	}

	/**
	* 	@header _.reject(collection, iterator, [context]) : array
	*	@hint Returns the values in collection without the elements that the truth test (iterator) passes. The opposite of filter.
	* 	@example odds = _.reject([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });<br />=> [1, 3, 5]
	*/
	public array function reject(obj = this.obj, iterator = _.identity, this = {}) {
		var result = [];

		if (isArray(arguments.obj)) {
			var index = 1;
			var resultIndex = 1;
			for (val in arguments.obj) {
				var success = iterator(val, index, arguments.obj, arguments.this);
				if (!success) {
					result[resultIndex] = val;
					resultIndex++;
				}
				index++;
			}
		}
		else if (isObject(arguments.obj) || isStruct(arguments.obj)) {
			var index = 1;
			var resultIndex = 1;
			for (key in arguments.obj) {
				var val = arguments.obj[key];
				var success = iterator(val, key, arguments.obj, arguments.this);
				if (!success) {
					result[resultIndex] = val;
					resultIndex++;
				}
				index++;
			}
		}
		else {
			// query or something else? convert to array and recurse
			return _.reject(toArray(arguments.obj), iterator, arguments.this);
		}

		return result;
	}


	/**
	* 	@header _.all(collection, iterator, [context]) : boolean
	*	@hint Returns true if all of the values in the collection pass the iterator truth test.
	* 	@example _.all([true, 1, 'no'], _.identity);<br />=> false
	*/
	public boolean function all(obj = this.obj, iterator = _.identity, this = {}) {
		var result = false;

		if (isArray(arguments.obj)) {
			var index = 1;
			for (val in arguments.obj) {
				result = iterator(val, index, arguments.obj, arguments.this);
				if (!result) {
					break;
				}
				index++;
			}
			if (arrayLen(arguments.obj) == 0) {
				result = true;
			}
		}
		else if (isObject(arguments.obj) || isStruct(arguments.obj)) {
			var index  = 1;
			for (key in arguments.obj) {
				var val = arguments.obj[key];
				result = iterator(val, key, arguments.obj, arguments.this);
				if (!result) {
					break;
				}
				index++;
			}
		}
		else {
			return _.all(toArray(arguments.obj), iterator, arguments.this);
		}

		return toBoolean(result);
	}

	/**
	*	@alias all
	*/
	public boolean function every(obj, iterator, this) {
		return _.all(argumentCollection = arguments);
	}

	/**
	* 	@header _.any(collection, [iterator], [context]) : boolean
	*	@hint Returns true if any of the values in the collection pass the iterator truth test. Short-circuits and stops traversing the collection if a true element is found.
	* 	@example _.any([0, 'yes', false]);<br />=> true
	*/
	public boolean function any(obj = this.obj, iterator = _.identity, this = {}) {
		var result = false;

		if (isArray(arguments.obj)) {
			var index = 1;
			for (value in arguments.obj) {
				result = iterator(value, index, arguments.obj, arguments.this);
				if (result) {
					break;
				}
				index++;
			}
		}
		else if (isObject(arguments.obj) || isStruct(arguments.obj)) {
			var index  = 1;
			for (key in arguments.obj) {
				var value = arguments.obj[key];
				result = iterator(value, key, arguments.obj, arguments.this);
				if (result) {
					break;
				}
				index++;
			}
		}
		else {
			return _.any(toArray(arguments.obj), iterator, arguments.this);
		}

		return toBoolean(result);
	}

	/**
	* 	@alias any
	*/
	public boolean function some(obj, iterator, this) {
		return _.any(argumentCollection = arguments);
	}

	/**
	* 	@header _.include(collection, value) : boolean
	*	@hint Returns true if the value is present in the collection.
	* 	@example _.include([1, 2, 3], 3);<br />=> true
	*/
	public boolean function include(obj = this.obj, target) {
		return _.any(arguments.obj, function(value) {
			return isEqual(value, target);
		});
	}

	/**
	* 	@header _.invoke(collection, methodName, [arguments]) : array
	*	@hint Calls the method named by methodName on each value in the collection. The arguments struct passed to invoke will be forwarded on to the method invocation.
	* 	@example _.invoke([{fun: function(){ return 1; }}], 'fun');<br />=> [1]
	*/
	public array function invoke(obj = this.obj, method, args = {}) {
		return _.map(arguments.obj, function(value) {
			if (_.isFunction(method)) {
				// try to call method() directly
				var result = method(value, args);
				if (!isNull(result)) {
					return result;
				}
				else {
					return value;
				}
			}
			else if((isObject(value) || isStruct(value)) && structKeyExists(value, method)) {
				// call method as member of obj item
				var fun = value[method];
				return fun(value, args);
			}
			else {
				// no idea what method() is all about, return value instead
				// note: this might be dangerous
				return value;
			}
		});
	}

	/**
	* 	@header _.pluck(collection, propertyName) : array
	*	@hint A convenient version of what is perhaps the most common use-case for map: extracting a collection of property values.
	* 	@example stooges = [{name : 'moe', age : 40}, {name : 'larry', age : 50}, {name : 'curly', age : 60}];<br />_.pluck(stooges, 'name');<br />=> ["moe", "larry", "curly"]
	*/
	public array function pluck(obj = this.obj, key) {
		return _.map(arguments.obj, function(value){
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
	* 	@header _.max(collection, [iterator], [context]) : any
	*	@hint Returns the maximum value in collection. If iterator is passed, it will be used on each value to generate the criterion by which the value is ranked.
	* 	@example stooges = [{name : 'moe', age : 40}, {name : 'larry', age : 50}, {name : 'curly', age : 60}];<br />_.max(stooges, function(stooge){ return stooge.age; });<br />=> {name : 'curly', age : 60};
	*/
	public any function max(obj = this.obj, iterator = _.identity, this = {}) {
		var result = {};

		_.each(arguments.obj, function(value, index, obj, this) {
			var computed = iterator(value, index, obj, this);
			if (isNumeric(computed)) {
				if (!structKeyExists(result, 'computed') || computed >= result.computed) {
					result = {value : value, computed : computed};
				}
			}
		}, arguments.this);
		if (structKeyExists(result, 'value')) {
			return result.value;
		}
	}

	/**
	* 	@header _.min(collection, [iterator], [context]) : any
	*	@hint Returns the minimum value in collection. If iterator is passed, it will be used on each value to generate the criterion by which the value is ranked.
	* 	@example numbers = [10, 5, 100, 2, 1000];<br />_.min(numbers);<br />=> 2
	*/
	public any function min(obj = this.obj, iterator = _.identity, this = {}) {
		var result = {};

		_.each(arguments.obj, function(value, index, obj, this) {
			var computed = iterator(value, index, obj, this);
			if (isNumeric(computed)) {
				if (!structKeyExists(result, 'computed') || computed <= result.computed) {
					result = {value : value, computed : computed};
				}
			}
		}, arguments.this);
		if (structKeyExists(result, 'value')) {
			return result.value;
		}
	}

	/**
	* 	@header _.sortBy(collection, [iterator], [context]) : array
	*	@hint Returns a sorted copy of collection, ranked in ascending order by the results of running each value through iterator. Iterator may also be the string name of the object key to sort by. Delegates to arraySort().
	* 	@example _.sortBy([6, 2, 4, 3, 5, 1], function(num){ return num; });<br />=> [1, 2, 3, 4, 5, 6]
	*/
	public array function sortBy(obj = this.obj, val, this = {}) {
		if (!structKeyExists(arguments, 'val')) {
			var iterator = _.identity;
		}
		else if (_.isFunction(val)) {
			var iterator = val;
		}
		else {
			var iterator = function(obj) {
				return obj[val];
			};
		}

		var result = _.map(arguments.obj, function(value, index, collection, this) {
			return {
				value : value,
				criteria : iterator(value, index, collection, arguments.this)
			};
		}, arguments.this);

		arraySort(result, function(left, right) {
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

		return _.pluck(result, 'value');
	}

	// default comparator for merge()
	public numeric function comparison(left, right) {
		if(!isSimpleValue(left) || !isSimpleValue(right))
			return 0;// can't compare non-simple values
		else if(left == right)
			return 0;
		else if(left < right)
			return -1;
		else
			return 1;
	}

	/**
	* 	@header _.groupBy(collection, iterator) : struct
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
		_.each(arguments.obj, function(value, index) {
			var key = iterator(value, index);
			if (!structKeyExists(result, key)) {
				result[key] = [];
			}
			arrayAppend(result[key], value);
		});
		return result;
	}

	/**
	* 	@header _.sortedIndex(collection, value, [iterator]) : numeric
	*	@hint Uses a binary search to determine the index at which the value should be inserted into the collection in order to maintain the collection's sorted order. If an iterator is passed, it will be used to compute the sort ranking of each value.
	* 	@example _.sortedIndex([10, 20, 30, 40, 50], 35);<br />=> 4
	*/
	public numeric function sortedIndex(array = this.obj, obj, iterator = _.identity) {
		var low = 0;
		var high = arrayLen(array);
		while (low < high) {
			var mid = BitSHRN((low + high), 1);
			if (iterator(array[mid]) < iterator(arguments.obj) ) {
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
		var shuffled = duplicate(arguments.obj);
		var rand = 0;
		_.each(shuffled, function(value, index, collection) {
			rand = fix(1 + (rand() * (index)));
			shuffled[index] = shuffled[rand];
			shuffled[rand] = value;
		});
		return shuffled;
	}

	/**
	*	@header _.toArray(collection) : array
	*	@hint Converts the collection (object, struct, query, or cf-list), into an array. Useful for transmuting the arguments object.
	* 	@example _.toArray({a:10,b:20});<br />=> [10, 20]
	*/
	public array function toArray(obj = this.obj) {
		if (isArray(arguments.obj)) {
			return duplicate(arguments.obj);
		}
		else if ((isStruct(arguments.obj) || isObject(arguments.obj)) && structKeyExists(arguments.obj, "toArray") && isClosure(arguments.obj.toArray)) {
			return arguments.obj.toArray();
		}
		else if (isQuery(arguments.obj)) {
			var result = [];
			for (index = 1; index <= arguments.obj.RecordCount; index++) {
				var row = {};
				for (var colName in arguments.obj.columnList) {
					row[colName] = arguments.obj[colName][index];
				}
				result[index] = row;
			}
			return result;
		}
		else if (isObject(arguments.obj) || isStruct(arguments.obj)) {
			return _.values(arguments.obj);
		}
		else if (_.isString(arguments.obj)) {
			return listToArray(arguments.obj);
		}
		else
		{
			return [arguments.obj];
		}
	}

	/**
	* 	@header _.size(collection) : numeric
	*	@hint Return the number of values in the collection.
	* 	@example _.size({one : 1, two : 2, three : 3});<br />=> 3
	*/
	public numeric function size(obj = this.obj) {
		if (isObject(arguments.obj) || isStruct(arguments.obj)) {
			return structCount(arguments.obj);
		}
		else if (isArray(arguments.obj)) {
			return arrayLen(arguments.obj);
		}
		else if (isQuery(arguments.obj)) {
			return arguments.obj.recordCount;
		}
		else {
			throw("size() is only compatible with objects, structs, queries, and arrays.", "Underscore");
		}
	}

	/* ARRAY FUNCTIONS */

	/**
	* 	@header _.first(array, [n]) : any
	*	@hint Returns the first element of an array. Passing n will return the first n elements of the array.
	* 	@example _.first([5, 4, 3, 2, 1]);<br />=> 5
	*/
	public any function first(array array = this.obj, n, guard = false) {
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

	// TODO: write a shift() method and add it with unshift() to Underscore.cfc
	// wrote this for some reason, then didn't end up needing it?
	// public any function unshift(obj = this.obj) {
	// 	var elements = _.slice(arguments, 2);
	// 	for (var i = arrayLen(elements); i > 0; i--) {
	// 		arrayPrepend(obj, elements[i]);
	// 	}
	// 	return obj;
	// }

	/**
	* 	@header _.initial(array, [n]) : array
	*	@hint Returns everything but the last entry of the array. Especially useful on the arguments object. Pass n to exclude the last n elements from the result. Note: CF arrays start at an index of 1
	* 	@example _.initial([5, 4, 3, 2, 1]);<br />=> [5, 4, 3, 2]
	*/
	public array function initial(array array = this.obj, n = 1, guard = false) {
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
	public any function last(array array = this.obj, n, guard = false) {
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
	public array function rest(array array = this.obj, index = 2, guard = false) {
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
	public array function compact(array array = this.obj) {
		return _.filter(array, function(value){
			return val(value);
		});
	}

	/**
	* 	@header _.flatten(array, [shallow]) : array
	*	@hint Flattens a nested array (the nesting can be to any depth). If you pass shallow, the array will only be flattened a single level.
	* 	@example _.flatten([1, [2], [3, [[4]]]]);<br />=> [1, 2, 3, 4];<br /><br />_.flatten([1, [2], [3, [[4]]]], true);<br />=> [1, 2, 3, [[4]]];
	*/
	public array function flatten(array array = this.obj, shallow = false) {
		return _.reduce(array, function(memo, value) {
			if (isArray(value)) {
				if (shallow) {
					memo = _.concat(memo, value);
				}
				else {
					memo = _.concat(memo, _.flatten(value));
				}
			}
			else {
				var index = arrayLen(memo) + 1;
				memo[index] = value;
			}
			return memo;
		}, []);
	}

	/**
	* 	@header _.concat(array1, array2) : array
	* 	@hint Concatenates two arrays together an returns the result. Delegates to ArrayAppend().
	* 	@example _.concat([1, 2, 3],[4, 5, 6]);<br />=> [1, 2, 3, 4, 5, 6];
	*/
	public array function concat(array array1 = [], array array2 = []) {
		var result = [];

		ArrayAppend(result, array1, true);
		ArrayAppend(result, array2, true);

		return result;
	}

 	/**
 	* 	@header _.reverse(array) : array
 	* 	@hint Returns a copy of the array in reverse order.
 	* 	@example _.reverse([1, 2, 3]);<br />=> [3, 2, 1]
 	*/
 	public array function reverse(array obj = this.obj) {
 		var result = [];
 		var size = _.size(arguments.obj);
 		var i = size;

 		_.each(arguments.obj, function(val) {
 			result[i] = val;
 			i--;
 		});

 		return result;
 	}

	/**
	* 	@header _.takeWhile(array) : array
	* 	@hint Appends values to a new array as long as the iterator is true.
	* 	@example _.takeWhile([1, 2, 3, 4, 1, 2], function(val) { return val < 3; });<br />=> [1, 2]
	*/
 	public array function takeWhile(array array = this.obj, iterator = _.identity, this = {}) {
 		var result = [];
 		for(val in arguments.array) {
 			if (!iterator(val)) {
 				break;
 			}
 			ArrayAppend(result, val);
 		}
 		return result;
 	}

 	/**
 	* 	@header _.splice(array, index, howMany, [*items]) : array
 	* 	@hint Returns a copy of the array with howMany elements removed. Optionally inserts items at the index. Note: differs from Javascript splice() in that it does not return the removed elements.
 	* 	@example _.splice([10, 90, 30], 2, 2);<br /> => [10]<br />_.splice([10, 90, 30], 2, 1, 20);<br /> => [10, 20, 30]
 	*/
 	public array function splice(array array = this.obj, required numeric index, required numeric howMany) {
 		var items = arrayLen(arguments) > 3 && isArray(arguments[4]) ? arguments[4] : _.slice(arguments, 4);

 		if (index < 1) {
 			// negative indices mean position from end of array
 			index = arrayLen(array) + index;
 		}

 		var left = _.slice(array, 1, index - 1);
 		var right = _.slice(array, index + howMany);

 		var result = [];

 		arrayAppend(result, left, true);
 		arrayAppend(result, items, true);
 		arrayAppend(result, right, true);

 		return result;
 	}

	/**
	* 	@header _.without(array, [values]) : array
	*	@hint Returns a copy of the array with all instances of the values removed.
	* 	@example _.without([1, 2, 1, 0, 3, 1, 4], [0, 1]);<br />=> [2, 3, 4]
	*/
	public array function without(array array = this.obj, others = []) {
		return _.difference(array, others);
	}

	/**
	* 	@header _.union(*arrays) : array
	*	@hint Computes the union of the passed-in arrays: the collection of unique items, in order, that are present in one or more of the arrays.
	* 	@example _.union([1, 2, 3], [101, 2, 1, 10], [2, 1]);<br />=> [1, 2, 3, 101, 10]
	*/
	public array function union() {
		var numArgs = _.size(arguments);
		var arrays = [];
		for(var i = 1; i <= numArgs; i++) {
			if (!isArray(arguments[i])) {
				throw("Cannot union() non-array collections","Underscore");
			}
			arrays[i] = arguments[i];
		}
		return _.uniq(_.flatten(arrays, true));
	}

	/**
	* 	@header _.intersection(*arrays) : array
	*	@hint Computes the collection of values that are the intersection of all the arrays. Each value in the result is present in each of the arrays.
	* 	@example _.intersection([1, 2, 3], [101, 2, 1, 10], [2, 1]);<br />=> [1, 2]
	*/
	public array function intersection(array array = this.obj) {
		var numArgs = _.size(arguments);
		var args = [];
		for(var i = 1; i <= numArgs; i++) {
			if (!isArray(arguments[i])) {
				throw("Cannot intersection() non-array collections","Underscore");
			}
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
	public array function difference(array array = this.obj, others = []) {
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
	public array function uniq(array array = this.obj, isSorted = false, iterator) {
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
				if (!isArray(array)) {
					throw("Cannot zip() non-array collections","Underscore");
				}
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
	*	@hint Returns the index at which value can be found in the array, or 0 if value is not present in the array. Uses the native ArrayFind() function. If you're working with a large array, and you know that the array is already sorted, pass true for isSorted to use a faster binary search.
	* 	@example _.indexOf([1, 2, 3], 2);<br />=> 2
	*/
	public numeric function indexOf(array array = this.obj, item, isSorted = false) {
		if (isSorted) {
			var i = _.sortedIndex(array, item);
			if (array[i] == item) {
				return i;
			}
			else {
				return 0;
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
	public numeric function lastIndexOf(array array = this.obj, item) {
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
	*	@hint A function to create flexibly-numbered arrays of integers, handy for each and map loops. start, if omitted, defaults to 0; step defaults to 1. Returns an array of integers from start to stop, incremented (or decremented) by step, exclusive.
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

	/* FUNCTION FUNCTIONS */

	/**
	* 	@header _.bind(function, object, [*arguments]) : any
	*	@hint Bind a function to a structure, meaning that whenever the function is called, the value of "this" will be the structure. Optionally, bind arguments to the function to pre-fill them, also known as partial application.
	* 	@example "func = function(args, this){ return args.greeting & ': ' & this.name; };<br />func = _.bind(func, {name : 'moe'}, {greeting: 'hi'});<br />func();<br />=> 'hi: moe'"
	*/
	public any function bind(func, context = {}) {
		var boundArgs = _.slice(arguments, 3);

		if (!_.isFunction(func)) {
			throw("bind() expected a function", "Underscore");
		}

		return function () {
			var argStruct = {};
			if (arrayLen(boundArgs) > 0) {
				var passedArgs = _.toArray(arguments);
				var argsArray = _.concat(boundArgs, passedArgs);
				_.each(argsArray, function (val, index) {
					argStruct[index] = val;
				});
			}
			else {
				argStruct = arguments;
			}
			argStruct.this = context;
			return func(argumentCollection = argStruct);
		};
	}

	/**
	* 	@header _.bindAll(object, [*methodNames]) : any
	*	@hint Bind all of an object's methods to that object. Useful for ensuring that all callbacks defined on an object belong to it.
	* 	@example "greeter = {hello: 'Hello, ', greet: function(this){ return this.hello & 'World!'; }};<br />_.bindAll(greeter);<br />greeter.greet();<br />=> 'Hello, World!'"
	*/
	public any function bindAll(obj) {
		var local.obj = arguments.obj;
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
				return _.first(_.toArray(x));
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
		var local.func = arguments.func;
		return local.func(argumentCollection = args);
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
		// TODO: in progress
		// var lastInvokeTime = GetTickCount();
		// return function () {
		// 	var thisInvokeTime = GetTickCount();
		// 	if (thisInvokeTime - lastInvokeTime > wait) {
		// 		func();
		// 	}
		// 	else {
		// 	}
		// 	lastInvokeTime = GetTickCount();
		// };
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
				if (!isNull(memo)) {
					return memo;
				}
				else {
					return;
				}
			}
			ran = true;
			memo = func(arguments);
			if (!isNull(memo)) {
				return memo;
			}
		};
	}

	/**
	* 	@header _.wrap(function, wrapper) : any
	*	@hint Returns the first function passed as an argument to the second, allowing you to adjust arguments, run code before and after, and conditionally execute the original function.
	* 	@example "hello = function(name) { return "hello: " & name; };<br />hello = _.wrap(hello, function(func) {<br />return "before, " & func("moe") & ", after";<br />});<br />hello();<br />=> 'before, hello: moe, after'"
	*/
	public any function wrap(func, wrapper) {
		// TODO make sure this handles arguments correctly
		return function() {
			arguments.func = func;
			return wrapper(argumentCollection = arguments);
		};
	}

	/**
	* 	@header _.compose(*functions) : any
	*	@hint Returns a function that is the composition of a list of functions, each function consumes the return value of the function that follows. In math terms, composing the functions f(), g(), and h() produces f(g(h())).
	*	@example greet	= function(name){ return "hi: " & name; };<br />exclaim  = function(statement){ return statement & "!"; };<br />welcome = _.compose(exclaim, greet);<br />welcome('moe');<br />=> 'hi: moe!';
	*/
	public any function compose() {
		var funcs = arguments;
		return function() {
			var args = arguments;
			for (var i = _.size(funcs); i >= 1; i--) {
				var toCall = funcs[i];
				var result = toCall(argumentCollection = args);
				args = {1:result};
			}
			return args[1];
		};
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

	/**
	* 	@header _.keys(object) : array
	*	@hint Retrieve all the names of the object's properties.
	* 	@example _.keys({one : 1, two : 2, three : 3});<br />=> ["one", "two", "three"]
	*/
	public array function keys(obj = this.obj) {
		if (isArray(arguments.obj)) {
			return _.map(arguments.obj, function(v,i){
				return i;
			});
		}
		else if (isStruct(arguments.obj) || isObject(arguments.obj)) {
			return listToArray(structKeyList(arguments.obj));
		}
		else if (isQuery(arguments.obj)) {
			return _.keys(toArray(arguments.obj));
		}
		else {
			throw("keys() expects an array, object, struct, or query", "Underscore");
		}
	}

	/**
	* 	@header _.values(object) : array
	*	@hint Returns true if any of the values in the object pass the iterator truth test. Short-circuits and stops traversing the object if a true element is found.
	* 	@example _.values({one : 1, two : 2, three : 3});<br />=> [1, 2, 3]
	*/
	public array function values(obj = this.obj) {
		return _.map(arguments.obj);
	}

	/**
	* 	@header _.functions(object) : array
	*	@hint Returns a sorted array of the names of every method in an object -- that is to say, the name of every function property of the object.
	* 	@example _.functions(_);<br />=> ["all", "any", "bind", "bindAll", "clone", "compact", "compose" ...
	*/
	public array function functions(obj = this.obj) {
		var names = [];
		for (var key in arguments.obj) {
			if (_.isFunction(arguments.obj[key])) {
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
		var local.obj = arguments.obj;
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
		var local.obj = arguments.obj;
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
		var local.obj = arguments.obj;
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
	*	@hint Create a shallow-copied clone of the object. Any nested structs or objects will be copied by reference, not duplicated.
	* 	@example _.clone({name : 'moe'});<br />=> {name : 'moe'}
	*/
	public any function clone(obj = this.obj) {
		if (isSimpleValue(arguments.obj)) {
			return arguments.obj;
		}
		else if (isArray(arguments.obj)) {
			return _.slice(arguments.obj, 1);
		}
		else if (isObject(arguments.obj)) {
			var metaData = getMetaData(arguments.obj);
			return _.extend(new "#metaData.fullName#"(), structCopy(arguments.obj));
		}
		else if (isStruct(arguments.obj)) {
			return structCopy(arguments.obj);
		}
		else {
			throw("Can only clone simple, array, object, or struct types", "Underscore");
		}
	}

	/*
	* 	@header _.tap(object, interceptor)
	*	@hint Invokes interceptor with the object, and then returns object. The primary purpose of this method is to "tap into" a method chain, in order to perform operations on intermediate results within the chain.
	* 	@example
	*/
	// TODO: make this work
	public any function tap(obj = this.obj, interceptor = _.identity) {
		interceptor(arguments.obj);
		return arguments.obj;
	}

	/**
	* 	@header _.has(object, key) : boolean
	*	@hint Does the object contain the given key? Delegates to _.include() for arrays or native structKeyExists() for objects.
	* 	@example _.has({a: 1, b: 2, c: 3}, "b");<br />=> true
	*/
	public boolean function has(obj = this.obj, key) {
		// TODO: implement this better?
		if (isArray(arguments.obj)) {
			return _.include(arguments.obj, key);
		}
		else if (isObject(arguments.obj) || isStruct(arguments.obj) || isXml(arguments.obj)) {
			return structKeyExists(arguments.obj, key);
		}
		else {
			return _.has(toArray(arguments.obj), key);
		}
	}

	/**
	*	@header _.isEqual(object, other)
	*	@hint Performs a deep comparison between the two objects, to determine if they should be considered equal.
	*	@example moe = {name : 'moe', luckyNumbers : [13, 27, 34]};<br />clone = {name : 'moe', luckyNumbers : [13, 27, 34]};<br />_.isEqual(moe, clone);<br />=> true
	*/
	public any function isEqual(a = this.obj, b) {
		var result = true;

		// returns true if a is equal to b
		var compareSimple = function(required a, required b) {
			var aIsString = _.isString(a);
			var bIsString = _.isString(b);

			if (aIsString && bIsString) {
				return (compare(a, b) == 0);
			}
			else {
				return (a == b);
			}
		};

		if (isSimpleValue(a) && isSimpleValue(b)) {
			result = compareSimple(a, b);
			return result;
		}

		// returns true if a's type is equal to b's type
		var compareTypes = function (required a, required b) {
			// note: order matters here since some types count as other types
			if (isArray(a) && isArray(b)) {
				return true;
			}
			else if (isObject(a) && isObject(b)) {
				return true;
			}
			else if (isStruct(a) && isStruct(b)) {
				return true;
			}
			else if (isQuery(a) && isQuery(b)) {
				return true;
			}
			else if (isDate(a) && isDate(b)) {
				return true;
			}
			else if (isBinary(a) && isBinary(b)) {
				return true;
			}
			else if (_.isFunction(a) && isFunction(b)) {
				return true;
			}
			else if (_.isNumber(a) && _.isNumber(b)) {
				return true;
			}
			else if (_.isString(a) && _.isString(b)) {
				return true;
			}
			else if (isBoolean(a) && isBoolean(b)) {
				return true;
			}
			else {
				return false;
			}
		};

		if (!compareTypes(a, b)) {
			// don't bother comparing if the types don't even match
			return false;
		}

		// return a.equals(b) && b.equals(a);

		if (isArray(a) && arrayLen(a) != arrayLen(b)) {
			return false;
		}

		if (_.isFunction(a) || _.isFunction(b)) {
			var a_meta = getMetaData(a);
			var b_meta = getMetaData(b);
			return _.isEqual(a_meta.parameters, b_meta.parameters);
		}

		var iterator = function (v, k) {
			if (isSimpleValue(o) || (isStruct(o) && !structKeyExists(o, k)) || (isArray(o) && arrayLen(o) < k)) {
				result = false;
				return;
			}
			var other = o[k];
			if (!isSimpleValue(v)) {
				if (!_.isEqual(v, other)) {
					result = false;
					return;
				}
			}
			else if (isSimpleValue(other)) {
				if (!compareSimple(v, other)) {
					result = false;
					return;
				}
			}
			else {
				result = false;
				return;
			}
		};

		var o = b;
		_.each(a, iterator);

		var o = a;
		_.each(b, iterator);

		return result;
	}

	/**
	* 	@header _.isEmpty(object) : boolean
	*	@hint Returns true if object contains no values. Delegates to ArrayLen for arrays, structIsEmpty() otherwise.
	* 	@example _.isEmpty([1, 2, 3]);<br />=> false<br />_.isEmpty({});<br />=> true
	*/
	public boolean function isEmpty(obj = this.obj) {
		if (isArray(arguments.obj)) {
			return (ArrayLen(arguments.obj) == 0);
		}
		else if (isStruct(arguments.obj)) {
			return structIsEmpty(arguments.obj);
		}
		else if (_.isString(arguments.obj)) {
			return (len(arguments.obj) == 0);
		}
		else {
			throw("isEmpty() error: Not sure what obj is", "Underscore");
		}
	}

	/**
	* 	@header _.isArray(object) : boolean
	*	@hint Returns true if object is an Array. Delegates to native isArray();
	* 	@example _.isArray({one: 1});<br />=> false<br />_.isArray([1,2,3]);<br />=> true
	*/
	public boolean function isArray(obj = this.obj) {
		return isArray(arguments.obj);
	}

	/**
	* 	@header _.isObject(object) : boolean
	*	@hint Returns true if value is an Object. Delegates to native isObject()
	* 	@example _.isObject(new Component());<br />=> true <br />_.isObject({});<br />=> false
	*/
	public boolean function isObject(obj = this.obj) {
		return isObject(arguments.obj);
	}

	/**
	* 	@header _.isFunction(object) : boolean
	*	@hint Returns true if object is a Function.	Delegates to native isClosure() || isCustomFunction()
	* 	@example _.isFunction(function(){return 1;});<br />=> true
	*/
	public boolean function isFunction(obj = this.obj) {
		return isClosure(arguments.obj) || isCustomFunction(arguments.obj);
	}

	/**
	* 	@header _.isString(object) : boolean
	*	@hint Returns true if object is a String. Uses Java String type comparison.
	* 	@example _.isString("moe");<br />=> true<br />_.isString(1);<br />=> true//Coldfusion converts numbers to strings
	*/
	public boolean function isString(obj = this.obj) {
		return isInstanceOf(arguments.obj, "java.lang.String");
	}

	/**
	* 	@header _.isNumber(object) : boolean
	*	@hint Returns true if object is of a Java numeric type.
	* 	@example _.isNumber(1);<br />=> false//Coldfusion converts numbers to strings<br />_.isNumber(JavaCast("int", 1));<br />=> true
	*/
	public boolean function isNumber(obj = this.obj) {
		return isInstanceOf(arguments.obj, "java.lang.Integer") || isInstanceOf(arguments.obj, "java.lang.Short") ||
			isInstanceOf(arguments.obj, "java.lang.Long") || isInstanceOf(arguments.obj, "java.lang.Double") ||
			isInstanceOf(arguments.obj, "java.lang.Float");
	}

	/**
	* 	@header _.isBoolean(object) : boolean
	*	@hint Returns true if object is a boolean. Delegates to native isBoolean()
	* 	@example _.isBoolean(false);<br />=> true
	*/
	public boolean function isBoolean(obj = this.obj) {
		// note: I considered making this test for java-casted booleans, but since Adobe CF functions don't return them, it would be counter-productive.
		return isBoolean(arguments.obj);
	}

	/**
	* 	@header _.isDate(object) : boolean
	*	@hint Returns true if object is a date. Delegates to native isDate()
	* 	@example _.isDate(now());<br />=> true
	*/
	public boolean function isDate(obj = this.obj) {
		return isDate(arguments.obj);
	}

	/*
		Returns a wrapped object. Calling methods on this object will continue to return wrapped objects until value is used.
	*/
	// TODO: make this work
	public any function chain(obj) {
		var _obj = new Underscore(arguments.obj);
		return _.wrap(_obj, function (func) {
			return new Underscore(func(arguments));
		});
 	}


	/* UTILITY FUNCTIONS */
	/*
		Returns the same value that is used as the argument. In math: f(x) = x
		This function looks useless, but is used throughout UnderscoreCF as a default iterator.
	*/

	/**
	* 	@header _.times(n, iterator) : void
	*	@hint Invokes the given iterator function n times.
	* 	@example _.times(3, function(){ genie.grantWish(); });
	*/
	public void function times(required n, required iterator, this = {}) {
		for (var i = 0; i < n; i++) {
			iterator(i, arguments.this);
		}
	}

	/**
	* 	@header _.mixin(object) : void
	*	@hint Allows you to extend Underscore with your own utility functions. Pass a struct of {name: function} definitions to have your functions added to the Underscore object, <s>as well as the OOP wrapper.</s>
	* 	@example _.mixin({ <br />upper: function(string) { return uCase(string); }<br />});<br />_.upper("fabio");<br />=> "Fabio"'
	*/
	public void function mixin(required object) {
		// TODO: make this also work for the OOP wrapper
		_.each(arguments.object, function (val, key, obj) {
			_[key] = val;
		});
	}

	/**
	* 	@header _.uniqueId([prefix]) : string
	* 	@hint Generates an identifier that is unique for this instance of Backbone
	* 	@example _.uniqueId('c');<br /> => 'c1'
	*/
	public string function uniqueId(prefix = '') {
		var result = prefix & variables.counter;
		variables.counter++;
		return result;
	}

	/**
	* 	@header _.escape(input) : string
	* 	@hint Escapes a string for insertion into HTML, replacing &, <, >, and " characters.
	* 	@example _.escape('Curly, Larry & Moe');<br /> => "Curly, Larry &amp; Moe"
	*/
	public string function escape(required string input) {
		return HTMLeditFormat(input);
	}

	/**
	* 	@header _.result(object, property) : any
	*	@hint If the value of the named property is a function then invoke it; otherwise, return it.
	* 	@example 'object = {cheese: 'crumpets', stuff: function(){ return 'nonsense'; }};<br />_.result(object, 'cheese');<br />=> "crumpets"<br />_.result(object, 'stuff');<br />=> "nonsense"'
	*/
	public any function result(object = this.obj, required property) {
		var value = arguments.object[arguments.property];

		if (_.isFunction(value)) {
			return value(arguments.object);
		}
		else {
			return value;
		}
	}

	/*
	* 	@hint Internal helper function. Converts boolean equivalents to boolean true or false. Helpful for keeping function return values consistent.
	*/
	private boolean function toBoolean(required obj) {
		return !!arguments.obj;
	}
}