/** 
* Underscore.cfc
* A port of UnderscoreJS for Coldfusion
*/ 
component { 

	public any function init(obj = {}) { 
		this.obj = obj;

		return this;
	}


	public any function each(obj, iterator) {
		if (structKeyExists(arguments, 'obj')) {
			var list = arguments.obj;
		}
		else if (structKeyExists(this, 'obj')) {
			var list = this.obj;
		}
		else {
			return;
		}
		if (isArray(list)) {
			var index = 1;
			for (element in list) {
				iterator(element, index, list);
				index++;
			}
		}
		else {	
			for (key in list) {
				var val = list[key];
				iterator(val, key, list);
			}
		}
 	}

	public any function forEach(obj, iterator) {
	    return this.each(argumentCollection = arguments);
 	}


 	public any function collect(obj, iterator) {
 		var result = [];
		if (structKeyExists(arguments, 'obj')) {
			var list = arguments.obj;
		}
		else if (structKeyExists(this, 'obj')) {
			var list = this.obj;
		}
		else {
			return result;
		}
		if (isArray(list)) {
			var index = 1;
			for (element in list) {
				result[index] = iterator(element, index, list);
				index++;
			}
		}
		else {
			var index = 1;
			for (key in list) {
				var val = list[key];
				result[index] = iterator(val, key, list);
				index++;
			}
		}

		return result;
 	}
 	
  	public any function map(obj, iterator) {
 		return this.collect(argumentCollection = arguments);
 	}


 	public any function inject(obj, iterator, memo) {
		if (structKeyExists(arguments, 'obj')) {
			var list = arguments.obj;
		}
		else if (structKeyExists(this, 'obj')) {
			var list = this.obj;
		}
		else {
			return result;
		}
		if (isArray(list)) {
			for (num in list) {
				memo = iterator(memo, num);
			}
		}
		else {
			for (key in list) {
				var num = list[key];
				memo = iterator(memo, num);
			}
		}

		return memo;		
 	}
 	
  	public any function foldl(obj, iterator, memo) {
 		return this.inject(argumentCollection = arguments);
 	}
 		
  	public any function reduce(obj, iterator, memo) {
 		return this.inject(argumentCollection = arguments);
 	}


  	public any function foldr(obj, iterator, memo, context) {
  		// TODO
   	}

 	public any function reduceRight(obj, iterator, memo, context) {
 		return this.foldr(argumentCollection = arguments);
 	}
 	
 	
 	public any function detect(obj, iterator) { 
 		var result = 0;

		if (structKeyExists(arguments, 'obj')) {
			var list = arguments.obj;
		}
		else if (structKeyExists(this, 'obj')) {
			var list = this.obj;
		}
		else {
			return result;
		}

		if (isArray(list)) {
			var index = 1;
			for (val in list) {
				if (iterator(val, index, list)) {
					result = val;
					break;
				}
				index++;
			}
		}
		else {
			var index  = 1;
			for (key in list) {
				var val = list[key];
				if (iterator(val, index, list)) {
					result = val;
					break;
				}
				index++;
			}
		}

		return result;
 	}
 	
  	public any function find(obj, iterator) { 
 		return this.detect(argumentCollection = arguments);
 	}


 	public any function select(obj, iterator) {
		var result = [];

		if (structKeyExists(arguments, 'obj')) {
			var list = arguments.obj;
		}
		else if (structKeyExists(this, 'obj')) {
			var list = this.obj;
		}
		else {
			return result;
		}

		if (isArray(list)) {
			var index = 1;
			for (val in list) {
				var success = iterator(val, index, list);
				if (success) {
					result[index] = val;
					index++;
				}
			}
		}
		else {
			var index = 1;
			for (key in list) {
				var val = list[key];
				var success = iterator(val, index, list);
				if (success) {
					result[index] = val;
					index++;
				}
			}
		}

		return result;
 	}

	public any function filter(obj, iterator) {
		return this.select(argumentCollection = arguments);
	}
	

	public any function reject(obj, iterator) {
		var result = [];

		if (structKeyExists(arguments, 'obj')) {
			var list = arguments.obj;
		}
		else if (structKeyExists(this, 'obj')) {
			var list = this.obj;
		}
		else {
			return result;
		}

		if (isArray(list)) {
			var index = 1;
			for (val in list) {
				var success = iterator(val, index, list);
				if (!success) {
					result[index] = val;
					index++;
				}
			}
		}
		else {
			var index = 1;
			for (key in list) {
				var val = list[key];
				var success = iterator(val, index, list);
				if (!success) {
					result[index] = val;
					index++;
				}
			}
		}

		return result;		
	}


	public any function all(obj, iterator, context) {
		
	}
	
	public any function every(obj, iterator, context) {
		return this.all(argumentCollection = arguments);
	}
	
		
	public any function any(obj, iterator, context) {
		var result = false;

		if (structKeyExists(arguments, 'obj')) {
			var list = arguments.obj;
		}
		else if (structKeyExists(this, 'obj')) {
			var list = this.obj;
		}
		else {
			return result;
		}

		if (isArray(list)) {
			var index = 1;
			for (val in list) {
				result = iterator(val, index, list);
				if (result) {
					break;
				}
				index++;
			}
		}
		else {
			var index  = 1;
			for (key in list) {
				var val = list[key];
				result = iterator(val, index, list);
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


	public any function include(obj, target) {

	}

	public any function _contains(obj, target) {
		return this.include(argumentCollection = arguments);
	}


	public any function invoke(obj, method) {
		
	}


	public any function pluck(obj, key) {
		
	}


	public any function max(obj, iterator, context) {
		
	}


	public any function min(obj, iterator, context) {
		
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
	
	
}