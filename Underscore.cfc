/** 
* Underscore.cfc
* A port of UnderscoreJS for Coldfusion
*/ 
component { 

	public any function init(obj = {}) { 
		this.obj = obj;

		return this;
	}


	public any function each(obj, iterator, context) {
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

	public any function forEach(obj, iterator, context) {
	    return this.each(argumentCollection = arguments);
 	}


 	public any function collect(obj, iterator, context) {
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
 	
  	public any function map(obj, iterator, context) {
 		return this.collect(argumentCollection = arguments);
 	}


 	public any function inject(obj, iterator, memo, context) {
 		
 	}
 	
  	public any function foldl(obj, iterator, memo, context) {
 		return this.inject(argumentCollection = arguments);
 	}
 		
  	public any function reduce(obj, iterator, memo, context) {
 		return this.inject(argumentCollection = arguments);
 	}


  	public any function foldr(obj, iterator, memo, context) {

   	}

 	public any function reduceRight(obj, iterator, memo, context) {
 		return this.foldr(argumentCollection = arguments);
 	}
 	
 	
 	public any function detect(obj, iterator, context) { 
 		
 	}
 	
  	public any function find(obj, iterator, context) { 
 		return this.detect(argumentCollection = arguments);
 	}


 	public any function select(obj, iterator, context) {
 		
 	}

	public any function filter(obj, iterator, context) {
		return this.select(argumentCollection = arguments);
	}
	

	public any function reject(obj, iterator, context) {
		
	}


	public any function all(obj, iterator, context) {
		
	}
	
	public any function every(obj, iterator, context) {
		return this.all(argumentCollection = arguments);
	}
	
		
	public any function any(obj, iterator, context) {
		
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