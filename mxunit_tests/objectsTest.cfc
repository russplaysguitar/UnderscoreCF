component extends="mxunit.framework.TestCase" {
	
	public void function testKeys() {
		var keys = _.keys({one: 1, two: 2});
		assertTrue(_.any(keys, function(val){ return val =='one'; }) && _.any(keys, function(val){ return val =='two'; }), 'can extract the keys from an object');
		var a = []; 
		a[2] = 0;
		assertEquals([2], _.keys(a), 'is not fooled by sparse arrays');
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
		var values = _.values({one : 1, two : 2});
	    assertTrue(_.isEqual(values, [1,2]) || _.isEqual(values, [2,1]), 'can extract the values from an object');
	}

	public void function testPairs() {
		var result = _.pairs({ONE: 1, TWO: 2});
		var expected1 = [['ONE', 1], ['TWO', 2]];
		var expected2 = [['TWO', 2], ['ONE', 1]];
		assertTrue(_.isEqual(result, expected1) || _.isEqual(result, expected2), 'can convert an object into pairs');  
	}
	
	public void function testInvert() {
		var obj = {FIRST: 'MOE', SECOND: 'LARRY', THIRD: 'CURLY'};
		var result = _.invert(obj);
		var expected = {MOE: 'FIRST', LARRY: 'SECOND', CURLY: 'THIRD'};
		assertTrue(_.isEqual(result, expected), 'can invert an object');
		assertTrue(_.isEqual(_.invert(_.invert(obj)), obj), 'two inverts gets you back where you started');

		var obj = {length: 3};
		assertEquals('length', _.invert(obj)['3'], 'can invert an object with "length"');
	}

	public void function testFunctions() {
	    var obj = {A: 'dash', B: _.map, C: _.reduce};
	    assertEquals(['B', 'C'], _.functions(obj), 'can grab the function names of any passed-in object');
	}
	
	public void function testExtend() {
		var result = "";
		assertEquals('b', _.extend({}, {a:'b'}).a, 'can extend an object with the attributes of another');
		assertEquals('b', _.extend({a:'x'}, {a:'b'}).a, 'properties in source override destination');
		assertEquals('x', _.extend({x:'x'}, {a:'b'}).x, 'properties not in source dont get overriden');
		result = _.extend({x:'x'}, {a:'a'}, {b:'b'});
		assertEquals({x:'x', a:'a', b:'b'}, result, 'can extend from multiple source objects');
		result = _.extend({x:'x'}, {a:'a', x:2}, {a:'b'});
		assertEquals({x:2, a:'b'}, result, 'extending from multiple source objects last property trumps');
	}
	
	public void function testPick() {
	    var result = "";
	    result = _.pick({a:1, b:2, c:3}, 'a', 'c');
	    assertEquals({a:1, c:3}, result, 'can restrict properties to those named');
	    result = _.pick({a:1, b:2, c:3}, ['b', 'c']);
	    assertEquals({b:2, c:3}, result, 'can restrict properties to those named in an array');
	    result = _.pick({a:1, b:2, c:3}, ['a'], 'b');
	    assertEquals({a:1, b:2}, result, 'can restrict properties to those named in mixed args');		
	}
	
	public void function testOmit() {
		var result = "";
		result = _.omit({a:1, b:2, c:3}, 'b');
		assertEquals({a:1, c:3}, result, 'can omit a single named property');
		result = _.omit({a:1, b:2, c:3}, 'a', 'c');
		assertEquals({b:2}, result, 'can omit several named properties');
		result = _.omit({a:1, b:2, c:3}, ['b', 'c']);
		assertEquals({a:1}, result, 'can omit properties named in an array');
	}

	public void function testDefaults() {
	    var result = "";
	    var options = {zero: 0, one: 1, empty: "", string: "string"};

	    _.defaults(options, {zero: 1, one: 10, twenty: 20});
	    assertEquals(0, options.zero, 'value exists');
	    assertEquals(1, options.one, 'value exists');
	    assertEquals(20, options.twenty, 'default applied');

	    _.defaults(options, {empty: "full"}, {nan: "nan"}, {word: "word"}, {word: "dog"});
	    assertEquals("", options.empty, 'value exists');
	    assertEquals("word", options.word, 'new value is added, first one wins');
	}
	
	public void function testClone() {
	    var moe = {name : 'moe', lucky: {array:[13, 27, 34]}};
	    var clone = _.clone(moe);
	    assertEquals('moe', clone.name, 'the clone as the attributes of the original');

	    clone.name = 'curly';
	    assertTrue(clone.name == 'curly' && moe.name == 'moe', 'clones can change shallow attributes without affecting the original');

	    arrayAppend(clone.lucky.array, 101);
	    assertEquals(101, _.last(moe.lucky.array), 'changes to deep attributes are shared with the original');

	    assertEquals(1, _.clone(1), 'non objects should not be changed by clone');	  

	    var original = new MyClass();
	    original.subObj = new MyClass();
	    original.subObj.x = 1;
	    var clone = _.clone(original);
	    original.subObj.x = 2;
	    assertTrue(_.isEqual(clone, original), 'nested objects are copied by reference');

	    var original = new MyClass();
	    original.subStruct = {
	    	x: 1
	    };
	    var clone = _.clone(original);
	    original.subStruct.x = 2;
	    assertTrue(_.isEqual(clone, original), 'nested structs are copied by reference');	    

	    var original = new MyClass();
	    original.subArray = [1];
	    var clone = _.clone(original);
	    original.subArray[1] = 2;
	    assertFalse(_.isEqual(clone, original), 'nested arrays are copied by reference');	    
	}
	
	public void function testIsEqual() {
		var num75 = 75;
	
	    // String object and primitive comparisons.
	    assertTrue(_.isEqual("Curly", "Curly"), "Identical string primitives are equal");
	    assertFalse(_.isEqual("Curly", "Larry"), "String primitives with different values are not equal");

	    // Number object and primitive comparisons.
	    assertTrue(_.isEqual(75, num75), "Identical number primitives are equal");

	    // Boolean object and primitive comparisons.
	    assertTrue(_.isEqual(true, true), "Identical boolean primitives are equal");

	    // Common type coercions.
	    // assertTrue(!_.isEqual("75", num75), "String and number primitives with like values are not equal");
	    // assertTrue(!_.isEqual(num75, "75"), "Commutative equality is implemented for like string and number values");
	    // assertTrue(!_.isEqual(0, "0"), "Number and string primitives with like values are not equal");
	    // assertTrue(!_.isEqual(1, true), "Number and boolean primitives with like values are not equal");
	    // Dates.
	    assertTrue(_.isEqual(CreateDate(2009, 9, 25), CreateDate(2009, 9, 25)), "Date objects referencing identical times are equal");
	    assertFalse(_.isEqual(CreateDate(2009, 9, 25), CreateDate(2009, 11, 13)), "Date objects referencing different times are not equal");

	    // Empty arrays, array-like objects, and object literals.
	    assertTrue(_.isEqual({}, {}), "Empty object literals are equal");
	    assertTrue(_.isEqual([], []), "Empty array literals are equal");
	    assertTrue(_.isEqual([{}], [{}]), "Empty nested arrays and objects are equal");
	    assertFalse(_.isEqual({length: 0}, []), "Array-like objects and arrays are not equal.");
	    assertFalse(_.isEqual([], {length: 0}), "Commutative equality is implemented for array-like objects");

	    assertFalse(_.isEqual({}, []), "Object literals and array literals are not equal");
	    assertFalse(_.isEqual([], {}), "Commutative equality is implemented for objects and arrays");

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
	    assertFalse(_.isEqual(a, b), "Sparse arrays of different lengths are not equal when both are empty");

	    // Simple objects.
	    assertTrue(_.isEqual({a: "Curly", b: 1, c: true}, {a: "Curly", b: 1, c: true}), "Objects containing identical primitives are equal");
	    assertTrue(_.isEqual({a: "Curly", b: CreateDate(2009, 11, 13)}, {a: "Curly", b: CreateDate(2009, 11, 13)}), "Objects containing equivalent members are equal");
	    assertFalse(_.isEqual({a: 63, b: 75}, {a: 61, b: 55}), "Objects of identical sizes with different values are not equal");
	    assertFalse(_.isEqual({a: 63, b: 75}, {a: 61, c: 55}), "Objects of identical sizes with different property names are not equal");
	    assertFalse(_.isEqual({a: 1, b: 2}, {a: 1}), "Objects of different sizes are not equal");
	    assertFalse(_.isEqual({a: 1}, {a: 1, b: 2}), "Commutative equality is implemented for objects");
	    assertFalse(_.isEqual({x: 1, z: 1}, {x: 1, z: 2}), "Objects with identical keys and different values are not equivalent");

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
	    assertFalse(_.isEqual(First, Second), "Objects with different constructors and identical own properties are not equal");
	    // TODO: determine if the following case should be true or false
	    // assertFalse(_.isEqual(new MyClass({value: 1}), First), "Object instances and objects sharing equivalent properties are not equal");
	    assertFalse(_.isEqual({value: 2}, Second), "The prototype chain of objects should not be examined");

	    // Chaining.
	    // assertFalse(_.isEqual(_({x: 1, y: undefined}).chain(), _({x: 1, z: 2}).chain()), 'Chained objects containing different values are not equal');
	    // equal(_({x: 1, y: 2}).chain().isEqual(_({x: 1, y: 2}).chain()).value(), true, '`isEqual` can be chained');

	    // Custom `isEqual` methods.
	    var isEqualObj = {isEqual: function (o) { return o.isEqual == this.isEqual; }, unique: {}};
	    var isEqualObjClone = {isEqual: isEqualObj.isEqual, unique: {}};

	    assertTrue(_.isEqual(isEqualObj, isEqualObjClone), 'Both objects implement identical `isEqual` methods');
	    assertTrue(_.isEqual(isEqualObjClone, isEqualObj), 'Commutative equality is implemented for objects with custom `isEqual` methods');
	    assertFalse(_.isEqual(isEqualObj, {}), 'Objects that do not implement equivalent `isEqual` methods are not equal');
	    assertFalse(_.isEqual({}, isEqualObj), 'Commutative equality is implemented for objects with different `isEqual` methods');
	    
	    assertFalse(_.isEqual({}, new MyClass()), 'empty structs and objects are not the same');
	}
	
	public void function testIsEmpty() {
	    assertFalse(_.isEmpty([1]), '[1] is not empty');
	    assertTrue(_.isEmpty([]), '[] is empty');
	    assertFalse(_.isEmpty({one : 1}), '{one : 1} is not empty');
	    assertTrue(_.isEmpty({}), '{} is empty');
	    // assertTrue(_.isEmpty(javaCast("null", 0)), 'null is empty');
	    assertTrue(_.isEmpty(''), 'the empty string is empty');
	    assertFalse(_.isEmpty('moe'), 'but other strings are not');

	    var obj = {one : 1};
	    structDelete(obj, "one");
	    assertTrue(_.isEmpty(obj), 'deleting all the keys from a struct empties it');		
	}
	
	public void function testIsObject() {
	    assertFalse(_.isObject([1, 2, 3]), 'arrays are not objects');
	    // assertTrue(_.isObject(function () {}), 'functions are objects');
	    // assertFalse(_.isObject(javaCast("null", 0)), 'null is not an object');
	    assertFalse(_.isObject('string'), 'string is not an object');
	    assertFalse(_.isObject(12), 'number is not an object');
	    assertFalse(_.isObject(true), 'boolean is not an object');
	}
	
	public void function testIsArray() {
		assertTrue(_.isArray([]), 'Empty arrays are arrays');
		assertTrue(_.isArray([1, 2, 3]), 'Arrays are arrays');
		assertFalse(_.isArray({}), 'Objects are not arrays');
		assertFalse(_.isArray('string'), 'String are not arrays');
	}
	
	public void function testIsString() {
		assertTrue(_.isString('string', 'strings are strings'));
		assertTrue(_.isString(''), 'empty strings are strings');
		// assertFalse(_.isString(1), 'numbers are not strings');
		assertFalse(_.isString(createDate(2001, 12, 31), 'dates are not strings'));
		// assertFalse(_.isString(javaCast("null", 0)), 'null is not a strings');
		// assertFalse(_.isString(true), 'true is not a string');
	}
	
	public void function testIsNumber() {
		// assertTrue(_.isNumber(1), 'ints are numbers');
		// assertTrue(_.isNumber(0), 'zero int is a number');
		// assertTrue(_.isNumber(1.1), 'floats are numbers');
		// assertTrue(_.isNumber(2.2), 'doubles are numbers');
		// assertFalse(_.isNumber(javaCast("null", 0)), 'null is not a number');
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
	    assertFalse(_.isFunction([1, 2, 3]), 'arrays are not functions');
	    assertFalse(_.isFunction('moe'), 'strings are not functions');
	    assertTrue(_.isFunction(_.isFunction), 'but functions are');
	}
	
	public void function testIsDate() {
		assertFalse(_.isDate(100), 'numbers are not dates');
		assertFalse(_.isDate({}), 'objects are not dates');
		assertTrue(_.isDate(createDate(1999, 12, 31)), 'dates are dates');
	}

	public void function setUp() {
		variables._ = new underscore.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "_");
	}
}