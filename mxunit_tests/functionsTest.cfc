
component extends="mxunit.framework.TestCase" {

	public void function testBind() {
	    var context = new MyClass({name : 'moe'});
	    var func = function(arg, this) { 
			// writeDump(arg);
			if (isDefined("this.name")) {
				return "name: " & this.name;
			}
			else if (structKeyExists(arguments, "arg")) {
				return "name: " & arguments.arg;
			}
			else {
				throw "oops";
			}
		};
	    var bound = _.bind(func, context);
	    assertEquals('name: moe', bound(), 'can bind a function to a context');		

	    // TODO: once OO-style binding is ready
	    // bound = _(func).bind(context);
	    // equal('name: moe', bound(), 'can do OO-style binding');

	    bound = _.bind(func, {}, 'curly');
	    assertEquals('name: curly', bound(), 'can bind without specifying a context');

	    func = function(salutation, name) { return salutation & ': ' & name; };
	    
	    func = _.bind(func, {}, 'hello');
	    assertEquals('hello: moe', func('moe'), 'the function was partially applied in advance');

	    var func2 = _.bind(func, {}, 'curly');
	    assertEquals('hello: curly', func2(), 'the function was completely applied in advance');

	    var func = function(salutation, firstname, lastname) { return salutation & ': ' & firstname & ' ' & lastname; };
	    func = _.bind(func, {}, 'hello', 'moe', 'curly');
	    assertEquals('hello: moe curly', func(), 'the function was partially applied in advance and can accept multiple arguments');
	}

	public void function testBindAll() {
	    var curly = {name : 'curly'};
	    var moe = {
	      name    : 'moe',
	      getName : function(this) { return 'name: ' & this.name; },
	      sayHi   : function(this) { return 'hi: ' & this.name; }
	    };
	    curly.getName = moe.getName;
	    _.bindAll(moe, 'getName', 'sayHi');
	    curly.sayHi = moe.sayHi;

	    assertEquals('hi: moe', curly.sayHi(), 'bound function is still bound to original object');

	    curly = {name : 'curly'};
	    moe = {
	      name    : 'moe',
	      getName : function(this) { return 'name: ' & this.name; },
	      sayHi   : function(this) { return 'hi: ' & this.name; }
	    };
	    _.bindAll(moe);
	    curly.sayHi = moe.sayHi;
	    assertEquals('hi: moe', curly.sayHi(), 'calling bindAll with no arguments binds all functions to the object');	
	}
	
	public void function testMemoize() {
	    var fib = function(n) {
	      return n < 2 ? n : fib(n - 1) + fib(n - 2);
	    };
	    var fastFib = _.memoize(fib);
	    assertEquals(55, fib(10), 'a memoized version of fibonacci produces identical results');
	    assertEquals(55, fastFib(10), 'a memoized version of fibonacci produces identical results');

	    var o = function(str) {
	      return str;
	    };
	    var fastO = _.memoize(o);
	    assertEquals('toString', o('toString'), 'checks hasOwnProperty');
	    assertEquals('toString', fastO('toString'), 'checks hasOwnProperty');
	}
	
	public void function testOnce() {
	    var num = 0;
	    var increment = _.once(function(){ num++; });
	    increment();
	    increment();
	    assertEquals(1, num, "once prevents duplicate invocation");

	    var num = 0;
	    var increment2 = _.once(function(){ num++; return num; });
		var result1 = increment2();
		var result2 = increment2();
		assertEquals(result1, result2, "once prevents duplicate invocation");
	}
	
	public void function testWrap() {
	    var greet = function(name){ return "hi: " & name; };
	    var backwards = _.wrap(greet, function(name, func){ return func(name) & ' ' & reverse(name); });
	    assertEquals('hi: moe eom', backwards('moe'), 'wrapped the saluation function');

	    var inner = function(){ return "Hello "; };
	    var obj   = {name : "Moe"};
	    obj.hi    = _.wrap(inner, function(func){ return func() & obj.name; });
	    assertEquals("Hello Moe", obj.hi());

	    var noop    = function(){};
	    var wrapped = _.wrap(noop, function(input){ return _.slice(arguments, 1); });
	    var ret     = wrapped(['whats', 'your'], 'vector', 'victor');
	    var expected = [['whats', 'your'], 'vector', 'victor', noop];
	    assertTrue(_.isEqual(_.sortBy(expected), _.sortBy(ret)));
	}
	
	public void function testCompose() {
	    var greet = function(name){ return "hi: " & name; };
	    var exclaim = function(sentence){ return sentence & '!'; };
	    var composed = _.compose(exclaim, greet);
	    assertEquals('hi: moe!', composed('moe'), 'can compose a function that takes another');

	    composed = _.compose(greet, exclaim);
	    assertEquals('hi: moe!', composed('moe'), 'in this case, the functions are also commutative');		
	}

	public void function testAfter() {
	    var testAfter = function(afterAmount, timesCalled) {
	      var afterCalled = 0;
	      var after = _.after(afterAmount, function() {
	        afterCalled++;
	      });
	      while (timesCalled--) after();
	      return afterCalled;
	    };

	    assertEquals(1, testAfter(5, 5), "after(N) should fire after being called N times");
	    assertEquals(0, testAfter(5, 4), "after(N) should not fire unless called N times");
	    assertEquals(1, testAfter(0, 0), "after(0) should fire immediately");
	}

	public void function testDebounce_ImmediateFalse(){
		var touchCount = 0;
		var startTime = getTickCount();
		var toucher = function(){
			touchCount++;
			return touchCount;
		};
		toucher(); // touchCount==1
		assertEquals(1, touchCount, "closure isn't working...");

		var lazyToucher = _.debounce(toucher, 20);

		for (var i = 0; i < 3; i++){
			sleep(10);
			lazyToucher();
		}

		var currentTime = getTickCount() - startTime;
		debug("time since first call: " & currentTime & "ms");

		sleep(30);
		currentTime = getTickCount() - startTime;
		debug('total time: ' & currentTime & 'ms');
		debug(cfthread);
		assertTrue(currentTime >= 435, "not waiting long enough!!!!!!11eleven");
		debug('final touchCount: ' & touchCount);
		assertEquals(2, touchCount, "debounce calms overzealous method calling");
	}

	public void function testDebounce_ImmediateTrue(){
		var touchCount = 0;
		var startTime = getTickCount();
		var toucher = function(){
			touchCount++;
			return touchCount;
		};
		toucher(); // touchCount==1
		assertEquals(1, touchCount, "closure isn't working...");

		var lazyToucher = _.debounce(toucher, 20, true);

		for (var i = 0; i < 3; i++){
			sleep(10);
			lazyToucher();
		}

		assertEquals(2, touchCount, 'once on the leading edge');

		sleep(30); //allow cooldown period

		for (var i = 0; i < 3; i++){
			sleep(10);
			lazyToucher();
		}

		assertEquals(3, touchCount, 'second time on the leading edge (after cooldown)');
	}
	
	public void function setUp() {
		variables._ = new underscore.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "_");
	}
}