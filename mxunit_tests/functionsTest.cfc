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

	

	public void function setUp() {
		variables._ = new underscore.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "_");
	}
}