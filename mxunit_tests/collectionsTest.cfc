/**
*	@extends mxunit.framework.TestCase
*/
component {

	public void function testEach() {
	    _.each([1, 2, 3], function(num, i) {
			assertEquals(num, i, 'each iterators provide value and iteration count');
	    });

	    var answers = [];
	    var context = new Component();
	    context.multiplier = 5;
	    _.each([1, 2, 3], function(num){ arrayAppend(answers, (num * this.multiplier)); }, context);
	    assertEquals(answers, [5, 10, 15], 'context object property accessed');

	    answers = [];
	    _.forEach([1, 2, 3], function(num){ arrayAppend(answers, num); });
	    assertEquals(answers, [1, 2, 3], 'aliased as "forEach"');

	    answer = false;
	    _.each([1, 2, 3], function(num, index, arr){ if (_.include(arr, num)) answer = true; });
	    assertTrue(answer, 'can reference the original collection from inside the iterator');
	}
	
	public void function testMap() {

	    var doubled = _.map([1, 2, 3], function(num) { return num * 2; });
	    assertEquals(doubled, [2, 4, 6], 'doubled numbers');

	    doubled = _.collect([1, 2, 3], function(num) { return num * 2; });
	    assertEquals(doubled, [2, 4, 6], 'aliased as "collect"');

	    var context = new Component();
	    context.multiplier = 3;
	    var tripled = _.map([1, 2, 3], function(num) { return num * this.multiplier; }, context);
	    assertEquals(tripled, [3, 6, 9], 'tripled numbers with context');

	    // var doubled = _([1, 2, 3]).map(function(num){ return num * 2; });
	    // assertEquals(doubled, [2, 4, 6], 'OO-style doubled numbers');
	}
	
	public void function testReduce(param) {
		var sum = _.reduce([1, 2, 3], function(sum, num){ return sum + num; }, 0);
		assertEquals(sum, 6, 'can sum up an array');

	    var context = new Component();
	    context.multiplier = 3;
		sum = _.reduce([1, 2, 3], function(sum, num){ return sum + num * this.multiplier; }, 0, context);
		assertEquals(sum, 18, 'can reduce with a context object');

		sum = _.inject([1, 2, 3], function(sum, num){ return sum + num; }, 0);
		assertEquals(sum, 6, 'aliased as "inject"');

		// sum = _([1, 2, 3]).reduce(function(sum, num){ return sum + num; }, 0);
		// assertEquals(sum, 6, 'OO-style reduce');

		var sum = _.reduce([1, 2, 3], function(sum, num){ return sum + num; });
		assertEquals(sum, 6, 'default initial value');

		// raises(function() { _.reduce([], function(){}); }, TypeError, 'throws an error for empty arrays with no initial value');

		var sparseArray = [];
		sparseArray[1] = 20;
		sparseArray[3] = -5;
		assertEquals(_.reduce(sparseArray, function(a, b){ return (a - b); }), 25, 'initially-sparse arrays with no memo');
	}
	
	public void function testDetect() {
	   var result = _.detect([1, 2, 3], function(num){ return num * 2 == 4; });
	   assertEquals(result, 2, 'found the first "2" and broke the loop');
   	}
	
	public void function testSelect() {
	    var evens = _.select([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });
	    assertEquals(evens, [2, 4, 6], 'selected each even number');

	    evens = _.filter([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });
	    assertEquals(evens, [2, 4, 6], 'aliased as "filter"');
	}
	
	public void function testReject() {
	    var odds = _.reject([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });		
	    assertEquals(odds, [1, 3, 5], 'rejected each even number');
	}
	
	public void function testAll() {
	    assertTrue(_.all([], _.identity), 'the empty set');
	    assertTrue(_.all([true, true, true], _.identity), 'all true values');
	    assertTrue(!_.all([true, false, true], _.identity), 'one false value');
	    assertTrue(_.all([0, 10, 28], function(num){ return num % 2 == 0; }), 'even numbers');
	    assertTrue(!_.all([0, 11, 28], function(num){ return num % 2 == 0; }), 'an odd number');
	    assertTrue(_.all([1], _.identity) == true, 'cast to boolean - true');
	    assertTrue(_.all([0], _.identity) == false, 'cast to boolean - false');
	    assertTrue(_.every([true, true, true], _.identity), 'aliased as "every"');
	}
	
	public void function testAny() {
	    assertTrue(!_.any([]), 'the empty set');
	    assertTrue(!_.any([false, false, false]), 'all false values');
	    assertTrue(_.any([false, false, true]), 'one true value');
	    assertTrue(_.any([0, 'yes', false]), 'a string');
	    assertTrue(!_.any([0, 'no', false]), 'falsy values');
	    assertTrue(!_.any([1, 11, 29], function(num){ return num % 2 == 0; }), 'all odd numbers');
	    assertTrue(_.any([1, 10, 29], function(num){ return num % 2 == 0; }), 'an even number');
	    assertTrue(_.any([1], _.identity) == true, 'cast to boolean - true');
	    assertTrue(_.any([0], _.identity) == false, 'cast to boolean - false');
	    assertTrue(_.some([false, false, true]), 'aliased as "some"');
	}
	
	public void function testInclude() {
		assertTrue(_.include([1,2,3], 2), 'two is in the array');
		assertTrue(!_.include([1,3,9], 2), 'two is not in the array');
		assertTrue(_.include({moe:1, larry:3, curly:9}, 3) == true, '_.include on objects checks their values');
		// assertTrue(_([1,2,3]).include(2), 'OO-style include');
	}
	
	public void function testPluck() {
	    var people = [{name : 'moe', age : 30}, {name : 'curly', age : 50}];
	    assertEquals(_.pluck(people, 'name'), ['moe','curly'], 'pulls names out of objects');
	}
	
	public void function testMax() {
	    assertEquals(3, _.max([1, 2, 3]), 'can perform a regular Math.max');

	    var neg = _.max([1, 2, 3], function(num){ return -num; });
	    assertEquals(neg, 1, 'can perform a computation-based max');
	}
	
	public void function testMin() {
		assertEquals(1, _.min([1, 2, 3]), 'can perform a regular Math.min');

		var neg = _.min([1, 2, 3], function(num){ return -num; });
		assertEquals(neg, 3, 'can perform a computation-based min');
	}
	
	public void function testSortBy() {
		var people = [{name : 'curly', age : 50}, {name : 'moe', age : 30}];
		people = _.sortBy(people, function(person){ return person.age; });
		assertEquals(_.pluck(people, 'name'), ['moe', 'curly'], 'stooges sorted by age');

		var list = [];
		list[2] = 4;
		list[3] = 1;
		list[5] = 3;
		list[6] = 2;
		assertEquals(_.sortBy(list, _.identity), [1,2,3,4], 'sortBy with undefined values');

		var list = ["one", "two", "three", "four", "five"];
		var sorted = _.sortBy(list, function(val) { return len(val); });
		assertEquals(sorted, ['one', 'two', 'four', 'five', 'three'], 'sorted by length');
	}
	
	public void function testGroupBy() {
	    var parity = _.groupBy([1, 2, 3, 4, 5, 6], function(num){ return num % 2; });
	    assertTrue(_.has(parity, 0), 'created a group for each value 0');
	    assertTrue(_.has(parity, 1), 'created a group for each value 1');
	    assertEquals(parity[0], [2, 4, 6], 'put each even number in the right group');

	    var list = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"];
	    var grouped = _.groupBy(list, function(val) { return len(val); });
	    assertEquals(grouped['3'], ['one', 'two', 'six', 'ten']);
	    assertEquals(grouped['4'], ['four', 'five', 'nine']);
	    assertEquals(grouped['5'], ['three', 'seven', 'eight']);		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


	public void function setUp() {
		variables._ = new github.UnderscoreCF.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "_");
	}	
}