component displayname="ChainingTest" extends="mxunit.framework.TestCase" {

    public void function setUp() {
        variables._ = new underscore.Underscore();
    }

    public void function tearDown() {
        structDelete(variables, "_");
    }

    function testChainZeroMethods() {
        var arr = [1, 2, 3, 4];
        var actual = _.chain(arr).value();
        assertEquals(arr, actual, "The same value should be returned if no operations were performed.");
    }

    function testChainOneMethod() {
        var arr = [1, 2, 3, 4];
        var actual = _.chain(arr).reduce(function(sum, value) {
            return sum + value;
        }, 0).value();
        assertEquals(10, actual, "Sum should be 10");
    }

    function testChainSomeMethods() {
        var arr = [1, 2, 3, 4];
        var actual = _.chain(arr).map(function(item) {
            return item * 2;
        }).reduce(function(sum, value) {
            return sum + value;
        }, 0).value();
        assertEquals(20, actual, "Sum should be 20");
    }

    function testChainWithConstructorArg() {
        var arr = [1, 2, 3, 4];
        variables._ = new underscore.Underscore(arr);
        var actual = _.chain().map(function(item) {
            return item * 2;
        }).reduce(function(sum, item) {
            return sum + item;
        }, 0).value();
        assertEquals(20, actual, "Sum should be 20, using constructor argument.");
    }

    function testChainNoConstructorOrFunctionArg() {
        var actual = _.chain().value();
        assertEquals({}, actual, "empty struct should be returned when no args provided to chain");
    }
}