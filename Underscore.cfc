/** 
* Underscore.cfc
* A port of UnderscoreJS for Coldfusion
*/ 
component { 

	public any function init(obj = {}) { 
		this.obj = obj;

		variables._ = this;

		return this;
	}


	/* COLLECTION FUNCTIONS (ARRAYS, STRUCTURES, OR OBJECTS) */

	/*
		Iterates over a list of elements, yielding each in turn to an iterator function. 
		The iterator is bound to the context object, if one is passed. 
		Each invocation of iterator is called with three arguments: (element, index, list). 
		If list is an object, iterator's arguments will be (value, key, list). 
	*/
	public any function each(obj = this.obj, iterator = this.identity(), context = new Component()) {
 		context.iterator = iterator;

		if (isArray(obj)) {
			var index = 1;
			for (element in obj) {
				context.iterator(element, index, obj);
				index++;
			}
		}
		else {	
			for (key in obj) {
				var val = obj[key];
				context.iterator(val, key, obj);
			}
		}
 	}

 	// alias of each
	public any function forEach(obj, iterator, context) {
	    return _.each(argumentCollection = arguments);
 	}

	/*
		Produces a new array of values by mapping each value in list through a transformation function (iterator). 
		If list is an object, iterator's arguments will be (value, key, list).
	*/
 	public any function map(obj = this.obj, iterator = this.identity(), context = new Component()) {
 		var result = [];
 		context.iterator = iterator;

		if (isArray(obj)) {
			var index = 1;
			for (element in obj) {
				result[index] = context.iterator(element, index, obj);
				index++;
			}
		}
		else {
			var index = 1;
			for (key in obj) {
				var val = obj[key];
				result[index] = context.iterator(val, key, obj);
				index++;
			}
		}

		return result;
 	}
 	
 	// alias of map
  	public any function collect(obj, iterator, context) {
 		return _.map(argumentCollection = arguments);
 	}

	/*
		Also known as inject and foldl, reduce boils down a list of values into a single value. 
		Memo is the initial state of the reduction, and each successive step of it should be returned by iterator.
	*/
 	public any function reduce(obj = this.obj, iterator = this.identity(), memo, context = new Component()) {
 		context.iterator = iterator;
 		var i = 1;

		if (isArray(obj)) {
			for (num in obj) {
				memo = context.iterator(memo, num, i);
				i++;
			}
		}
		else {
			for (key in obj) {
				var num = obj[key];
				memo = context.iterator(memo, num, i);
				i++;
			}
		}

		return memo;		
 	}
 	
 	// alias of reduce
  	public any function foldl(obj, iterator, memo, context) {
 		return _.reduce(argumentCollection = arguments);
 	}
 	
 	// alias of reduce	
  	public any function inject(obj, iterator, memo, context) {
 		return _.reduce(argumentCollection = arguments);
 	}

 	/*
		The right-associative version of reduce. 
 	*/
  	public any function reduceRight(obj = this.obj, iterator = this.identity(), memo, context = new Component()) {
  		// TODO
   	}

   	// alias of reduceRight
 	public any function foldr(obj, iterator, memo, context) {
 		return _.reduceRight(argumentCollection = arguments);
 	}
 	
 	/*
		Looks through each value in the list, returning the first one that passes a truth test (iterator). 
		The function returns as soon as it finds an acceptable element, and doesn't traverse the entire list.
 	*/
 	public any function find(obj = this.obj, iterator = this.identity(), context = new Component()) { 
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
		else {
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

		return result;
 	}
 	
 	// alias of find
  	public any function detect(obj, iterator, context) { 
 		return _.find(argumentCollection = arguments);
 	}

 	/*
		Looks through each value in the list, returning an array of all the values that pass a truth test (iterator). 
 	*/
 	public any function filter(obj = this.obj, iterator = this.identity(), context = new Component()) {
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
		else {
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

		return result;
 	}

 	// alias of filter
	public any function select(obj, iterator, context) {
		return _.filter(argumentCollection = arguments);
	}
	
	/*
		Returns the values in list without the elements that the truth test (iterator) passes. The opposite of filter.
	*/
	public any function reject(obj = this.obj, iterator = this.identity(), context = new Component()) {
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
		else {
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

		return result;		
	}


	/*
		Returns true if all of the values in the list pass the iterator truth test. 
	*/
	public any function all(obj = this.obj, iterator = this.identity(), context = new Component()) {
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
		else {
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

		return result;		
	}
	
	// alias of all
	public any function every(obj, iterator, context) {
		return _.all(argumentCollection = arguments);
	}
	
	/*
		Returns true if any of the values in the list pass the iterator truth test. 
		Short-circuits and stops traversing the list if a true element is found. 
	*/
	public any function any(obj = this.obj, iterator = this.identity(), context = new Component()) {
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
		else {
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

		return result;
	}
	
	// alias of any
	public any function some(obj, iterator, context) {
		return _.any(argumentCollection = arguments);
	}	

	/*
		Returns true if the value is present in the list.
	*/
	public any function include(obj = this.obj, target) {
		return _.any(obj, function(value) {
			if (!isSimpleValue(value) || !isSimpleValue(target)) {
				return false;
			}
			else {
				return value == target;
			}
		});
	}

	// alias of include. Note: "contains" is a reserved word in CF.
	public any function _contains(obj, target) {
		return _.include(argumentCollection = arguments);
	}


	/*
		Calls the method named by methodName on each value in the list. 
		The args struct passed to invoke will be forwarded on to the method invocation.
	*/
	// TODO: make sure this works right
	public any function invoke(obj = this.obj, method, args = {}) {
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

	/*
		A convenient version of what is perhaps the most common use-case for map: extracting a list of property values.
	*/
	public any function pluck(obj = this.obj, key) {
    	return _.map(obj, function(value){
    		if (_.isFunction(key)) {
    			return key(value);
    		}
    		else {
	    		return value[key];
    		}
    	});				
	}

	/*
		Returns the maximum value in list. 
		If iterator is passed, it will be used on each value to generate the criterion by which the value is ranked.
	*/
	public any function max(obj = this.obj, iterator = this.identity(), context = new Component()) {
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

	/*
		Returns the minimum value in list. 
		If iterator is passed, it will be used on each value to generate the criterion by which the value is ranked.
	*/
	public any function min(obj = this.obj, iterator = this.identity(), context = new Component()) {
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

	/*
		Returns a sorted copy of list, ranked in ascending order by the results of running each value through iterator. 
		Iterator may also be the string name of the property to sort by (eg. length).
	*/
	public any function sortBy(obj, val, context = new Component()) {
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
		var sorted = _.sort(toSort, function(left, right) {
			if (!structKeyExists(left, 'criteria')) {
				return 1;
			}
			else if (!structKeyExists(right, 'criteria')) {
				return -1;
			}
			var a = left.criteria;
			var b = right.criteria;			
			if (a < b) {
				return -1;
			}
			else if (a > b) {
				return 1;
			}
			else {
				return 0;
			}
		});
		return _.pluck(sorted, 'value');
	}


	// note: this isn't part of UnderscoreJS, but CF doesn't have a sort() like this
	public any function sort(obj = this.obj, iterator = this.identity()) {
		var array = _.toArray(obj);
		// TODO implement an actual sorting mechanism
		_.each(array, function(element, index, list) {
			if (ArrayLen(array) > index) {
				var current = array[index];
				var next = array[index+1];

				if (iterator(current, next)) {
					writeOutput("swap: ");
					writeDump(current);
					writeOutput(" with ");
					writeDump(next);
					writeDump(array);
					array[index] = next;
					array[index+1] = current;
				}
			}
		});
		return array;
	}



	/*
		Splits a collection into sets, grouped by the result of running each value through iterator. 
		If iterator is a string instead of a function, groups by the property named by iterator on each of the values.
	*/
	public any function groupBy(obj = this.obj, val) {
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

	/*
		Uses a binary search to determine the index at which the value should be inserted into the list in order to maintain the list's sorted order. 
		If an iterator is passed, it will be used to compute the sort ranking of each value.
	*/
	public any function sortedIndex(array = this.obj, obj, iterator = this.identity()) {
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

	/*
		Returns a shuffled copy of the list, using a version of the Fisher-Yates shuffle.
	*/
	public any function shuffle(obj = this.obj) {
	    var shuffled = obj;
	    var rand = 0;
	    _.each(obj, function(value, index, list) {
			rand = fix(1 + (rand() * (index)));
			shuffled[index] = shuffled[rand];
			shuffled[rand] = value;
	    });
	    return shuffled;		
	}

	/*
		Converts the list (anything that can be iterated over), into a real Array. Useful for transmuting the arguments object.
	*/
	public any function toArray(obj = this.obj) {
		if (isArray(obj)) {
			return obj;
		}
		else if (isObject(obj) || isStruct(obj)) {
			return _.values(obj);
		}
		else {
			// TODO: make sure this is right
			return [];
		}
	}
	
	/*
		Return the number of values in the list.
	*/
	public any function size(obj = this.obj) {
		if (isObject(obj) || isStruct(obj)) {
			return structCount(obj);
		}
		else if (isArray(obj)) {
			return arrayLen(obj);
		}
		else {
			throw "size() is only compatible with objects, structs, and arrays.";
		}
	}

	/* ARRAY FUNCTIONS */

	/*
		Returns the first element of an array. Passing n will return the first n elements of the array.
	*/
	public any function first(array = this.obj, n, guard = false) {
		if (structKeyExists(arguments, 'n') && !guard) {
			return _.slice(array, 1, n);
		}
		else {
			return array[1];
		}
	}
	
	// alias of first
	public any function head(array, n, guard) {
		return _.first(argumentCollection = arguments);
	}
		
	// alias of first
	public any function take(array, n, guard) {
		return _.first(argumentCollection = arguments);
	}
	
	// note: this isn't part of UnderscoreJS, but it is missing in Coldfusion
	public any function slice(array = [], from = 1, to) {
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
	
	/*
		Returns everything but the last entry of the array. Especially useful on the arguments object. 
		Pass n to exclude the last n elements from the result.
	*/
	public any function initial(array = this.obj, n = 1, guard = false) {
		if (guard) {
			var exclude = 1;
		}
		else {
			var exclude = n;
		}
		return _.slice(array, 1, arrayLen(array) - exclude);
	}
	

	/*
		Returns the last element of an array. Passing n will return the last n elements of the array.
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
	
	/*
		Returns the rest of the elements in an array. Pass an index to return the values of the array from that index onward.
	*/
	public any function rest(array = this.obj, index = 2, guard = false) {
		if (guard) {
			index = 1;
		}
		return _.slice(array, index);
	}
	
	// alias of rest
	public any function tail(array, index, guard) {
		return _.rest(argumentCollection = arguments);
	}
	
	/*
		Returns a copy of the array with all falsy values removed. In Coldfusion, false, 0, and "" are all falsy.
	*/
	public any function compact(array = this.obj) {
		return _.filter(array, function(value){ 
			return val(value);
		});
	}
	
	/* 
		Flattens a nested array (the nesting can be to any depth). If you pass shallow, the array will only be flattened a single level.
	*/
	public any function flatten(array = this.obj, shallow = false) {
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
	
	/*
		Returns a copy of the array with all instances of the values removed. 
	*/
	public any function without(array = this.obj, others = []) {
		return _.difference(array, others);
	}
	
	/*
		Computes the union of the passed-in arrays: the list of unique items, in order, that are present in one or more of the arrays.
	*/
	public any function union() {
		var numArgs = _.size(arguments);
		var arrays = [];
		for(var i = 1; i <= numArgs; i++) {
			arrays[i] = arguments[i];
		}
		return _.uniq(_.flatten(arrays, true));
	}

	/*
		Computes the list of values that are the intersection of all the arrays. Each value in the result is present in each of the arrays.
	*/
	public any function intersection(array = this.obj) {
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

	// alias of intersection
	public any function intersect(array) {
		return _.intersection(argumentCollection = arguments);
	}

	/*
		Similar to without, but returns the values from array that are not present in the other arrays.
	*/
	public any function difference(array = this.obj, others = []) {
		var rest = _.flatten(others, true);
		return _.filter(array, function(value){
			return !_.include(rest, value);
		});
	}
	
	/*
		Produces a duplicate-free version of the array.
		If you know in advance that the array is sorted, passing true for isSorted will run a much faster algorithm. 
		If you want to compute unique items based on a transformation, pass an iterator function.
	*/
	public any function uniq(array = this.obj, isSorted = false, iterator) {
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
	
	/*
		Merges together the values of each of the arrays with the values at the corresponding position. 
		Useful when you have separate data sources that are coordinated through matching array indexes. 
		If you're working with a matrix of nested arrays, zip.apply can transpose the matrix in a similar fashion.
	*/
	public any function zip() {
	    var args = _.slice(arguments);
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
	
	
	/*
		Returns the index at which value can be found in the array, or -1 if value is not present in the array. 
		Uses the native ArrayFind() function. 
		TODO: If you're working with a large array, and you know that the array is already sorted, pass true for isSorted to use a faster binary search.
	*/
	public any function indexOf(array = this.obj, item, isSorted = false) {
		// TODO: implement a binary search when isSorted is true 
		return ArrayFind(array, item);
	}
	
	/*
		Returns the index of the last occurrence of value in the array, or -1 if value is not present. 
	*/
	public any function lastIndexOf(array = this.obj, item) {
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
	
	/*
		A function to create flexibly-numbered lists of integers, handy for each and map loops. 
		start, if omitted, defaults to 0; step defaults to 1. 
		Returns a list of integers from start to stop, incremented (or decremented) by step, exclusive.
	*/
	public any function range(start = 0, stop, step = 1) {
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
			
	/*
		Bind a function to a structure, meaning that whenever the function is called, the value of "this" will be the structure. 
		Optionally, bind arguments to the function to pre-fill them, also known as partial application.
	*/
	public any function bind(func, context = {}, args = {}) {
		return function () {
			return func(argumentCollection = args, this = context);
		};
	}

	/*
		Bind all of an object's methods to that object. Useful for ensuring that all callbacks defined on an object belong to it.
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
	
	/*
		Memoizes a given function by caching the computed result. Useful for speeding up slow-running computations. 
		If passed an optional hashFunction, it will be used to compute the hash key for storing the result, based on the arguments to the original function. 
		The default hashFunction just uses the first argument to the memoized function as the key.
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
	
	/*
		Delays a function for the given number of milliseconds, and then calls
		it with the arguments supplied in the args struct.
  	*/
	public any function delay(func, wait, args) {
	    sleep(wait);
	    return arguments.func(argumentCollection=args);
	}
	
	/*
		 Defers a function, scheduling it to run after the current call stack has cleared.
	*/
	public any function defer(func, args) {
		// TODO: make sure this works, if it is possible in CF
		return _.delay(func, 0, args);
	}
	
		


	/* OBJECT FUNCTIONS */
	// TODO: stub out all object functions
	/*
		Returns true if any of the values in the list pass the iterator truth test. 
		Short-circuits and stops traversing the list if a true element is found. 
	*/
	public any function values(obj = this.obj) {
		return _.map(obj);
	}
	

	public any function functions(obj = this.obj) {
		var names = [];
		for (var key in obj) {
			if (_.isFunction(obj[key])) {
				arrayAppend(names, key);
			}
		}
		ArraySort(names, "textnocase");
		return names;
	}


	// TODO: implement this better...
	public any function has(obj = this.obj, key) {

		return _.include(obj, key);
		
	}
	
	

	/*
		Returns true if object is a Function.
	*/	
	// TODO: find a better way to do this in Coldfusion?
	public boolean function isFunction(obj) {
		return isObject(obj);
	}

	// TODO: determine if this is necessary or rewrite it
	public boolean function isUndefined(variableName, context) {
		return structKeyExists(context, variableName);
	}
			
	/* UTILITY FUNCTIONS */
	// TODO: stub out all utlity functions
	/*
		Returns the same value that is used as the argument. In math: f(x) = x
		This function looks useless, but is used throughout UnderscoreCF as a default iterator.
	*/
	public any function identity(value) {
		if (structKeyExists(arguments, 'value'))
			return value;
		else
			return function(val){ return val; };
	}
	
							
}