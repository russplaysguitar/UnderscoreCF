
component extends="mxunit.framework.TestCase" {
	
	public void function testIdentity() {
	    var moe = {name : 'moe'};
	    assertEquals(moe, _.identity(moe), 'moe is the same as his identity');		
	}
	
	public void function testTimes() {
	    var vals = [];
	    _.times(3, function (i) { ArrayAppend(vals, i); });
	    assertTrue(_.isEqual(vals, [0, 1, 2]), "is 0 indexed");
	
		// TODO: make this work someday    
	    // vals = [];
	    // _(3).times(function (i) { vals.push(i); });
	    // assertTrue(_.isEqual(vals, [0,1,2]), "works as a wrapper");
	}
	
	public void function testRandom() {
		assertEquals(0, _.random(0), 'should be 0');
		assertEquals(1, _.random(1, 1), 'should be 1');
	}

	public void function testMixin() {
	    _.mixin({
	      myReverse: function(string) {
	        return reverse(string);
	      }
	    });
	    assertEquals('aecanap', _.myReverse('panacea'), 'mixed in a function to _');
	}
	
	public void function testResult() {
		var obj = {};
		obj.w = '';
		obj.x = 'x';
		obj.y = function(){ return obj.x; };
	    assertEquals('', _.result(obj, 'w'));
	    assertEquals('x', _.result(obj, 'x'));
	    assertEquals('x', _.result(obj, 'y'));
	}
	
	public void function setUp() {
		variables._ = new underscore.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "_");
	}			
}