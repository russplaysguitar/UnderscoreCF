/**
*	@extends mxunit.framework.TestCase
*/
component {
	public void function testArraysFirst() {
	    var firstWrapper = function (x) {return _.first(x);};
	    assertEquals(_.first([1,2,3]), 1, 'can pull out the first element of an array');
	    // assertEquals(_([1, 2, 3]).first(), 1, 'can perform OO-style "first()"');
	    assertEquals(_.first([1,2,3], 0), [], 'can pass an index to first');
	    assertEquals(_.first([1,2,3], 2), [1, 2], 'can pass an index to first');
	    assertEquals(_.first([1,2,3], 5), [1, 2, 3], 'can pass an index to first');
	    var result = _.map([[1,2,3], [1,2,3]], firstWrapper);
	    assertEquals(result, [1,1], 'works well with _.map');
	    result = function() { return _.take([1,2,3], 2); };
	    assertEquals(result(), [1,2], 'aliased as take');
	    result = function() { return _.head([1,2,3], 2); };
	    assertEquals(result(), [1,2], 'aliased as head');
	}
	
	public void function testArraysRest() {
		var numbers = [1, 2, 3, 4];
		var restWrapper = function (x) { return _.rest(x); };
		assertEquals(_.rest(numbers), [2, 3, 4], 'working rest()');
		assertEquals(_.rest(numbers, 1), [1, 2, 3, 4], 'working rest(0)');
		assertEquals(_.rest(numbers, 3), [3, 4], 'rest can take an index');
		var result = _.map([[1,2,3],[1,2,3]], restWrapper);
		assertEquals(_.flatten(result), [2,3,2,3], 'works well with _.map');		
	}
	
	public void function testArraysInitial() {
		var initialWrapper = function (x) { return _.initial(x); };
		assertEquals(_.initial([1,2,3,4,5]), [1, 2, 3, 4], 'working initial()');
		assertEquals(_.initial([1,2,3,4],2), [1, 2], 'initial can take an index');
		var result = _.map([[1,2,3],[1,2,3]], initialWrapper);
		assertEquals(_.flatten(result), [1,2,1,2], 'initial works with _.map');		
	}
	
	public void function testArraysLast() {
		var lastWrapper = function (x) { return _.last(x); };
		assertEquals(_.last([1,2,3]), 3, 'can pull out the last element of an array');
		assertEquals(_.last([1,2,3], 0), [], 'can pass an index to last');
		assertEquals(_.last([1,2,3], 2), [2, 3], 'can pass an index to last');
		assertEquals(_.last([1,2,3], 5), [1, 2, 3], 'can pass an index to last');
		var result = _.map([[1,2,3],[1,2,3]], lastWrapper);
		assertEquals(result, [3,3], 'works well with _.map');		
	}
	
	public void function testArraysCompact() {
		assertEquals(arrayLen(_.compact([0, 1, false, 2, false, 3])), 3, 'can trim out all falsy values');
	}
	
	public void function testArraysFlatten() {
		var list = [1, [2], [3, [[[4]]]]];
		assertEquals(_.flatten(list), [1,2,3,4], 'can flatten nested arrays');
		assertEquals(_.flatten(list, true), [1,2,3,[[[4]]]], 'can shallowly flatten nested arrays');
	}
	
	public void function testArraysWithout() {
		var list = [1, 2, 1, 0, 3, 1, 4];
		assertEquals(_.without(list, [0, 1]), [2, 3, 4], 'can remove all instances of an object');
		list = [{one: 1}, {two: 2}];
		assertTrue(arrayLen(_.without(list, [{one: 1}])) == 1, 'works with structs');
	}
	
	
	public void function testArraysUniq() {
	    var list = [1, 2, 1, 3, 1, 4];
	    assertEquals(_.uniq(list), [1, 2, 3, 4], 'can find the unique values of an unsorted array');

	    var list = [1, 1, 1, 2, 2, 3];
	    assertEquals(_.uniq(list, true), [1, 2, 3], 'can find the unique values of a sorted array faster');

	    var list = [{name:'moe'}, {name:'curly'}, {name:'larry'}, {name:'curly'}];
	    var iterator = function(value) { return value.name; };
	    assertEquals(_.map(_.uniq(list, false, iterator), iterator), ['moe', 'curly', 'larry'], 'can find the unique values of an array using a custom iterator');

	    var iterator = function(value) { return value + 1; };
	    var list = [1, 2, 2, 3, 4, 4];
	    assertEquals(_.uniq(list, true, iterator), [1, 2, 3, 4], 'iterator works with sorted array');

	    var list = [];
	    list[8] = 2;
	    list[10] = 2;
	    list[11] = 5;
	    list[14] = 5;
	    list[16] = 8;
	    list[19] = 8;
	    list[33] = "hi";

	    var result = _.uniq(list, true);
		assertEquals(result, [2, 5, 8, "hi"], "Works with sorted sparse arrays where `undefined` elements are elided");
		assertEquals(arrayLen(result), 4, "The resulting array should not be sparse");
	}
	
	public void function testArraysIntersection() {
	    var stooges = ['moe', 'curly', 'larry'];
	    var leaders = ['moe', 'groucho'];
	    assertEquals(_.intersection(stooges, leaders), ['moe'], 'can take the set intersection of two arrays');
	    // assertEquals(_(stooges).intersection(leaders).join(''), 'moe', 'can perform an OO-style intersection');
	    // var result = (function(){ return _.intersection(arguments, leaders); })('moe', 'curly', 'larry');
	    // equal(result.join(''), 'moe', 'works on an arguments object');
	}
	
	public void function testArraysUnion() {
	    var result = _.union([1, 2, 3], [2, 30, 1], [1, 40]);
	    assertEquals(result, [1, 2, 3, 30, 40], 'takes the union of a list of arrays');

	    var result = _.union([1, 2, 3], [2, 30, 1], [1, 40, [1]]);
	    assertEquals(result, [1, 2, 3, 30, 40, 1], 'takes the union of a list of nested arrays');
	}
	
	public void function testArraysDifference() {
	    var result = _.difference([1, 2, 3], [2, 30, 40]);
	    assertEquals(result, [1, 3], 'takes the difference of two arrays');

	    var result = _.difference([1, 2, 3, 4], [[2, 30, 40], [1, 11, 111]]);
	    assertEquals(result, [3, 4], 'takes the difference of three arrays');
	}
	
	public void function testArraysZip() {
	    var names = ['moe', 'larry', 'curly'];
	    var ages = [30, 40, 50];
	    var leaders = [true];
	    var stooges = _.zip(names, ages, leaders);
	    assertEquals(stooges, [['moe',30,true],['larry',40],['curly',50]], 'zipped together arrays of different lengths');
	}
	
	
	
	
	
	

	public void function setUp() {
		variables._ = new github.UnderscoreCF.Underscore();
	}


	public void function tearDown() {
		structDelete(variables, "_");
	}
	
}