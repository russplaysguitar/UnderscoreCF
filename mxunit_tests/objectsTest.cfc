/**
*	@extends mxunit.framework.TestCase
*/
component {

	
	public void function testKeys() {
		assertEquals(_.keys({one: 1, two: 2}), ['one', 'two'], 'can extract the keys from an object');
		// the test above is not safe because it relies on for-in enumeration order
		var a = []; 
		a[2] = 0;
		assertEquals(_.keys(a), [2], 'is not fooled by sparse arrays');
	}

	/**
	* @mxunit:expectedException "Underscore"
	*/ 
	public void function testKeysNumericException() {
		_.keys(1);		
	}

	/**
	* @mxunit:expectedException "Underscore"
	*/ 
	public void function testKeysStringException() {
		_.keys('a');
	}	

	/**
	* @mxunit:expectedException "Underscore"
	*/ 
	public void function testKeysBooleanException() {
		_.keys(true);
	}

	public void function testValues() {
	    assertEquals(_.values({one : 1, two : 2}), [1, 2], 'can extract the values from an object');
	}
	
	public void function testFunctions() {
	    var obj = {A: 'dash', B: _.map, C: _.reduce};
	    assertTrue(_.isEqual(['B', 'C'], _.functions(obj)), 'can grab the function names of any passed-in object');
	}
	
	public void function testExtend() {
		var result = "";
		assertEquals(_.extend({}, {a:'b'}).a, 'b', 'can extend an object with the attributes of another');
		assertEquals(_.extend({a:'x'}, {a:'b'}).a, 'b', 'properties in source override destination');
		assertEquals(_.extend({x:'x'}, {a:'b'}).x, 'x', 'properties not in source dont get overriden');
		result = _.extend({x:'x'}, {a:'a'}, {b:'b'});
		assertTrue(_.isEqual(result, {x:'x', a:'a', b:'b'}), 'can extend from multiple source objects');
		result = _.extend({x:'x'}, {a:'a', x:2}, {a:'b'});
		assertTrue(_.isEqual(result, {x:2, a:'b'}), 'extending from multiple source objects last property trumps');
	}
	
	public void function testPick() {
	    var result = "";
	    result = _.pick({a:1, b:2, c:3}, 'a', 'c');
	    assertTrue(_.isEqual(result, {a:1, c:3}), 'can restrict properties to those named');
	    result = _.pick({a:1, b:2, c:3}, ['b', 'c']);
	    assertTrue(_.isEqual(result, {b:2, c:3}), 'can restrict properties to those named in an array');
	    result = _.pick({a:1, b:2, c:3}, ['a'], 'b');
	    assertTrue(_.isEqual(result, {a:1, b:2}), 'can restrict properties to those named in mixed args');		
	}
	
	public void function testDefaults() {
	    var result = "";
	    var options = {zero: 0, one: 1, empty: "", string: "string"};

	    _.defaults(options, {zero: 1, one: 10, twenty: 20});
	    assertEquals(options.zero, 0, 'value exists');
	    assertEquals(options.one, 1, 'value exists');
	    assertEquals(options.twenty, 20, 'default applied');

	    _.defaults(options, {empty: "full"}, {nan: "nan"}, {word: "word"}, {word: "dog"});
	    assertEquals(options.empty, "", 'value exists');
	    assertEquals(options.word, "word", 'new value is added, first one wins');
	}
	
	public void function testClone() {
	    var moe = {name : 'moe', lucky: {array:[13, 27, 34]}};
	    var clone = _.clone(moe);
	    assertEquals(clone.name, 'moe', 'the clone as the attributes of the original');

	    clone.name = 'curly';
	    assertTrue(clone.name == 'curly' && moe.name == 'moe', 'clones can change shallow attributes without affecting the original');

	    arrayAppend(clone.lucky.array, 101);
	    assertEquals(_.last(moe.lucky.array), 101, 'changes to deep attributes are shared with the original');

	    assertEquals(_.clone(1), 1, 'non objects should not be changed by clone');	  
	}
	
	public void function testIsEqual() {
		var num75 = 75;
	
	    // String object and primitive comparisons.
	    assertTrue(_.isEqual("Curly", "Curly"), "Identical string primitives are equal");
	    assertTrue(!_.isEqual("Curly", "Larry"), "String primitives with different values are not equal");

	    // Number object and primitive comparisons.
	    assertTrue(_.isEqual(num75, num75), "Identical number primitives are equal");

	    // Boolean object and primitive comparisons.
	    assertTrue(_.isEqual(true, true), "Identical boolean primitives are equal");

	    // Common type coercions.
	    // assertTrue(!_.isEqual("75", num75), "String and number primitives with like values are not equal");
	    // assertTrue(!_.isEqual(num75, "75"), "Commutative equality is implemented for like string and number values");
	    // assertTrue(!_.isEqual(0, "0"), "Number and string primitives with like values are not equal");
	    assertTrue(!_.isEqual(1, true), "Number and boolean primitives with like values are not equal");
	    // Dates.
	    assertTrue(_.isEqual(CreateDate(2009, 9, 25), CreateDate(2009, 9, 25)), "Date objects referencing identical times are equal");
	    assertTrue(!_.isEqual(CreateDate(2009, 9, 25), CreateDate(2009, 11, 13)), "Date objects referencing different times are not equal");

	    // Empty arrays, array-like objects, and object literals.
	    assertTrue(_.isEqual({}, {}), "Empty object literals are equal");
	    assertTrue(_.isEqual([], []), "Empty array literals are equal");
	    assertTrue(_.isEqual([{}], [{}]), "Empty nested arrays and objects are equal");
	    assertTrue(!_.isEqual({length: 0}, []), "Array-like objects and arrays are not equal.");
	    assertTrue(!_.isEqual([], {length: 0}), "Commutative equality is implemented for array-like objects");

	    assertTrue(!_.isEqual({}, []), "Object literals and array literals are not equal");
	    assertTrue(!_.isEqual([], {}), "Commutative equality is implemented for objects and arrays");

	    // Arrays with primitive and object values.
	    assertTrue(_.isEqual([1, "Larry", true], [1, "Larry", true]), "Arrays containing identical primitives are equal");
	    assertTrue(_.isEqual([("Moe"), CreateDate(2009, 9, 25)], [("Moe"), CreateDate(2009, 9, 25)]), "Arrays containing equivalent elements are equal");

	    // Multi-dimensional arrays.
	    var a = [47, false, "Larry", CreateDate(2009, 11, 13), ['running', 'biking', 'programming'], {a: 47}];
	    var b = [47, false, "Larry", CreateDate(2009, 11, 13), ['running', 'biking', 'programming'], {a: 47}];
	    assertTrue(_.isEqual(a, b), "Arrays containing nested arrays and objects are recursively compared");

	    // Array elements and properties.
	    assertTrue(_.isEqual(a, b), "Arrays containing equivalent elements and different non-numeric properties are equal");
	    arrayAppend(a, "White Rocks");
	    assertTrue(!_.isEqual(a, b), "Arrays of different lengths are not equal");
	    arrayAppend(a, "East Boulder");
	    arrayAppend(b, "Gunbarrel Ranch");
	    arrayAppend(b, "Teller Farm");
	    assertTrue(!_.isEqual(a, b), "Arrays of identical lengths containing different elements are not equal");
	    // Sparse arrays.
	    var a = [];
	    arrayResize(a, 3);
	    var b = [];
	    arrayResize(b, 6);
	    assertTrue(_.isEqual(a, a), "Sparse arrays of identical lengths are equal");
	    assertTrue(!_.isEqual(a, b), "Sparse arrays of different lengths are not equal when both are empty");

	    // Simple objects.
	    assertTrue(_.isEqual({a: "Curly", b: 1, c: true}, {a: "Curly", b: 1, c: true}), "Objects containing identical primitives are equal");
	    assertTrue(_.isEqual({a: "Curly", b: CreateDate(2009, 11, 13)}, {a: "Curly", b: CreateDate(2009, 11, 13)}), "Objects containing equivalent members are equal");
	    assertTrue(!_.isEqual({a: 63, b: 75}, {a: 61, b: 55}), "Objects of identical sizes with different values are not equal");
	    assertTrue(!_.isEqual({a: 63, b: 75}, {a: 61, c: 55}), "Objects of identical sizes with different property names are not equal");
	    assertTrue(!_.isEqual({a: 1, b: 2}, {a: 1}), "Objects of different sizes are not equal");
	    assertTrue(!_.isEqual({a: 1}, {a: 1, b: 2}), "Commutative equality is implemented for objects");
	    assertTrue(!_.isEqual({x: 1, z: 1}, {x: 1, z: 2}), "Objects with identical keys and different values are not equivalent");

	    // `A` contains nested objects and arrays.
	    a = {
	      name: "Moe Howard",
	      age: 77,
	      stooge: true,
	      hobbies: ["acting"],
	      film: {
	        name: "Sing a Song of Six Pants",
	        release: CreateDate(1947, 9, 30),
	        stars: ["Larry Fine", "Shemp Howard"],
	        minutes: 16,
	        seconds: 54
	      }
	    };

	    // `B` contains equivalent nested objects and arrays.
	    b = {
	      name: "Moe Howard",
	      age: 77,
	      stooge: true,
	      hobbies: ["acting"],
	      film: {
	        name: "Sing a Song of Six Pants",
	        release: CreateDate(1947, 9, 30),
	        stars: ["Larry Fine", "Shemp Howard"],
	        minutes: 16,
	        seconds: 54
	      }
	    };
	    assertTrue(_.isEqual(a, b), "Objects with nested equivalent members are recursively compared");

	    // Instances.
	    var First = new MyClass();
	    First.value = 1;
	    var Second = new MyClass();
	    Second.value = 2;
	    assertTrue(_.isEqual(First, First), "Object instances are equal");
	    assertTrue(!_.isEqual(First, Second), "Objects with different constructors and identical own properties are not equal");
	    // TODO: determine if the following case should be true or false
	    // assertTrue(!_.isEqual(new MyClass({value: 1}), First), "Object instances and objects sharing equivalent properties are not equal");
	    assertTrue(!_.isEqual({value: 2}, Second), "The prototype chain of objects should not be examined");

	    // Chaining.
	    // assertTrue(!_.isEqual(_({x: 1, y: undefined}).chain(), _({x: 1, z: 2}).chain()), 'Chained objects containing different values are not equal');
	    // equal(_({x: 1, y: 2}).chain().isEqual(_({x: 1, y: 2}).chain()).value(), true, '`isEqual` can be chained');

	    // Custom `isEqual` methods.
	    var isEqualObj = {isEqual: function (o) { return o.isEqual == this.isEqual; }, unique: {}};
	    var isEqualObjClone = {isEqual: isEqualObj.isEqual, unique: {}};

	    assertTrue(_.isEqual(isEqualObj, isEqualObjClone), 'Both objects implement identical `isEqual` methods');
	    assertTrue(_.isEqual(isEqualObjClone, isEqualObj), 'Commutative equality is implemented for objects with custom `isEqual` methods');
	    assertTrue(!_.isEqual(isEqualObj, {}), 'Objects that do not implement equivalent `isEqual` methods are not equal');
	    assertTrue(!_.isEqual({}, isEqualObj), 'Commutative equality is implemented for objects with different `isEqual` methods');
	    
	}
	
	public void function testIsEmpty() {
	    assertTrue(!_.isEmpty([1]), '[1] is not empty');
	    assertTrue(_.isEmpty([]), '[] is empty');
	    assertTrue(!_.isEmpty({one : 1}), '{one : 1} is not empty');
	    assertTrue(_.isEmpty({}), '{} is empty');
	    assertTrue(_.isEmpty(javaCast("null", 0)), 'null is empty');
	    assertTrue(_.isEmpty(''), 'the empty string is empty');
	    assertTrue(!_.isEmpty('moe'), 'but other strings are not');

	    var obj = {one : 1};
	    structDelete(obj, "one");
	    assertTrue(_.isEmpty(obj), 'deleting all the keys from a struct empties it');		
	}
	
	public void function testIsObject() {
	    assertTrue(!_.isObject([1, 2, 3]), 'arrays are not objects');
	    assertTrue(_.isObject(function () {}), 'functions are objects');
	    assertTrue(!_.isObject(javaCast("null", 0)), 'null is not an object');
	    assertTrue(!_.isObject('string'), 'string is not an object');
	    assertTrue(!_.isObject(12), 'number is not an object');
	    assertTrue(!_.isObject(true), 'boolean is not an object');
	}
	
	public void function testIsArray() {
		assertTrue(_.isArray([]), 'Empty arrays are arrays');
		assertTrue(_.isArray([1, 2, 3]), 'Arrays are arrays');
		assertFalse(_.isArray(new Component()), 'Objects are not arrays');
		assertFalse(_.isArray('string'), 'String are not arrays');
	}
	
	public void function testIsString() {
		assertTrue(_.isString('string', 'strings are strings'));
		assertTrue(_.isString(''), 'empty strings are strings');
		// assertFalse(_.isString(1), 'numbers are not strings');
		assertFalse(_.isString(createDate(2001, 12, 31), 'dates are not strings'));
		assertFalse(_.isString(javaCast("null", 0)), 'null is not a strings');
		// assertFalse(_.isString(true), 'true is not a string');
	}
	
	public void function testIsNumber() {
		// assertTrue(_.isNumber(1), 'ints are numbers');
		// assertTrue(_.isNumber(0), 'zero int is a number');
		// assertTrue(_.isNumber(1.1), 'floats are numbers');
		// assertTrue(_.isNumber(2.2), 'doubles are numbers');
		assertFalse(_.isNumber(javaCast("null", 0)), 'null is not a number');
		assertFalse(_.isNumber('string'), 'strings are not numbers');
		assertFalse(_.isNumber(createDate(2001, 12, 31), 'dates are not numbers'));
	}
	
	public void function testIsBoolean() {
		assertTrue(_.isBoolean(true), 'true is boolean');
		assertTrue(_.isBoolean(false), 'false is boolean');
		assertTrue(_.isBoolean(javaCast("boolean", true)), 'javacasted true is boolean');
		assertTrue(_.isBoolean(javaCast("boolean", false)), 'javacasted false is boolean');
		assertFalse(_.isBoolean('string'), 'strings are not booleans');
		// some other things count as booleans, but that may or may not be supported in all CF engines
		//	 so we won't test things like "YES", "NO", "true", "false", 1, 0, etc
	}
	
	public void function testIsFunction() {
	    assertTrue(!_.isFunction([1, 2, 3]), 'arrays are not functions');
	    assertTrue(!_.isFunction('moe'), 'strings are not functions');
	    assertTrue(_.isFunction(_.isFunction), 'but functions are');
	}
	
	public void function testIsDate() {
		assertFalse(_.isDate(100), 'numbers are not dates');
		assertFalse(_.isDate(new Component()), 'objects are not dates');
		assertTrue(_.isDate(createDate(1999, 12, 31)), 'dates are dates');
	}

	public void function setUp() {
		variables._ = new underscore.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "_");
	}
}