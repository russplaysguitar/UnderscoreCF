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
	    var obj = {a : 'dash', b : _.map, c : _.reduce};
	    assertTrue(_.isEqual(['b', 'c'], _.functions(obj)), 'can grab the function names of any passed-in object');
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
	    var First = function() {
	      this.value = 1;
	    };
	    // First.value = 1;
	    var Second = function() {
	      this.value = 1;
	    };
	    // Second.value = 2;
	
	    // assertTrue(!_.isEqual(0, -0), "`0` is not equal to `-0`");
	    // assertTrue(!_.isEqual(-0, 0), "Commutative equality is implemented for `0` and `-0`");

	    // String object and primitive comparisons.
	    assertTrue(_.isEqual("Curly", "Curly"), "Identical string primitives are equal");
	    assertTrue(!_.isEqual("Curly", "Larry"), "String primitives with different values are not equal");

	    // Number object and primitive comparisons.
	    assertTrue(_.isEqual(75, 75), "Identical number primitives are equal");

	    // Boolean object and primitive comparisons.
	    assertTrue(_.isEqual(true, true), "Identical boolean primitives are equal");

	    // Common type coercions.
	    assertTrue(!_.isEqual("75", 75), "String and number primitives with like values are not equal");
	    assertTrue(!_.isEqual(75, "75"), "Commutative equality is implemented for like string and number values");
	    assertTrue(!_.isEqual(0, ""), "Number and string primitives with like values are not equal");
	    assertTrue(!_.isEqual(1, true), "Number and boolean primitives with like values are not equal");
	    // assertTrue(!_.isEqual(12564504e5, new Date(2009, 9, 25)), "Dates and their corresponding numeric primitive values are not equal");
/*
	    // Dates.
	    assertTrue(_.isEqual(new Date(2009, 9, 25), new Date(2009, 9, 25)), "Date objects referencing identical times are equal");
	    assertTrue(!_.isEqual(new Date(2009, 9, 25), new Date(2009, 11, 13)), "Date objects referencing different times are not equal");
	    assertTrue(!_.isEqual(new Date(2009, 11, 13), {
	      getTime: function(){
	        return 12606876e5;
	      }
	    }), "Date objects and objects with a `getTime` method are not equal");
	    assertTrue(!_.isEqual(new Date("Curly"), new Date("Curly")), "Invalid dates are not equal");

	    // Functions.
	    assertTrue(!_.isEqual(First, Second), "Different functions with identical bodies and source code representations are not equal");

	    // RegExps.
	    assertTrue(_.isEqual(/(?:)/gim, /(?:)/gim), "RegExps with equivalent patterns and flags are equal");
	    assertTrue(!_.isEqual(/(?:)/g, /(?:)/gi), "RegExps with equivalent patterns and different flags are not equal");
	    assertTrue(!_.isEqual(/Moe/gim, /Curly/gim), "RegExps with different patterns and equivalent flags are not equal");
	    assertTrue(!_.isEqual(/(?:)/gi, /(?:)/g), "Commutative equality is implemented for RegExps");
	    assertTrue(!_.isEqual(/Curly/g, {source: "Larry", global: true, ignoreCase: false, multiline: false}), "RegExps and RegExp-like objects are not equal");

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
	    assertTrue(_.isEqual([(/Moe/g), new Date(2009, 9, 25)], [(/Moe/g), new Date(2009, 9, 25)]), "Arrays containing equivalent elements are equal");

	    // Multi-dimensional arrays.
	    var a = [new Number(47), false, "Larry", /Moe/, new Date(2009, 11, 13), ['running', 'biking', new String('programming')], {a: 47}];
	    var b = [new Number(47), false, "Larry", /Moe/, new Date(2009, 11, 13), ['running', 'biking', new String('programming')], {a: 47}];
	    assertTrue(_.isEqual(a, b), "Arrays containing nested arrays and objects are recursively compared");

	    // Overwrite the methods defined in ES 5.1 section 15.4.4.
	    a.forEach = a.map = a.filter = a.every = a.indexOf = a.lastIndexOf = a.some = a.reduce = a.reduceRight = null;
	    b.join = b.pop = b.reverse = b.shift = b.slice = b.splice = b.concat = b.sort = b.unshift = null;

	    // Array elements and properties.
	    assertTrue(_.isEqual(a, b), "Arrays containing equivalent elements and different non-numeric properties are equal");
	    a.push("White Rocks");
	    assertTrue(!_.isEqual(a, b), "Arrays of different lengths are not equal");
	    a.push("East Boulder");
	    b.push("Gunbarrel Ranch", "Teller Farm");
	    assertTrue(!_.isEqual(a, b), "Arrays of identical lengths containing different elements are not equal");

	    // Sparse arrays.
	    assertTrue(_.isEqual(Array(3), Array(3)), "Sparse arrays of identical lengths are equal");
	    assertTrue(!_.isEqual(Array(3), Array(6)), "Sparse arrays of different lengths are not equal when both are empty");

	    // According to the Microsoft deviations spec, section 2.1.26, JScript 5.x treats `undefined`
	    // elements in arrays as elisions. Thus, sparse arrays and dense arrays containing `undefined`
	    // values are equivalent.
	    if (0 in [undefined]) {
	      assertTrue(!_.isEqual(Array(3), [undefined, undefined, undefined]), "Sparse and dense arrays are not equal");
	      assertTrue(!_.isEqual([undefined, undefined, undefined], Array(3)), "Commutative equality is implemented for sparse and dense arrays");
	    }

	    // Simple objects.
	    assertTrue(_.isEqual({a: "Curly", b: 1, c: true}, {a: "Curly", b: 1, c: true}), "Objects containing identical primitives are equal");
	    assertTrue(_.isEqual({a: /Curly/g, b: new Date(2009, 11, 13)}, {a: /Curly/g, b: new Date(2009, 11, 13)}), "Objects containing equivalent members are equal");
	    assertTrue(!_.isEqual({a: 63, b: 75}, {a: 61, b: 55}), "Objects of identical sizes with different values are not equal");
	    assertTrue(!_.isEqual({a: 63, b: 75}, {a: 61, c: 55}), "Objects of identical sizes with different property names are not equal");
	    assertTrue(!_.isEqual({a: 1, b: 2}, {a: 1}), "Objects of different sizes are not equal");
	    assertTrue(!_.isEqual({a: 1}, {a: 1, b: 2}), "Commutative equality is implemented for objects");
	    assertTrue(!_.isEqual({x: 1, y: undefined}, {x: 1, z: 2}), "Objects with identical keys and different values are not equivalent");

	    // `A` contains nested objects and arrays.
	    a = {
	      name: new String("Moe Howard"),
	      age: new Number(77),
	      stooge: true,
	      hobbies: ["acting"],
	      film: {
	        name: "Sing a Song of Six Pants",
	        release: new Date(1947, 9, 30),
	        stars: [new String("Larry Fine"), "Shemp Howard"],
	        minutes: new Number(16),
	        seconds: 54
	      }
	    };

	    // `B` contains equivalent nested objects and arrays.
	    b = {
	      name: new String("Moe Howard"),
	      age: new Number(77),
	      stooge: true,
	      hobbies: ["acting"],
	      film: {
	        name: "Sing a Song of Six Pants",
	        release: new Date(1947, 9, 30),
	        stars: [new String("Larry Fine"), "Shemp Howard"],
	        minutes: new Number(16),
	        seconds: 54
	      }
	    };
	    assertTrue(_.isEqual(a, b), "Objects with nested equivalent members are recursively compared");

	    // Instances.
	    assertTrue(_.isEqual(new First, new First), "Object instances are equal");
	    assertTrue(!_.isEqual(new First, new Second), "Objects with different constructors and identical own properties are not equal");
	    assertTrue(!_.isEqual({value: 1}, new First), "Object instances and objects sharing equivalent properties are not equal");
	    assertTrue(!_.isEqual({value: 2}, new Second), "The prototype chain of objects should not be examined");

	    // Circular Arrays.
	    (a = []).push(a);
	    (b = []).push(b);
	    assertTrue(_.isEqual(a, b), "Arrays containing circular references are equal");
	    a.push(new String("Larry"));
	    b.push(new String("Larry"));
	    assertTrue(_.isEqual(a, b), "Arrays containing circular references and equivalent properties are equal");
	    a.push("Shemp");
	    b.push("Curly");
	    assertTrue(!_.isEqual(a, b), "Arrays containing circular references and different properties are not equal");

	    // Circular Objects.
	    a = {abc: null};
	    b = {abc: null};
	    a.abc = a;
	    b.abc = b;
	    assertTrue(_.isEqual(a, b), "Objects containing circular references are equal");
	    a.def = 75;
	    b.def = 75;
	    assertTrue(_.isEqual(a, b), "Objects containing circular references and equivalent properties are equal");
	    a.def = new Number(75);
	    b.def = new Number(63);
	    assertTrue(!_.isEqual(a, b), "Objects containing circular references and different properties are not equal");

	    // Cyclic Structures.
	    a = [{abc: null}];
	    b = [{abc: null}];
	    (a[0].abc = a).push(a);
	    (b[0].abc = b).push(b);
	    assertTrue(_.isEqual(a, b), "Cyclic structures are equal");
	    a[0].def = "Larry";
	    b[0].def = "Larry";
	    assertTrue(_.isEqual(a, b), "Cyclic structures containing equivalent properties are equal");
	    a[0].def = new String("Larry");
	    b[0].def = new String("Curly");
	    assertTrue(!_.isEqual(a, b), "Cyclic structures containing different properties are not equal");

	    // Complex Circular References.
	    a = {foo: {b: {foo: {c: {foo: null}}}}};
	    b = {foo: {b: {foo: {c: {foo: null}}}}};
	    a.foo.b.foo.c.foo = a;
	    b.foo.b.foo.c.foo = b;
	    assertTrue(_.isEqual(a, b), "Cyclic structures with nested and identically-named properties are equal");

	    // Chaining.
	    assertTrue(!_.isEqual(_({x: 1, y: undefined}).chain(), _({x: 1, z: 2}).chain()), 'Chained objects containing different values are not equal');
	    equal(_({x: 1, y: 2}).chain().isEqual(_({x: 1, y: 2}).chain()).value(), true, '`isEqual` can be chained');

	    // Custom `isEqual` methods.
	    var isEqualObj = {isEqual: function (o) { return o.isEqual == this.isEqual; }, unique: {}};
	    var isEqualObjClone = {isEqual: isEqualObj.isEqual, unique: {}};

	    assertTrue(_.isEqual(isEqualObj, isEqualObjClone), 'Both objects implement identical `isEqual` methods');
	    assertTrue(_.isEqual(isEqualObjClone, isEqualObj), 'Commutative equality is implemented for objects with custom `isEqual` methods');
	    assertTrue(!_.isEqual(isEqualObj, {}), 'Objects that do not implement equivalent `isEqual` methods are not equal');
	    assertTrue(!_.isEqual({}, isEqualObj), 'Commutative equality is implemented for objects with different `isEqual` methods');

	    // Custom `isEqual` methods - comparing different types
	    LocalizedString = (function() {
	      function LocalizedString(id) { this.id = id; this.string = (this.id===10)? 'Bonjour': ''; }
	      LocalizedString.prototype.isEqual = function(that) {
	        if (_.isString(that)) return this.string == that;
	        else if (that instanceof LocalizedString) return this.id == that.id;
	        return false;
	      };
	      return LocalizedString;
	    })();
	    var localized_string1 = new LocalizedString(10), localized_string2 = new LocalizedString(10), localized_string3 = new LocalizedString(11);
	    assertTrue(_.isEqual(localized_string1, localized_string2), 'comparing same typed instances with same ids');
	    assertTrue(!_.isEqual(localized_string1, localized_string3), 'comparing same typed instances with different ids');
	    assertTrue(_.isEqual(localized_string1, 'Bonjour'), 'comparing different typed instances with same values');
	    assertTrue(_.isEqual('Bonjour', localized_string1), 'comparing different typed instances with same values');
	    assertTrue(!_.isEqual('Bonjour', localized_string3), 'comparing two localized strings with different ids');
	    assertTrue(!_.isEqual(localized_string1, 'Au revoir'), 'comparing different typed instances with different values');
	    assertTrue(!_.isEqual('Au revoir', localized_string1), 'comparing different typed instances with different values');

	    // Custom `isEqual` methods - comparing with serialized data
	    Date.prototype.toJSON = function() {
	      return {
	        _type:'Date',
	        year:this.getUTCFullYear(),
	        month:this.getUTCMonth(),
	        day:this.getUTCDate(),
	        hours:this.getUTCHours(),
	        minutes:this.getUTCMinutes(),
	        seconds:this.getUTCSeconds()
	      };
	    };
	    Date.prototype.isEqual = function(that) {
	      var this_date_components = this.toJSON();
	      var that_date_components = (that instanceof Date) ? that.toJSON() : that;
	      delete this_date_components['_type']; delete that_date_components['_type'];
	      return _.isEqual(this_date_components, that_date_components);
	    };

	    var date = new Date();
	    var date_json = {
	      _type:'Date',
	      year:date.getUTCFullYear(),
	      month:date.getUTCMonth(),
	      day:date.getUTCDate(),
	      hours:date.getUTCHours(),
	      minutes:date.getUTCMinutes(),
	      seconds:date.getUTCSeconds()
	    };

	    assertTrue(_.isEqual(date_json, date), 'serialized date matches date');
	    assertTrue(_.isEqual(date, date_json), 'date matches serialized date');
	    */
	}
	
	
	
	
	
	
	


	public void function setUp() {
		variables._ = new underscore.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "_");
	}
}