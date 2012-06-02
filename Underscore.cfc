/** 
* Underscore.cfc
* A port of UnderscoreJS for Coldfusion
*/ 
component { 

	public any function init(obj = {}) { 
		this.obj = obj;

		return this;
	}


	/*
		Iterates over a list of elements, yielding each in turn to an iterator function. 
		The iterator is bound to the context object, if one is passed. 
		Each invocation of iterator is called with three arguments: (element, index, list). 
		If list is an object, iterator's arguments will be (value, key, list). 
		Delegates to the native forEach function if it exists.
	*/
	public any function each(obj = this.obj, iterator = this.identity, context = {}) {
		if (isArray(obj)) {
			var index = 1;
			for (element in obj) {
				iterator(element, index, obj, context);
				index++;
			}
		}
		else {	
			for (key in obj) {
				var val = obj[key];
				iterator(val, key, obj, context);
			}
		}
 	}

 	// alias of each
	public any function forEach(obj, iterator, context) {
	    return this.each(argumentCollection = arguments);
 	}

	/*
		Produces a new array of values by mapping each value in list through a transformation function (iterator). 
		If the native map method exists, it will be used instead. 
		If list is an object, iterator's arguments will be (value, key, list).
	*/
 	public any function map(obj = this.obj, iterator = this.identity, context = {}) {
 		var result = [];

		if (isArray(obj)) {
			var index = 1;
			for (element in obj) {
				result[index] = iterator(element, index, obj);
				index++;
			}
		}
		else {
			var index = 1;
			for (key in obj) {
				var val = obj[key];
				result[index] = iterator(val, key, obj);
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
 	public any function reduce(obj = this.obj, iterator = this.identity, memo, context = {}) {
		if (isArray(obj)) {
			for (num in obj) {
				memo = iterator(memo, num);
			}
		}
		else {
			for (key in obj) {
				var num = obj[key];
				memo = iterator(memo, num);
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
  	public any function reduceRight(obj = this.obj, iterator = this.identity, memo, context = {}) {
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
 	public any function find(obj = this.obj, iterator = this.identity, context = {}) { 
 		var result = 0;

		if (isArray(obj)) {
			var index = 1;
			for (val in obj) {
				if (iterator(val, index, obj)) {
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
				if (iterator(val, index, obj)) {
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
 	public any function filter(obj = this.obj, iterator = this.identity, context = {}) {
		var result = [];

		if (isArray(obj)) {
			var index = 1;
			for (val in obj) {
				var success = iterator(val, index, obj);
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
				var success = iterator(val, index, obj);
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
	public any function reject(obj = this.obj, iterator = this.identity, context = {}) {
		var result = [];

		if (isArray(obj)) {
			var index = 1;
			for (val in obj) {
				var success = iterator(val, index, obj);
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
				var success = iterator(val, index, obj);
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
	public any function all(obj = this.obj, iterator = this.identity, context = {}) {
		var result = false;

		if (isArray(obj)) {
			var index = 1;
			for (val in obj) {
				result = iterator(val, index, obj);
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
				result = iterator(val, index, obj);
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
	public any function any(obj = this.obj, iterator = this.identity, context = {}) {
		var result = false;

		if (isArray(obj)) {
			var index = 1;
			for (value in obj) {
				result = iterator(value, index, obj);
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
				result = iterator(value, index, obj);
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
	public any function max(obj = this.obj, iterator = this.identity, context = {}) {
		var result = {};
	    this.each(obj, function(value, index, obj) {
    		var computed = iterator(value, index, obj, context);
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
	public any function min(obj = this.obj, iterator = this.identity, context = {}) {
		var result = {};
	    this.each(obj, function(value, index, obj) {
    		var computed = iterator(value, index, obj, context);
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
	public any function sortBy(obj, val, context) {
		
	}

	/*
		Splits a collection into sets, grouped by the result of running each value through iterator. 
		If iterator is a string instead of a function, groups by the property named by iterator on each of the values.
	*/
	public any function groupBy(obj, val) {
		
	}

	/*
		Uses a binary search to determine the index at which the value should be inserted into the list in order to maintain the list's sorted order. 
		If an iterator is passed, it will be used to compute the sort ranking of each value.
	*/
	public any function sortedIndex(array, obj, iterator) {
		
	}

	/*
		Returns a shuffled copy of the list, using a version of the Fisher-Yates shuffle.
	*/
	public any function shuffle(obj) {
		
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
	
	
	public any function values(obj) {
		return this.map(obj, this.identity);
	}
	
	

	/*
		Returns the same value that is used as the argument. In math: f(x) = x
		This function looks useless, but is used throughout UnderscoreCF as a default iterator.
	*/
	public any function identity(value) {
		return value;
	}
		
	// TODO: make sure this is right...
	public boolean function isFunction(obj) {
		return isObject(obj);
	}

	// TODO: determine if this is necessary or rewrite it
	public boolean function isUndefined(variableName, context) {
		return structKeyExists(context, variableName);
	}
				
							
}