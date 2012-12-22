
component extends="mxunit.framework.TestCase" {
	public void function testFirst() {
	    var firstWrapper = function (x) {return _.first(x);};
	    assertEquals(1, _.first([1,2,3]), 'can pull out the first element of an array');
	    // assertEquals(_([1, 2, 3]).first(), 1, 'can perform OO-style "first()"');
	    assertEquals([],        _.first([1,2,3], 0), 'can pass an index to first');
	    assertEquals([1, 2],    _.first([1,2,3], 2), 'can pass an index to first');
	    assertEquals([1, 2, 3], _.first([1,2,3], 5), 'can pass an index to first');
	    var result = _.map([[1,2,3], [1,2,3]], firstWrapper);
	    assertEquals([1,1], result, 'works well with _.map');
	    result = function() { return _.take([1,2,3], 2); };
	    assertEquals([1,2], result(), 'aliased as take');
	    result = function() { return _.head([1,2,3], 2); };
	    assertEquals([1,2], result(), 'aliased as head');
	}
	
	public void function testRest() {
		var numbers = [1, 2, 3, 4];
		var restWrapper = function (x) { return _.rest(x); };
		var result = _.map([[1,2,3],[1,2,3]], restWrapper);
		assertEquals([2, 3, 4],    _.rest(numbers), 'working rest()');
		assertEquals([1, 2, 3, 4], _.rest(numbers, 1), 'working rest(0)');
		assertEquals([3, 4],       _.rest(numbers, 3), 'rest can take an index');
		assertEquals([2,3,2,3],    _.flatten(result), 'works well with _.map');		
	}
	
	public void function testInitial() {
		var initialWrapper = function (x) { return _.initial(x); };
		var result = _.map([[1,2,3],[1,2,3]], initialWrapper);
		assertEquals([1, 2, 3, 4], _.initial([1,2,3,4,5]), 'working initial()');
		assertEquals([1, 2],       _.initial([1,2,3,4],2), 'initial can take an index');
		assertEquals([1,2,1,2],    _.flatten(result), 'initial works with _.map');		
	}
	
	public void function testLast() {
		var lastWrapper = function (x) { return _.last(x); };
		var result = _.map([[1,2,3],[1,2,3]], lastWrapper);
		assertEquals(3,         _.last([1,2,3]), 'can pull out the last element of an array');
		assertEquals([],        _.last([1,2,3], 0), 'can pass an index to last');
		assertEquals([2, 3],    _.last([1,2,3], 2), 'can pass an index to last');
		assertEquals([1, 2, 3], _.last([1,2,3], 5), 'can pass an index to last');
		assertEquals([3,3],     result, 'works well with _.map');		
	}
	
	public void function testCompact() {
		assertEquals(3, arrayLen(_.compact([0, 1, false, 2, false, 3])), 'can trim out all falsy values');
	}
	
	public void function testFlatten() {
		var list = [1, [2], [3, [[[4]]]]];
		assertEquals([1,2,3,4],       _.flatten(list), 'can flatten nested arrays');
		assertEquals([1,2,3,[[[4]]]], _.flatten(list, true), 'can shallowly flatten nested arrays');
	}
	
	public void function testWithout() {
		var list = [1, 2, 1, 0, 3, 1, 4];
		assertEquals([2, 3, 4], _.without(list, [0, 1]), 'can remove all instances of an object');
		list = [{one: 1}, {two: 2}];
		assertEquals(1, arrayLen(_.without(list, [{one: 1}])), 'works with structs');
	}
		
	public void function testUniq() {
	    var list = [1, 2, 1, 3, 1, 4];
	    assertEquals([1, 2, 3, 4], _.uniq(list), 'can find the unique values of an unsorted array');

	    var list = [1, 1, 1, 2, 2, 3];
	    assertEquals([1, 2, 3], _.uniq(list, true), 'can find the unique values of a sorted array faster');

	    var list = [{name:'moe'}, {name:'curly'}, {name:'larry'}, {name:'curly'}];
	    var iterator = function(value) { return value.name; };
	    assertEquals(['moe', 'curly', 'larry'], _.map(_.uniq(list, false, iterator), iterator), 'can find the unique values of an array using a custom iterator');

	    var iterator = function(value) { return value + 1; };
	    var list = [1, 2, 2, 3, 4, 4];
	    assertEquals([1, 2, 3, 4], _.uniq(list, true, iterator), 'iterator works with sorted array');

	    var list = [];
	    list[8] = 2;
	    list[10] = 2;
	    list[11] = 5;
	    list[14] = 5;
	    list[16] = 8;
	    list[19] = 8;
	    list[33] = "hi";

	    var result = _.uniq(list, true);
		assertEquals([2, 5, 8, "hi"], result, "Works with sorted sparse arrays where `undefined` elements are elided");
		assertEquals(4, arrayLen(result), "The resulting array should not be sparse");
	}
	
	public void function testIntersection() {
	    var stooges = ['moe', 'curly', 'larry'];
	    var leaders = ['moe', 'groucho'];
	    assertEquals(['moe'], _.intersection(stooges, leaders), 'can take the set intersection of two arrays');
	    // assertEquals('moe', _(stooges).intersection(leaders).join(''), 'can perform an OO-style intersection');
	    // var result = (function(){ return _.intersection(arguments, leaders); })('moe', 'curly', 'larry');
	    // equal('moe', result.join(''), 'works on an arguments object');
	}
	
	public void function testUnion() {
	    var result = _.union([1, 2, 3], [2, 30, 1], [1, 40]);
	    assertEquals([1, 2, 3, 30, 40], result, 'takes the union of a list of arrays');

	    var result = _.union([1, 2, 3], [2, 30, 1], [1, 40, [1]]);
	    assertEquals([1, 2, 3, 30, 40, [1]], result, 'takes the union of a list of nested arrays');
	}
	
	public void function testDifference() {
	    var result = _.difference([1, 2, 3], [2, 30, 40]);
	    assertEquals([1, 3], result, 'takes the difference of two arrays');

	    var result = _.difference([1, 2, 3, 4], [[2, 30, 40], [1, 11, 111]]);
	    assertEquals([3, 4], result, 'takes the difference of three arrays');
	}
	
	public void function testZip() {
	    var names = ['moe', 'larry', 'curly'];
	    var ages = [30, 40, 50];
	    var leaders = [true];
	    var stooges = _.zip(names, ages, leaders);
	    assertEquals([['moe',30,true],['larry',40],['curly',50]], stooges, 'zipped together arrays of different lengths');
	}
	
	public void function testObject() {
		var result = _.object(['MOE', 'LARRY', 'CURLY'], [30, 40, 50]);
		var shouldBe = {MOE: 30, LARRY: 40, CURLY: 50};
		assertTrue(_.isEqual(result, shouldBe), 'two arrays zipped together into an object');
		result = _.object([['ONE', 1], ['TWO', 2], ['THREE', 3]]);
		shouldBe = {ONE: 1, TWO: 2, THREE: 3};
		assertTrue(_.isEqual(result, shouldBe), 'an array of pairs zipped together into an object');
		var stooges = {MOE: 30, LARRY: 40, CURLY: 50};
		assertTrue(_.isEqual(_.object(_.pairs(stooges)), stooges), 'an object converted to pairs and back to an object');
	}

	public void function testIndexOf() {
	    // var result = (function(){ return _.indexOf(arguments, 2); })(1, 2, 3);
	    // equal(result, 1, 'works on an arguments object');

	    var numbers = [10, 20, 30, 40, 50];
	    var num = 35;
	    var index = _.indexOf(numbers, num, true);
	    assertEquals(0, index, '35 is not in the list');

	    numbers = [10, 20, 30, 40, 50]; 
	    num = 40;
	    index = _.indexOf(numbers, num, true);
	    assertEquals(4, index, '40 is in the list');

	    numbers = [1, 40, 40, 40, 40, 40, 40, 40, 50, 60, 70]; 
	    num = 40;
	    index = _.indexOf(numbers, num, true);
	    assertequals(2, index, '40 is in the list');

	    numbers = [1, 2, 3, 1, 2, 3, 1, 2, 3];
		index = _.indexOf(numbers, 2, 6);
		assertEquals(8, index, 'supports the fromIndex argument');

	    numbers = [1, 2, 3, 1];
		index = _.indexOf(numbers, 1, 5);
		assertEquals(0, index, 'handles invalid fromIndex argument');		
	}
	
	public void function testLastIndexOf() {
		var numbers = [1, 0, 1];	
		assertEquals(3, _.lastIndexOf(numbers, 1));
	    var numbers = [1, 0, 1, 0, 0, 1, 0, 0, 0];
	    assertEquals(9, _.lastIndexOf(numbers, 0), 'lastIndexOf the other element');
	    numbers = [1, 2, 3, 1, 2, 3, 1, 2, 3];
	    var index = _.lastIndexOf(numbers, 2, 2);
	    assertEquals(2, index, 'supports the fromIndex argument');
	    // var result = (function(){ return _.lastIndexOf(arguments, 1); })(1, 0, 1, 0, 0, 1, 0, 0, 0);
	    // assertEquals(5, result, 'works on an arguments object');
	}
	
	public void function testRange() {
		assertEquals([],           _.range(0), 'range with 0 as a first argument generates an empty array');
		assertEquals([0, 1, 2, 3], _.range(4), 'range with a single positive argument generates an array of elements 0,1,2,...,n-1');
		assertEquals([5, 6, 7],    _.range(5, 8), 'range with two arguments a &amp; b, a&lt;b generates an array of elements a,a+1,a+2,...,b-2,b-1');
		assertEquals([],           _.range(8, 5), 'range with two arguments a &amp; b, b&lt;a generates an empty array');
		assertEquals([3, 6, 9],    _.range(3, 10, 3), 'range with three arguments a &amp; b &amp; c, c &lt; b-a, a &lt; b generates an array of elements a,a+c,a+2c,...,b - (multiplier of a) &lt; c');
		assertEquals([3],          _.range(3, 10, 15), 'range with three arguments a &amp; b &amp; c, c &gt; b-a, a &lt; b generates an array with a single element, equal to a');
		assertEquals([12, 10, 8],  _.range(12, 7, -2), 'range with three arguments a &amp; b &amp; c, a &gt; b, c &lt; 0 generates an array of elements a,a-c,a-2c and ends with the number not less than b');
		assertEquals([0, -1, -2, -3, -4, -5, -6, -7, -8, -9], _.range(0, -10, -1), 'final example in the Python docs');		
	}
	
	public void function testconcat() {
		assertEquals([],                 _.concat([], []), 'Concatenating two empty arrays results in an empty array');
		assertEquals([1, 1],             _.concat([1], [1]), 'Concatenating two arrays with same value results in array with both values');
		assertEquals([1],                _.concat([], [1]), 'Concatenating an empty array with a non-empty array results in non-empty array');
		assertEquals([1],                _.concat([1], []), 'Concatenating an empty array with a non-empty array results in non-empty array');
		assertEquals([{one:1}, {two:2}], _.concat([{one:1}], [{two:2}]), 'Can concatenate arrays of structs');
		assertEquals([true, false],      _.concat([true], [false]), 'Can concatenate arrays of booleans');
		assertEquals([1, 2, 3],			 _.concat([1], [2], [3]), 'Can concatenate multiple arrays');
	}

	public void function testTakeWhile() {
		var ary = [1, 2, 3, 4, 1, 2];

		var result = _.takeWhile(ary, function(val) {
			return val < 3;
		});

		assertEquals([1, 2], result, 'takeWhile stops when it should');

		var result = _.takeWhile(ary, function(val) {
			return val < 1;
		});

		assertEquals([], result, 'takeWhile can return nothing');

		var result = _.takeWhile(ary, function(val) {
			return val < 5;
		});

		assertEquals([1, 2, 3, 4, 1, 2], result, 'takeWhile can return the whole array');
	}

	public void function testSplice() {
		var ary = [5, 4, 3, 2, 1, 0];

		var result = _.splice(ary, 1, 0);
		assertEquals(ary, result);

		var result = _.splice(ary, 1, 0, 9);
		assertEquals([9, 5, 4, 3, 2, 1, 0], result);

		var result = _.splice(ary, 7, 0, 9);
		assertEquals([5, 4, 3, 2, 1, 0, 9], result);

		var result = _.splice(ary, 1, 6, 9, 10, 11);
		assertEquals([9, 10, 11], result);
	}

	public void function testPush() {
		var result = _.push([], 10);
		assertEquals([10], result, 'Basic push');

		var result = _.push([], -22);
		assertEquals([-22], result, 'Negative push');

		var result = _.push(["first"], "second");
		assertEquals(["first", "second"], result, 'Pre-existing values still exist');

		var result = _.push([], 11, -33, "a", {}, [], 0, "");
		var expected = [11, -33, "a", {}, [], 0, ""];
		assertEquals(expected, result, 'Multiple push with various types');

		var _ary = _.init([]);
		_ary.push([], 10);
		assertEquals([], _ary.value(), 'Does not modify wrapped array');		
	}

	public void function testPop() {
		var result = _.pop([10, 20]);
		assertEquals(20, result, 'pop returns last element');
	}

	public void function testUnshift() {
		var result = _.unshift(["last"], "first", "second");
		var expected = ["first", "second", "last"];
		assertEquals(expected, result, "adds elements to beginning of array");

		var result = _.unshift(["single"]);
		var expected = ["single"];
		assertEquals(expected, result, "adding nothing results in same array");
	}

	public void function testShift() {
		var result = _.shift(["first", "second", "third"]);
		var expected = "first";
		assertEquals(expected, result, "returns first element");
	}

	public void function testJoin() {
		var result = _.join(["one", "two", "three"]);
		var expected = "one two three";
		assertEquals(expected, result, "should join strings");

		var result = _.join([1, 2, 3]);
		var expected = "1 2 3";
		assertEquals(expected, result, "should join numbers");

		var result = _.join([1, 2], " and ");
		var expected = "1 and 2";
		assertEquals(expected, result, "custom separator");
	}

	public void function testSlice() {
		var ary = [1, 2, 3, 4, 5];
		assertEquals( [],        _.slice(ary, 1, 0) );
		assertEquals( [],        _.slice(ary, 2, 0) );
		assertEquals( [4, 5],    _.slice(ary, 4) );
		assertEquals( [2, 3, 4], _.slice(ary, 2, 4) );
		assertEquals( [2, 3],    _.slice(ary, 2, -2) );
		assertEquals( [],        _.slice(ary, -1, 0) );
		assertEquals( [],        _.slice(ary, -1, 3) );
		assertEquals( [5],       _.slice(ary, -1, 5) );
		assertEquals( [3, 4, 5], _.slice(ary, -3, 5) );
	}

	public void function setUp() {
		variables._ = new underscore.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "_");
	}
	
}