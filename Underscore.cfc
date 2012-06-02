/** 
* Underscore.cfc
* A port of UnderscoreJS for Coldfusion
*/ 
component { 

	public any function init(obj = {}) { 
		this.obj = obj;

		return this;
	}


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

	public any function forEach(obj, iterator, context) {
	    return this.each(argumentCollection = arguments);
 	}


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
 	
  	public any function collect(obj, iterator, context) {
 		return this.map(argumentCollection = arguments);
 	}


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
 	
  	public any function foldl(obj, iterator, memo, context) {
 		return this.reduce(argumentCollection = arguments);
 	}
 		
  	public any function inject(obj, iterator, memo, context) {
 		return this.reduce(argumentCollection = arguments);
 	}


  	public any function reduceRight(obj = this.obj, iterator = this.identity, memo, context = {}) {
  		// TODO
   	}

 	public any function folr(obj, iterator, memo, context) {
 		return this.reduceRight(argumentCollection = arguments);
 	}
 	
 	
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
 	
  	public any function detect(obj, iterator, context) { 
 		return this.find(argumentCollection = arguments);
 	}


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

	public any function select(obj, iterator, context) {
		return this.filter(argumentCollection = arguments);
	}
	

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
	
	public any function every(obj, iterator, context) {
		return this.all(argumentCollection = arguments);
	}
	
		
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
	
	public any function some(obj, iterator, context) {
		return this.any(argumentCollection = arguments);
	}	


	public any function include(obj = this.obj, target) {
		return this.any(obj, function(value) {
		  return value == target;
		});
	}

	public any function _contains(obj, target) {
		return this.include(argumentCollection = arguments);
	}


	// TODO: make sure this works right
	public any function invoke(obj = this.obj, method, args = {}) {
	    return this.map(obj, function(value) {
	    	if (this.isFunction(method)) {
	    		result = method(args);
	    		if (isDefined('result')) {
	    			return result;
	    		}
	    		else {
	    			return value;
	    		}
	    	}
	    	else if((isObject(value) || isStruct(value)) && structKeyExists(value, method)) {
	    		var fun = value[method];
	    		return fun(args);
	    	}
	    	else {
	    		return value
	    	}
	    });
	}


	public any function pluck(obj = this.obj, key) {
    	return this.map(obj, function(value){
    		return value[key];
    	});				
	}


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


	public any function sortBy(obj, val, context) {
		
	}

	public any function groupBy(obj, val) {
		
	}


	public any function sortedIndex(array, obj, iterator) {
		
	}


	public any function shuffle(obj) {
		
	}


	public any function toArray(obj) {
		
	}
	
	
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