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
	
	
	
	
	
	


	public void function setUp() {
		variables._ = new underscore.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "_");
	}
}