/**
* 	@hint Ensures that the documentation examples work as described. These are not exhaustive by any means.
*	@extends mxunit.framework.TestCase
*/
component {

	public void function testEach() {
		var output = [];
	    _.each([1, 2, 3], function(num){ arrayAppend(output, num); });
	    assertEquals([1,2,3], output);

	    output = [];
	    _.each({one : 1, two : 2, three : 3}, function(num, key){ arrayAppend(output, num); });
	    assertEquals([1,2,3], output); 
	}

	public void function testMap() {
		var result = _.map([1, 2, 3], function(num){ return num * 3; }); 
		assertEquals([3, 6, 9], result);

		result = _.map({one : 1, two : 2, three : 3}, function(num, key){ return num * 3; });
		assertEquals([3, 6, 9], result);		
	}		

	public void function testReduce() {
		var sum = _.reduce([1, 2, 3], function(memo, num){ return memo + num; }, 0);
		assertEquals(6, sum);
	}	

	public void function testFind() {
		var even = _.find([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });
		assertEquals(2, even);		
	}

	public void function testFilter() {
		var evens = _.filter([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });
		assertEquals([2,4,6], evens);
	}

	public void function testReject() {
		var odds = _.reject([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });
		assertEquals([1,3,5], odds);
	}
	
	public void function testAll() {
		var result = _.all([true, 1, 'no'], _.identity);
		assertEquals(false, result);

		result = _.all([true, 1, 'yes'], _.identity);
		assertEquals(true, result);		
	}
	
	public void function testAny() {
		var result = _.any([0, 'yes', false]);
		assertEquals(true, result);		
	}
	
	public void function testInclude() {
		var result = _.include([1, 2, 3], 3);
		assertEquals(true, result);
	}
	
	public void function testPluck() {
		var stooges = [{name : 'moe', age : 40}, {name : 'larry', age : 50}, {name : 'curly', age : 60}];
		var result = _.pluck(stooges, 'name');
		assertEquals(["moe", "larry", "curly"], result);
	}
	
	public void function testMax() {
		var stooges = [{name : 'moe', age : 40}, {name : 'larry', age : 50}, {name : 'curly', age : 60}];
		var result = _.max(stooges, function(stooge){ return stooge.age; });
		assertEquals({name : 'curly', age : 60}, result);		
	}
	
	public void function testMin() {
		var numbers = [10, 5, 100, 2, 1000];
		var result = _.min(numbers);		
		assertEquals(2, result);
	}
	
	public void function testSortBy() {
		var result = _.sortBy([6, 2, 4, 3, 5, 1], function(num){ return num; });
		assertEquals([1, 2, 3, 4, 5, 6], result);
	}
	
	public void function testGroupBy() {
		var result = _.groupBy([1.3, 2.1, 2.4], function(num){ return fix(num); });
		assertEquals({1: [1.3], 2: [2.1, 2.4]}, result);

		result = _.groupBy(['one', 'two', 'three'], function(num) { return len(num); });
		assertEquals({3: ["one", "two"], 5: ["three"]}, result);
	}
	
	public void function testSortedIndex() {
		var result = _.sortedIndex([10, 20, 30, 40, 50], 35);
		assertEquals(4, result);
	}
	
	public void function testShuffle() {
		var result = _.shuffle([1, 2, 3, 4, 5, 6]);
		// note: this should fail sometimes
		// todo: make this never fail somehow?
		assertNotEquals([1, 2, 3, 4, 5, 6], result);
	}
	
	public void function testToArray() {
		var result = _.toArray({a:10,b:20});
		assertEquals([10, 20], result);
	}
	
	public void function testSize() {
		var result = _.size({one : 1, two : 2, three : 3});
		assertEquals(3, result);
	}
	
	public void function testFirst() {
		var result = _.first([5, 4, 3, 2, 1]);
		assertEquals(5, result);
	}
	
	public void function testInitial() {
		var result = _.initial([5, 4, 3, 2, 1]);
		assertEquals([5, 4, 3, 2], result);
	}
	
	public void function testLast() {
		var result = _.last([5, 4, 3, 2, 1]);
		assertEquals(1, result);
	}
	
	public void function testRest() {
		var result = _.rest([5, 4, 3, 2, 1]);
		assertEquals([4, 3, 2, 1], result);
	}
	
	public void function testCompact() {
		var result = _.compact([0, 1, false, 2, '', 3]);
		assertEquals([1, 2, 3], result);
	}
	
	public void function testFlatten() {
		var result = _.flatten([1, [2], [3, [[4]]]]);
		assertEquals([1, 2, 3, 4], result);

		result = _.flatten([1, [2], [3, [[4]]]], true);
		assertEquals([1, 2, 3, [[4]]], result);
	}
	
	public void function testWithout() {
		var result = _.without([1, 2, 1, 0, 3, 1, 4], [0, 1]);
		assertEquals([2, 3, 4], result);
	}
	
	public void function testUnion() {
		var result = _.union([1, 2, 3], [101, 2, 1, 10], [2, 1]);
		assertEquals([1, 2, 3, 101, 10], result);
	}
	
	public void function testIntersection() {
		var result = _.intersection([1, 2, 3], [101, 2, 1, 10], [2, 1]);
		assertEquals([1, 2], result);
	}
	
	public void function testDifference() {
		var result = _.difference([1, 2, 3, 4, 5], [5, 2, 10]);
		assertEquals([1, 3, 4], result);
	}

	public void function testUniq() {
		var result = _.uniq([1, 2, 1, 3, 1, 4]);
		assertEquals([1, 2, 3, 4], result);
	}
	
	public void function testZip() {
		var result = _.zip(['moe', 'larry', 'curly'], [30, 40, 50], [true, false, false]);
		var expected = [["moe", 30, true], ["larry", 40, false], ["curly", 50, false]];
		assertEquals(expected, result);
	}
	
	public void function testIndexOf() {
		var result = _.indexOf([1, 2, 3], 2);
		assertEquals(2, result);
	}
	
	public void function testLastIndexOf() {
		var result = _.lastIndexOf([1, 2, 3, 1, 2, 3], 2);
		assertEquals(5, result);
	}
	
	public void function testRange() {
		var result = _.range(10);
		assertEquals([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], result);
		result = _.range(1, 11);
		assertEquals([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], result);
		result = _.range(0, 30, 5);
		assertEquals([0, 5, 10, 15, 20, 25], result);
		result = _.range(0, -10, -1);
		assertEquals([0, -1, -2, -3, -4, -5, -6, -7, -8, -9], result);
		result = _.range(0);
		assertEquals([], result);
	}
	
	
	
	
	
	
	
	public void function setUp() {
		variables._ = new github.UnderscoreCF.Underscore();
	}


	public void function tearDown() {
		structDelete(variables, "_");
	}
	
		
}
