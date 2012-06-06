/** 
* Underscore.cfc
* A port of UnderscoreJS for Coldfusion
*/ 
component { 

	public any function init(obj = {}) { 
		this.obj = obj;

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
	    return this.each(argumentCollection = arguments);
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
 		return this.map(argumentCollection = arguments);
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
 		return this.reduce(argumentCollection = arguments);
 	}
 	
 	// alias of reduce	
  	public any function inject(obj, iterator, memo, context) {
 		return this.reduce(argumentCollection = arguments);
 	}

 	/*
		The right-associative version of reduce. 
 	*/
  	public any function reduceRight(obj = this.obj, iterator = this.identity(), memo, context = new Component()) {
  		// TODO
   	}

   	// alias of reduceRight
 	public any function foldr(obj, iterator, memo, context) {
 		return this.reduceRight(argumentCollection = arguments);
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
 		return this.find(argumentCollection = arguments);
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
		return this.filter(argumentCollection = arguments);
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
		return this.all(argumentCollection = arguments);
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
		return this.any(argumentCollection = arguments);
	}	

	/*
		Returns true if the value is present in the list.
	*/
	public any function include(obj = this.obj, target) {
		return this.any(obj, function(value) {
			return value == target;
		});
	}

	// alias of include. Note: "contains" is a reserved word in CF.
	public any function _contains(obj, target) {
		return this.include(argumentCollection = arguments);
	}


	/*
		Calls the method named by methodName on each value in the list. 
		The args struct passed to invoke will be forwarded on to the method invocation.
	*/
	// TODO: make sure this works right
	public any function invoke(obj = this.obj, method, args = {}) {
	    return this.map(obj, function(value) {
	    	if (this.isFunction(method)) {
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
    	return this.map(obj, function(value){
    		return value[key];
    	});				
	}

	/*
		Returns the maximum value in list. 
		If iterator is passed, it will be used on each value to generate the criterion by which the value is ranked.
	*/
	public any function max(obj = this.obj, iterator = this.identity(), context = new Component()) {
		var result = {};
 		context.iterator = iterator;

	    this.each(obj, function(value, index, obj) {
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

	    this.each(obj, function(value, index, obj) {
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
		if (this.isFunction(val)) {
			var iterator = val;
		}
		else {
			var iterator = function(obj) {
				return obj[val];
			};
		}
 		context.iterator = iterator;
		var toSort = this.map(obj, function(value, index, list, context) {
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
		return this.pluck(sorted, 'value');
	}


	// note: this isn't part of UnderscoreJS, but CF doesn't have a sort() like this
	public any function sort(obj = this.obj, iterator = this.identity) {
		var array = this.toArray(obj);
		// TODO implement an actual sorting mechanism
		this.each(array, function(element, index, list) {
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
		if (this.isFunction(val)) {
			var iterator = val;
		}
		else {
			var iterator = function(obj) { return obj[val]; };
		}
		this.each(obj, function(value, index) {
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
	    this.each(obj, function(value, index, list) {
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
			return this.values(obj);
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
			return this.slice(array, 1, n);
		}
		else {
			return array[1];
		}
	}
	
	// alias of first
	public any function head(array, n, guard) {
		return this.first(argumentCollection = arguments);
	}
		
	// alias of first
	public any function take(array, n, guard) {
		return this.first(argumentCollection = arguments);
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
		return this.slice(array, 1, arrayLen(array) - exclude);
	}
	

	/*
		Returns the last element of an array. Passing n will return the last n elements of the array.
	*/
	public any function last(array = this.obj, n, guard = false) {
		if (structKeyExists(arguments,'n') && !guard) {
			return this.slice(array, max(ArrayLen(array) - n + 1, 1));
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
	public any function rest(array = this.obj, index = 1, guard = false) {
		if (guard) {
			index = 1;
		}
		return this.slice(array, index);
	}
	
	// alias of rest
	public any function tail(array, index, guard) {
		return this.rest(argumentCollection = arguments);
	}
	
	/*
		Returns a copy of the array with all falsy values removed. In Coldfusion, false, 0, and "" are all falsy.
	*/
	public any function compact(array = this.obj) {
		return this.filter(array, function(value){ 
			return val(value);
		});
	}
	
	/* 
		Flattens a nested array (the nesting can be to any depth). If you pass shallow, the array will only be flattened a single level.
	*/
	public any function flatten(array = this.obj, shallow = false) {
		var flatten = this.flatten;
		return this.reduce(array, function(memo, value) {
			if (isArray(value)) {
				if (shallow) {
					memo = arrayConcat(memo, value);
				}
				else {
					memo = arrayConcat(memo, flatten(value));
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
		this.each(array1, function(element, index, list) {
			var newIndex = arrayLen(result) + 1;
			result[newIndex] = element;
		});

		// add all of array2 to result array
		this.each(array2, function(element, index, list) {
			var newIndex = arrayLen(result) + 1;
			result[newIndex] = element;
		});

		return result;
	}
	
	/*
		Returns a copy of the array with all instances of the values removed. 
	*/
	public any function without(array = this.obj, others = []) {
		return this.difference(array, others);
	}
	
	/*
		Computes the union of the passed-in arrays: the list of unique items, in order, that are present in one or more of the arrays.
	*/
	public any function union() {
		var numArgs = this.size(arguments);
		var arrays = [];
		for(var i = 1; i <= numArgs; i++) {
			arrays[i] = arguments[i];
		}
		return this.uniq(this.flatten(arrays, true));
	}

	/*
		Similar to without, but returns the values from array that are not present in the other arrays.
	*/
	public any function difference(array = this.obj, others = []) {
		var rest = this.flatten(others, true);
		var include = this.include;
		return this.filter(array, function(value){
			return !include(rest, value);
		});
	}
	
	/*
		Produces a duplicate-free version of the array.
		If you know in advance that the array is sorted, passing true for isSorted will run a much faster algorithm. 
		If you want to compute unique items based on a transformation, pass an iterator function.
	*/
	public any function uniq(array = this.obj, isSorted = false, iterator) {
		if (structKeyExists(arguments, 'iterator')) {
			var initial = this.map(array, iterator);
		}
		else {
			var initial = array;
		}
		var results = [];
		
		if (arrayLen(array) < 3) {
			isSorted = true;
		}
		var last = this.last;
		var include = this.include;
		this.reduce(initial, function (memo, value, index) {
			if(isSorted && (last(memo) != value || !arrayLen(memo))) {
			    arrayAppend(memo, value);
			    arrayAppend(results, array[index]);
			}
			else if (!isSorted && !include(memo, value)) {
			    arrayAppend(memo, value);
			    arrayAppend(results, array[index]);
			}
			return memo;
		}, []);
		return results;
	}
	
	


	/* OBJECT FUNCTIONS */
	// TODO: stub out all object functions
	/*
		Returns true if any of the values in the list pass the iterator truth test. 
		Short-circuits and stops traversing the list if a true element is found. 
	*/
	public any function values(obj = this.obj) {
		return this.map(obj);
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