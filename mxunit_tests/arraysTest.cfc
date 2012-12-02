
component extends="mxunit.framework.TestCase" {
	public void function testFirst() {
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
	
	public void function testRest() {
		var numbers = [1, 2, 3, 4];
		var restWrapper = function (x) { return _.rest(x); };
		assertEquals(_.rest(numbers), [2, 3, 4], 'working rest()');
		assertEquals(_.rest(numbers, 1), [1, 2, 3, 4], 'working rest(0)');
		assertEquals(_.rest(numbers, 3), [3, 4], 'rest can take an index');
		var result = _.map([[1,2,3],[1,2,3]], restWrapper);
		assertEquals(_.flatten(result), [2,3,2,3], 'works well with _.map');		
	}
	
	public void function testInitial() {
		var initialWrapper = function (x) { return _.initial(x); };
		assertEquals(_.initial([1,2,3,4,5]), [1, 2, 3, 4], 'working initial()');
		assertEquals(_.initial([1,2,3,4],2), [1, 2], 'initial can take an index');
		var result = _.map([[1,2,3],[1,2,3]], initialWrapper);
		assertEquals(_.flatten(result), [1,2,1,2], 'initial works with _.map');		
	}
	
	public void function testLast() {
		var lastWrapper = function (x) { return _.last(x); };
		assertEquals(_.last([1,2,3]), 3, 'can pull out the last element of an array');
		assertEquals(_.last([1,2,3], 0), [], 'can pass an index to last');
		assertEquals(_.last([1,2,3], 2), [2, 3], 'can pass an index to last');
		assertEquals(_.last([1,2,3], 5), [1, 2, 3], 'can pass an index to last');
		var result = _.map([[1,2,3],[1,2,3]], lastWrapper);
		assertEquals(result, [3,3], 'works well with _.map');		
	}
	
	public void function testCompact() {
		assertEquals(arrayLen(_.compact([0, 1, false, 2, false, 3])), 3, 'can trim out all falsy values');
	}
	
	public void function testFlatten() {
		var list = [1, [2], [3, [[[4]]]]];
		assertEquals(_.flatten(list), [1,2,3,4], 'can flatten nested arrays');
		assertEquals(_.flatten(list, true), [1,2,3,[[[4]]]], 'can shallowly flatten nested arrays');
	}
	
	public void function testWithout() {
		var list = [1, 2, 1, 0, 3, 1, 4];
		assertEquals(_.without(list, [0, 1]), [2, 3, 4], 'can remove all instances of an object');
		list = [{one: 1}, {two: 2}];
		assertTrue(arrayLen(_.without(list, [{one: 1}])) == 1, 'works with structs');
	}
	
	
	public void function testUniq() {
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
	
	public void function testIntersection() {
	    var stooges = ['moe', 'curly', 'larry'];
	    var leaders = ['moe', 'groucho'];
	    assertEquals(_.intersection(stooges, leaders), ['moe'], 'can take the set intersection of two arrays');
	    // assertEquals(_(stooges).intersection(leaders).join(''), 'moe', 'can perform an OO-style intersection');
	    // var result = (function(){ return _.intersection(arguments, leaders); })('moe', 'curly', 'larry');
	    // equal(result.join(''), 'moe', 'works on an arguments object');
	}
	
	public void function testUnion() {
	    var result = _.union([1, 2, 3], [2, 30, 1], [1, 40]);
	    assertEquals([1, 2, 3, 30, 40], result, 'takes the union of a list of arrays');

	    var result = _.union([1, 2, 3], [2, 30, 1], [1, 40, [1]]);
	    assertEquals([1, 2, 3, 30, 40, [1]], result, 'takes the union of a list of nested arrays');
	}
	
	public void function testDifference() {
	    var result = _.difference([1, 2, 3], [2, 30, 40]);
	    assertEquals(result, [1, 3], 'takes the difference of two arrays');

	    var result = _.difference([1, 2, 3, 4], [[2, 30, 40], [1, 11, 111]]);
	    assertEquals(result, [3, 4], 'takes the difference of three arrays');
	}
	
	public void function testZip() {
	    var names = ['moe', 'larry', 'curly'];
	    var ages = [30, 40, 50];
	    var leaders = [true];
	    var stooges = _.zip(names, ages, leaders);
	    assertEquals(stooges, [['moe',30,true],['larry',40],['curly',50]], 'zipped together arrays of different lengths');
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
	    assertEquals(index, 0, '35 is not in the list');

	    numbers = [10, 20, 30, 40, 50]; 
	    num = 40;
	    index = _.indexOf(numbers, num, true);
	    assertEquals(index, 4, '40 is in the list');

	    numbers = [1, 40, 40, 40, 40, 40, 40, 40, 50, 60, 70]; 
	    num = 40;
	    index = _.indexOf(numbers, num, true);
	    assertequals(index, 2, '40 is in the list');

	    numbers = [1, 2, 3, 1, 2, 3, 1, 2, 3];
		index = _.indexOf(numbers, 2, 6);
		assertEquals(index, 8, 'supports the fromIndex argument');

	    numbers = [1, 2, 3, 1];
		index = _.indexOf(numbers, 1, 5);
		assertEquals(index, 0, 'handles invalid fromIndex argument');		
	}
	
	public void function testLastIndexOf() {
		var numbers = [1, 0, 1];	
		assertEquals(_.lastIndexOf(numbers, 1), 3);
	    var numbers = [1, 0, 1, 0, 0, 1, 0, 0, 0];
	    assertEquals(_.lastIndexOf(numbers, 0), 9, 'lastIndexOf the other element');
	    numbers = [1, 2, 3, 1, 2, 3, 1, 2, 3];
	    var index = _.lastIndexOf(numbers, 2, 2);
	    assertEquals(index, 2, 'supports the fromIndex argument');
	    // var result = (function(){ return _.lastIndexOf(arguments, 1); })(1, 0, 1, 0, 0, 1, 0, 0, 0);
	    // equal(result, 5, 'works on an arguments object');
	}
	
	public void function testRange() {
		assertEquals(_.range(0), [], 'range with 0 as a first argument generates an empty array');
		assertEquals(_.range(4), [0, 1, 2, 3], 'range with a single positive argument generates an array of elements 0,1,2,...,n-1');
		assertEquals(_.range(5, 8), [5, 6, 7], 'range with two arguments a &amp; b, a&lt;b generates an array of elements a,a+1,a+2,...,b-2,b-1');
		assertEquals(_.range(8, 5), [], 'range with two arguments a &amp; b, b&lt;a generates an empty array');
		assertEquals(_.range(3, 10, 3), [3, 6, 9], 'range with three arguments a &amp; b &amp; c, c &lt; b-a, a &lt; b generates an array of elements a,a+c,a+2c,...,b - (multiplier of a) &lt; c');
		assertEquals(_.range(3, 10, 15), [3], 'range with three arguments a &amp; b &amp; c, c &gt; b-a, a &lt; b generates an array with a single element, equal to a');
		assertEquals(_.range(12, 7, -2), [12, 10, 8], 'range with three arguments a &amp; b &amp; c, a &gt; b, c &lt; 0 generates an array of elements a,a-c,a-2c and ends with the number not less than b');
		assertEquals(_.range(0, -10, -1), [0, -1, -2, -3, -4, -5, -6, -7, -8, -9], 'final example in the Python docs');		
	}
	
	public void function testconcat() {
		assertEquals(_.concat([], []), [], 'Concatenating two empty arrays results in an empty array');
		assertEquals(_.concat([1], [1]), [1, 1], 'Concatenating two arrays with same value results in array with both values');
		assertEquals(_.concat([], [1]), [1], 'Concatenating an empty array with a non-empty array results in non-empty array');
		assertEquals(_.concat([1], []), [1], 'Concatenating an empty array with a non-empty array results in non-empty array');
		assertEquals(_.concat([{one:1}], [{two:2}]), [{one:1}, {two:2}], 'Can concatenate arrays of structs');
		assertEquals(_.concat([true], [false]), [true, false], 'Can concatenate arrays of booleans');
	}

	public void function testTakeWhile() {
		var ary = [1, 2, 3, 4, 1, 2];

		var result = _.takeWhile(ary, function(val) {
			return val < 3;
		});

		assertEquals(result, [1, 2], 'takeWhile stops when it should');

		var result = _.takeWhile(ary, function(val) {
			return val < 1;
		});

		assertEquals(result, [], 'takeWhile can return nothing');

		var result = _.takeWhile(ary, function(val) {
			return val < 5;
		});

		assertEquals(result, [1, 2, 3, 4, 1, 2], 'takeWhile can return the whole array');
	}

	public void function testSplice() {
		var ary = [5, 4, 3, 2, 1, 0];

		var result = _.splice(ary, 1, 0);
		assertEquals(result, ary);

		var result = _.splice(ary, 1, 0, 9);
		assertEquals(result, [9, 5, 4, 3, 2, 1, 0]);

		var result = _.splice(ary, 7, 0, 9);
		assertEquals(result, [5, 4, 3, 2, 1, 0, 9]);

		var result = _.splice(ary, 1, 6, 9, 10, 11);
		assertEquals(result, [9, 10, 11]);				
	}

	public void function testPush() {
		var result = _.push([], 10);
		assertEquals(result, [10], 'Basic push');

		var result = _.push([], -22);
		assertEquals(result, [-22], 'Negative push');

		var result = _.push(["first"], "second");
		assertEquals(result, ["first", "second"], 'Pre-existing values still exist');

		var result = _.push([], 11, -33, "a", {}, [], 0, "");
		var expected = [11, -33, "a", {}, [], 0, ""];
		assertEquals(result, 
			expected, 
			'Multiple push with various types');

		var _ary = _.init([]);
		_ary.push([], 10);
		assertEquals(_ary.value(), [], 'Does not modify wrapped array');		
	}

	public void function testPop() {
		var result = _.pop([10, 20]);
		assertEquals(result, 20, 'pop returns last element');
	}

	public void function testUnshift() {
		var result = _.unshift(["last"], "first", "second");
		var expected = ["first", "second", "last"];
		assertEquals(result, expected, "adds elements to beginning of array");

		var result = _.unshift(["single"]);
		var expected = ["single"];
		assertEquals(result, expected, "adding nothing results in same array");
	}

	public void function testShift() {
		var result = _.shift(["first", "second", "third"]);
		var expected = "first";
		assertEquals(result, expected, "returns first element");
	}

	public void function testJoin() {
		var result = _.join(["one", "two", "three"]);
		var expected = "one two three";
		assertEquals(result, expected, "should join strings");

		var result = _.join([1, 2, 3]);
		var expected = "1 2 3";
		assertEquals(result, expected, "should join numbers");

		var result = _.join([1, 2], " and ");
		var expected = "1 and 2";
		assertEquals(result, expected, "custom separator");
	}

	public void function testSlice() {
		var ary = [1, 2, 3, 4, 5];
		assertEquals( [], _.slice(ary, 1, 0) );
		assertEquals( [], _.slice(ary, 2, 0) );
		assertEquals( [4, 5], _.slice(ary, 4) );
		assertEquals( [2, 3, 4], _.slice(ary, 2, 4) );
		assertEquals( [2, 3], _.slice(ary, 2, -2) );
		assertEquals( [], _.slice(ary, -1, 0) );
		assertEquals( [], _.slice(ary, -1, 3) );
		assertEquals( [5], _.slice(ary, -1, 5) );
		assertEquals( [3, 4, 5], _.slice(ary, -3, 5) );
	}

	public void function setUp() {
		variables._ = new underscore.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "_");
	}
	
}