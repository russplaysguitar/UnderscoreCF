/**
* @extends mxunit.framework.TestCase
*/ 
component {
	
	public void function testIdentity() {
	    var moe = {name : 'moe'};
	    assertEquals(_.identity(moe), moe, 'moe is the same as his identity');		
	}
	

	public void function testTimes() {
	    var vals = [];
	    _.times(3, function (i) { ArrayAppend(vals, i); });
	    assertTrue(_.isEqual(vals, [0, 1, 2]), "is 0 indexed");
	    
	    // vals = [];
	    // _(3).times(function (i) { vals.push(i); });
	    // assertTrue(_.isEqual(vals, [0,1,2]), "works as a wrapper");
	}
	
	

	public void function setUp() {
		variables._ = new underscore.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "_");
	}			
}