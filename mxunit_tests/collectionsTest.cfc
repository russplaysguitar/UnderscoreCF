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
	
	
	
	


	public void function setUp() {
		variables._ = new github.UnderscoreCF.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "_");
	}	
}