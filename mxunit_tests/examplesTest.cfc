/**
* 	@hint Ensures that the documentation examples work as described. These are not exhaustive by any means.
*/
component extends="mxunit.framework.TestCase" {

	public void function testEach() {
		var output = [];
	    _.each([1, 2, 3], function(num){ arrayAppend(output, num); });
		assertTrue(_.has(output, 1));
	    assertTrue(_.has(output, 2));
	    assertTrue(_.has(output, 3));
	    assertEquals(3, arrayLen(output));

	    output = [];
	    _.each({one : 1, two : 2, three : 3}, function(num, key){ arrayAppend(output, num); });
		assertTrue(_.has(output, 1));
	    assertTrue(_.has(output, 2));
	    assertTrue(_.has(output, 3));
	    assertEquals(3, arrayLen(output));
	}

	public void function testMap() {
		var result = _.map([1, 2, 3], function(num){ return num * 3; }); 
		assertTrue(_.has(result, 3));
	    assertTrue(_.has(result, 6));
	    assertTrue(_.has(result, 9));
	    assertEquals(3, arrayLen(result));

		result = _.map({one : 1, two : 2, three : 3}, function(num, key){ return num * 3; });
		assertTrue(_.has(result, 3));
	    assertTrue(_.has(result, 6));
	    assertTrue(_.has(result, 9));
	    assertEquals(3, arrayLen(result));		
	}

	public void function testReduce() {
		var sum = _.reduce([1, 2, 3], function(memo, num){ return memo + num; }, 0);
		assertEquals(6, sum);
	}	

	public void function testReduceRight() {
		var list = [[0, 1], [2, 3], [4, 5]];
		var flat = _.reduceRight(list, function(a, b) { return _.concat(a, b); }, []);
		assertEquals([4, 5, 2, 3, 0, 1], flat);
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
		assertTrue(_.has(result, 10));
	    assertTrue(_.has(result, 20));
	    assertEquals(2, arrayLen(result));
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

	public void function testconcat() {
		var result = _.concat([1, 2, 3], [4, 5, 6]);
		assertEquals([1, 2, 3, 4, 5, 6], result);
	}
	
	public void function testReverse() {
		var result = _.reverse([1, 2, 3]);
		assertEquals([3, 2, 1], result);	
	}
 
	public void function testSplice() {
		var result = _.splice([10, 90, 30], 2, 1, 20);
		assertEquals([10, 20, 30], result);
		var result = _.splice([10, 90, 30], 2, 2);
		assertEquals([10], result);
	}

	public void function testSlice() {
		assertEquals( [2, 3, 4], _.slice([1, 2, 3, 4]) );
		assertEquals( [3, 4], _.slice([1, 2, 3, 4], 3) );
		assertEquals( [2, 3], _.slice([1, 2, 3, 4], 2, -1) );
		assertEquals( [2, 3], _.slice([1, 2, 3, 4], -3, -1) );
	}

	public void function testBind() {
		var func = function(args, this){ return args.greeting & ': ' & this.name; };
		func = _.bind(func, {name : 'moe'}, {greeting: 'hi'});
		var result = func();
		assertEquals('hi: moe', result);
	}
	
	public void function testBindAll() {
		var greeter = {hello: 'Hello, ', greet: function(this){ return this.hello & 'World!'; }};
		_.bindAll(greeter);
		var result = greeter.greet();
		assertEquals('Hello, World!', result);
	}
	
	public void function testMemoize() {
		var fibonacci = function(n) {  return n < 2 ? n : fibonacci(n - 1) + fibonacci(n - 2); };
		var fibonacciMemoized = _.memoize(fibonacci);
		var expected = fibonacci(15);
		var actual = fibonacciMemoized(15);
		assertEquals(expected, actual);
	}
	
	public void function testDelay() {
		var startTime = getTickCount();
		var delay = 1000;
		var result = _.delay(function (msg) {return msg;}, delay, {msg = "hi"});
		var endTime = getTickCount();
		assertEquals("hi", result);
		debug('delay was: ' & (endTime-startTime) & 'ms');
		assertTrue((endTime-startTime) >= delay, "function delay is at least as long as requested");
	}
	
	public void function testOnce() {
		var i = 0;
		var once = _.once(function () { i = i+1; return i; });
		var result = once();
		assertEquals(1, result);
		var result2 = once();
		assertEquals(1, result2);
	}
	
	public void function testAfter() {
		var funcWasCalled = false;
		var func = function () {
			funcWasCalled = true;
		};
		var callFuncAfterTwo = _.after(2, func);
		callFuncAfterTwo();
		assertEquals(false, funcWasCalled);
		callFuncAfterTwo();
		assertEquals(true, funcWasCalled);
	}
	
	public void function testWrap() {
		var hello = function(name) { return "hello: " & name; };
		hello = _.wrap(hello, function(func) {
			return "before, " & func("moe") & ", after";
		});
		var result = hello();
		assertEquals('before, hello: moe, after', result);
	}
	
	public void function testCompose() {
		var greet    = function(name){ return "hi: " & name; };
		var exclaim  = function(statement){ return statement & "!"; };
		var welcome = _.compose(exclaim, greet);
		var result = welcome('moe');
		var expected = 'hi: moe!';
		assertEquals(expected, result);
	}

	public void function testTimes() {
		var results = [];
		var i = 1;
		var genie = {
			grantWish: function () {
				arrayAppend(results, i);
				i++;
			}
		};
		_.times(3, function(){ genie.grantWish(); });
		assertEquals([1, 2, 3], results);
	}
	
	public void function testMixin() {
		_.mixin({ 
			upper: function(string) { return uCase(string); }
		});
		var result = _.upper("fabio");
		assertEquals("FABIO", result);
		//todo this assertion doesn't actually check that the case of both strings is the same
	}
	
	public void function testResult() {
		var object = {cheese: 'crumpets', stuff: function(){ return 'nonsense'; }};
		var result = _.result(object, 'cheese');
		assertEquals("crumpets", result);
		result = _.result(object, 'stuff');
		assertEquals("nonsense", result);
	}
	
	public void function testKeys() {
		var result = _.keys({ONE : 1, TWO : 2, THREE : 3});
		assertTrue(_.has(result, 'ONE'));
	    assertTrue(_.has(result, 'TWO'));
	    assertTrue(_.has(result, 'THREE'));
	    assertEquals(3, arrayLen(result));
	}
	
	public void function testValues() {
		var result = _.values({one : 1, two : 2, three : 3});
		assertTrue(_.has(result, 1));
	    assertTrue(_.has(result, 2));
	    assertTrue(_.has(result, 3));
	    assertEquals(3, arrayLen(result));
	}
	
	public void function testFunctions() {
		var obj = {
			one: "not a function",
			two: function () { return 0; },
			three: function () { return 1; }
		};
		var result = _.functions(obj);
		assertEquals(["three", "two"], result);
	}
	
	public void function testExtend() {
		var result = _.extend({name : 'moe'}, {age : 50});
		assertEquals({name : 'moe', age : 50}, result);
	}
	
	public void function testPick() {
		var result = _.pick({name : 'moe', age: 50, userid : 'moe1'}, 'name', 'age');
		assertEquals({name : 'moe', age : 50}, result);
	}
	
	public void function testDefaults() {
		var iceCream = {flavor : "chocolate"};
		var result = _.defaults(iceCream, {flavor : "vanilla", sprinkles : "lots"});
		assertEquals({flavor : "chocolate", sprinkles : "lots"}, result);
	}
	
	public void function testClone() {
		var result = _.clone({name : 'moe'});
		assertEquals({name : 'moe'}, result);
	}
	
	public void function testHas() {
		var result = _.has({a: 1, b: 2, c: 3}, "b");
		assertEquals(true, result);
		result = _.has([1, 2, 3], 3);
		assertEquals(true, result);
		result = _.has({a: 1, b: 2, c: 3}, "d");
		assertEquals(false, result);
		result = _.has([1, 2, 3], 4);
		assertEquals(false, result);
	}
	
	public void function testIsEqual() {
		var moe = {name : 'moe', luckyNumbers : [13, 27, 34]};
		clone = {name : 'moe', luckyNumbers : [13, 27, 34]};
		assertTrue(_.isEqual(moe, clone));
	}

	public void function testIsEmpty() {
		assertFalse(_.isEmpty([1, 2, 3]));
		assertTrue(_.isEmpty({}));
	}
	
	public void function testIsArray() {
		assertFalse(_.isArray({one: 1}));
		assertTrue(_.isArray([1,2,3]));
	}
	
	public void function testIsObject() {
		assertFalse(_.isObject({})); 
		assertFalse(_.isObject(1));
		assertTrue(_.isObject(new MyClass()));
	}
	
	public void function testIsFunction() {
		assertTrue(_.isFunction(function(){ return 1; }));
		assertFalse(_.isFunction(1));
	}
	
	public void function testIsString() {
		assertTrue(_.isString("moe"));
		// result = _.isString(1);
		// assertTrue(result);
		assertFalse(_.isString(JavaCast("int", 1)));
	}
	
	public void function testIsNumber() {
		var result = _.isNumber(8.4 + 5);
		assertTrue(result);
		result = _.isNumber("not a number");
		assertFalse(result);
	}
	
	public void function testIsBoolean() {
		var result = _.isBoolean(false);
		assertTrue(result);
		result = _.isBoolean("not a bool");
		assertFalse(result);
	}
	
	public void function testIsDate() {
		var result = _.isDate(now());
		assertTrue(result);
		result = _.isDate("not a date");
		assertFalse(result);
		result = _.isDate(1);
		assertFalse(result);
	}

	public void function testInvoke() {
		var result = _.invoke([{fun: function(){ return 1; }}], 'fun');
		assertEquals([1], result);	
	}
	
	public void function setUp() {
		variables._ = new underscore.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "_");
	}

}
