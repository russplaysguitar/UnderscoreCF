/**
* @extends mxunit.framework.TestCase
*/
component {

	public void function testBind() {
	    var context = new MyClass({name : 'moe'});
	    var func = function(arg) { 
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
	    assertEquals(bound(), 'name: moe', 'can bind a function to a context');		

	    // TODO: once OO-style binding is ready
	    // bound = _(func).bind(context);
	    // equal(bound(), 'name: moe', 'can do OO-style binding');

	    bound = _.bind(func, {}, 'curly');
	    assertEquals(bound(), 'name: curly', 'can bind without specifying a context');

	    func = function(salutation, name) { return salutation & ': ' & name; };
	    
	    func = _.bind(func, {}, 'hello');
	    assertEquals(func('moe'), 'hello: moe', 'the function was partially applied in advance');

	    var func2 = _.bind(func, {}, 'curly');
	    assertEquals(func2(), 'hello: curly', 'the function was completely applied in advance');

	    var func = function(salutation, firstname, lastname) { return salutation & ': ' & firstname & ' ' & lastname; };
	    func = _.bind(func, {}, 'hello', 'moe', 'curly');
	    assertEquals(func(), 'hello: moe curly', 'the function was partially applied in advance and can accept multiple arguments');
	}

	public void function testBindAll() {
	    var curly = {name : 'curly'};
	    var moe = {
	      name    : 'moe',
	      getName : function() { return 'name: ' & this.name; },
	      sayHi   : function() { return 'hi: ' & this.name; }
	    };
	    curly.getName = moe.getName;
	    _.bindAll(moe, 'getName', 'sayHi');
	    curly.sayHi = moe.sayHi;

	    assertEquals(curly.sayHi(), 'hi: moe', 'bound function is still bound to original object');

	    curly = {name : 'curly'};
	    moe = {
	      name    : 'moe',
	      getName : function() { return 'name: ' & this.name; },
	      sayHi   : function() { return 'hi: ' & this.name; }
	    };
	    _.bindAll(moe);
	    curly.sayHi = moe.sayHi;
	    assertEquals(curly.sayHi(), 'hi: moe', 'calling bindAll with no arguments binds all functions to the object');	
	}
	
	public void function testMemoize() {
	    var fib = function(n) {
	      return n < 2 ? n : fib(n - 1) + fib(n - 2);
	    };
	    var fastFib = _.memoize(fib);
	    assertEquals(fib(10), 55, 'a memoized version of fibonacci produces identical results');
	    assertEquals(fastFib(10), 55, 'a memoized version of fibonacci produces identical results');

	    var o = function(str) {
	      return str;
	    };
	    var fastO = _.memoize(o);
	    assertEquals(o('toString'), 'toString', 'checks hasOwnProperty');
	    assertEquals(fastO('toString'), 'toString', 'checks hasOwnProperty');
	}
	
	public void function testOnce() {
	    var num = 0;
	    var increment = _.once(function(){ num++; });
	    increment();
	    increment();
	    assertEquals(num, 1);

	    var num = 0;
	    var increment2 = _.once(function(){ num++; return num; });
		var result1 = increment2();
		var result2 = increment2();
		assertEquals(result1, result2);
	}
	
	
	
	
	

	public void function setUp() {
		variables._ = new underscore.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "_");
	}
}