component extends="mxunit.framework.TestCase" {

	public void function testEach() {
	    _.each([1, 2, 3], function(num, i) {
			assertEquals(num, i, 'each iterators provide value and iteration count');
	    });

	    var answers = [];
	    var context = { multiplier = 5 };
	    _.each([1, 2, 3], function(num, k, o, this){ arrayAppend(answers, (num * this.multiplier)); }, context);
	    assertTrue(_.has(answers, 5), 'context object property accessed');
	    assertTrue(_.has(answers, 10), 'context object property accessed');
	    assertTrue(_.has(answers, 15), 'context object property accessed');
	    assertEquals(3, arrayLen(answers), 'context object property accessed');

	    answers = [];
	    _.forEach([1, 2, 3], function(num){ arrayAppend(answers, num); });
	    assertTrue(_.has(answers, 1));
	    assertTrue(_.has(answers, 2));
	    assertTrue(_.has(answers, 3));
	    assertEquals(3, arrayLen(answers));

	    answer = false;
	    _.each([1, 2, 3], function(num, index, arr){ if (_.include(arr, num)) answer = true; });
	    assertTrue(answer, 'can reference the original collection from inside the iterator');

	    var didLoop = false;
	    _.each(xmlNew(), function () {
	    	didLoop = true;
	    });
	    assertFalse(didLoop, 'no loops for empty xml doc');

	    counter = 0;
		var xml = xmlParse('<root><b>1</b><b>2</b></root>');
	    _.each(xml, function () { counter++; });
	    assertEquals(1, counter, 'looping on xml object itself yields one loop, regardless of root.xmlChildren size');

		counter = 0;
		var xml = xmlParse('<root><b>1</b><b>2</b></root>');
	    _.each(xml.root.xmlChildren, function () { counter++; });
	    assertEquals(2, counter, 'looping on root element yields multiple loops accordording to xmlChildren size');
	}

	public void function testMap() {

	    var doubled = _.map([1, 2, 3], function(num) { return num * 2; });
	    assertEquals([2, 4, 6], doubled, 'doubled numbers');

	    doubled = _.collect([1, 2, 3], function(num) { return num * 2; });
	    assertEquals([2, 4, 6], doubled, 'aliased as "collect"');

	    var context = {};
	    context.multiplier = 3;
	    var tripled = _.map([1, 2, 3], function(num, i, o, this) { return num * this.multiplier; }, context);
	    assertEquals([3, 6, 9], tripled, 'tripled numbers with context');

	    // var doubled = _([1, 2, 3]).map(function(num){ return num * 2; });
	    // assertEquals(doubled, [2, 4, 6], 'OO-style doubled numbers');
	}

	public void function testReduce(param) {
		var sum = _.reduce([1, 2, 3], function(sum, num){ return sum + num; }, 0);
		assertEquals(6, sum, 'can sum up an array');

	    var context = {};
	    context.multiplier = 3;
		sum = _.reduce([1, 2, 3], function(sum, num, m, this){ return sum + num * this.multiplier; }, 0, context);
		assertEquals(18, sum, 'can reduce with a context object');

		sum = _.inject([1, 2, 3], function(sum, num){ return sum + num; }, 0);
		assertEquals(6, sum, 'aliased as "inject"');

		// sum = _([1, 2, 3]).reduce(function(sum, num){ return sum + num; }, 0);
		// assertEquals(6, sum, 'OO-style reduce');

		var sum = _.reduce([1, 2, 3], function(sum, num){ return sum + num; });
		assertEquals(6, sum, 'default initial value');

		// raises(function() { _.reduce([], function(){}); }, TypeError, 'throws an error for empty arrays with no initial value');

		var sparseArray = [];
		sparseArray[1] = 20;
		sparseArray[3] = -5;
		assertEquals(25, _.reduce(sparseArray, function(a, b){ return (a - b); }), 'initially-sparse arrays with no memo');
	}

	public void function testReduceRight() {
		var list = _.reduceRight(["foo", "bar", "baz"], function(memo, str){ return memo & str; }, '');
		assertEquals('bazbarfoo', list, 'can perform right folds');

		var list = _.foldr(["foo", "bar", "baz"], function(memo, str){ return memo & str; }, '');
		assertEquals('bazbarfoo', list, 'aliased as "foldr"');

		var list = _.foldr(["foo", "bar", "baz"], function(memo, str){ return memo & str; });
		assertEquals('bazbarfoo', list, 'default initial value');

		var list = _.foldr(["foo", "bar", "baz"], function(memo, str, m, this){ return memo & str & this.q; }, 'start_', {q:'qux'});
		assertEquals('start_bazquxbarquxfooqux', list, 'context');

// TODO....
		// Assert that the correct arguments are being passed

	// 	var args = [];
	// 	var memo = {};
	// 	var object = {a: 1, b: 2};
	// 	var lastKey = _.keys(object).pop();

	// 	var expected = lastKey == 'a'
	// 		? [memo, 1, 'a', object]
	// 		: [memo, 2, 'b', object];

	// 	_.reduceRight(object, function() {
	// 		args || (args = _.toArray(arguments));
	// 	}, memo);

	// 	assertTrue(_.isEqual(args, expected));

	// 	// And again, with numeric keys

	// 	object = {'2': 'a', '1': 'b'};
	// 	lastKey = _.keys(object).pop();
	// 	args = null;

	// 	expected = lastKey == '2'? [memo, 'a', '2', object]: [memo, 'b', '1', object];

	// 	_.reduceRight(object, function() {args || (args = _.toArray(arguments));}, memo);

	// 	deepEqual(args, expected);
	}

	// a.k.a find()
	public void function testDetect() {
		var result = _.detect([1, 2, 3], function(num){ return num * 2 == 4; });
		assertEquals(2, result, 'found the first "2" and broke the loop');

		var xml = xmlParse('<root><child>1</child><child>2</child><child>3</child></root>');
		var result = _.find(xml.root.xmlChildren, function (node) {
			return node.xmlText == 2;
		});
		assertEquals(xml.root.xmlChildren[2], result, 'found "2" in xml children');

		var result = _.find([1], function () { return false; });
		assertTrue(!isDefined('result'));
   	}

	public void function testSelect() {
	    var evens = _.select([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });
	    assertEquals([2, 4, 6], evens, 'selected each even number');

	    evens = _.filter([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });
	    assertEquals([2, 4, 6], evens, 'aliased as "filter"');

	    var expectedIndex = 1;
	    var expectedContext = {context: 'test'};
	    var result = _.filter([10, 20, 30], function(val, index, array, this){
	    	assertEquals(expectedIndex, index, 'Index should increment for each loop');
	    	assertEquals([10, 20, 30], array, 'array should be the obj passed in');
	    	assertEquals(expectedContext, this, 'Context should be passed in as 4th param');
	    	expectedIndex++;
	    	return (val == 30);
	    }, expectedContext);

	    assertEquals([30], result, 'Iterator tests should have run');

	    var keyCorrect = false;
	    _.filter({someKey:1},function (val, key) {
	    	if (key == 'someKey') keyCorrect = true;
	    	return true;
	    });
	    assertTrue(keyCorrect, "Iterator key should be object key");
	}

	public void function testReject() {
	    var odds = _.reject([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });
	    assertEquals([1, 3, 5], odds, 'rejected each even number');

	    var expectedIndex = 1;
	    var expectedContext = {context: 'test'};
	    var result = _.reject([10, 20, 30], function(val, index, array, this){
	    	assertEquals(expectedIndex, index, 'Index should increment for each loop');
	    	assertEquals([10, 20, 30], array, 'array should be the obj passed in');
	    	assertEquals(expectedContext, this, 'Context should be passed in as 4th param');
	    	expectedIndex++;
	    	return (val != 30);
	    }, expectedContext);

	    assertEquals([30], result, 'Iterator tests should have run');

	    var keyCorrect = false;
	    _.reject({someKey:1},function (val, key) {
	    	if (key == 'someKey') keyCorrect = true;
	    	return true;
	    });
	    assertTrue(keyCorrect, "Iterator key should be object key");
	}

	public void function testAll() {
	    assertTrue(_.all([], _.identity), 'the empty set');
	    assertTrue(_.all([true, true, true], _.identity), 'all true values');
	    assertFalse(_.all([true, false, true], _.identity), 'one false value');
	    assertTrue(_.all([0, 10, 28], function(num){ return num % 2 == 0; }), 'even numbers');
	    assertFalse(_.all([0, 11, 28], function(num){ return num % 2 == 0; }), 'an odd number');
	    assertTrue(_.all([1], _.identity) == true, 'cast to boolean - true');
	    assertTrue(_.all([0], _.identity) == false, 'cast to boolean - false');
	    assertTrue(_.every([true, true, true], _.identity), 'aliased as "every"');

	    var keyCorrect = false;
	    _.all({someKey:1},function (val, key) {
	    	if (key == 'someKey') keyCorrect = true;
	    	return true;
	    });
	    assertTrue(keyCorrect, "Iterator key should be object key");
	}

	public void function testAny() {
	    assertFalse(_.any([]), 'the empty set');
	    assertFalse(_.any([false, false, false]), 'all false values');
	    assertTrue(_.any([false, false, true]), 'one true value');
	    assertTrue(_.any([0, 'yes', false]), 'a string');
	    assertFalse(_.any([0, 'no', false]), 'falsy values');
	    assertFalse(_.any([1, 11, 29], function(num){ return num % 2 == 0; }), 'all odd numbers');
	    assertTrue(_.any([1, 10, 29], function(num){ return num % 2 == 0; }), 'an even number');
	    assertTrue(_.any([1], _.identity) == true, 'cast to boolean - true');
	    assertTrue(_.any([0], _.identity) == false, 'cast to boolean - false');
	    assertTrue(_.some([false, false, true]), 'aliased as "some"');

	    var keyCorrect = false;
	    _.any({someKey:1},function (val, key) {
	    	if (key == 'someKey') keyCorrect = true;
	    	return true;
	    });
	    assertTrue(keyCorrect, "Iterator key should be object key");
	}

	public void function testInclude() {
		assertTrue(_.include([1,2,3], 2), 'two is in the array');
		assertFalse(_.include([1,3,9], 2), 'two is not in the array');
		assertTrue(_.include({moe:1, larry:3, curly:9}, 3) == true, '_.include on objects checks their values');
		// assertTrue(_([1,2,3]).include(2), 'OO-style include');
	}

	public void function testPluck() {
	    var people = [{name : 'moe', age : 30}, {name : 'curly', age : 50}];
	    assertEquals(['moe','curly'], _.pluck(people, 'name'), 'pulls names out of objects');
	}

	public void function testWhere() {
	    var list = [{a: 1, b: 2}, {a: 2, b: 2, c: 9}, {a: 1, b: 3, c: 9}, {a: 1, b: 4, c: 7}];
	    var result = _.where(list, {a: 1});
	    assertEquals(3, _.size(result));
	    assertEquals(4, result[_.size(result)].b);
	    result = _.where(list, {b: 2});
	    assertEquals(2, _.size(result));
	    assertEquals(1, result[1].a);
	    result = _.where(list, {c: 9});
	    assertEquals(2, _.size(result));
	    assertEquals(3, result[_.size(result)].b);
	}

	public void function testFindWhere() {
		var list = [{a: 1, b: 2}, {a: 2, b: 2}, {a: 1, b: 3}, {a: 1, b: 4}];
	    var result = _.findWhere(list, {a: 1});
	    assertEquals(2, result.b);
	    result = _.findWhere(list, {b: 3});
	    assertEquals(1, result.a);
	    result = _.findWhere(list, {a: 1, b: 3});
	    assertEquals(3, result.b);
	}

	public void function testMax() {
	    assertEquals(3, _.max([1, 2, 3]), 'can perform a regular Math.max');

	    var neg = _.max([1, 2, 3], function(num){ return -num; });
	    assertEquals(1, neg, 'can perform a computation-based max');
	}

	public void function testMin() {
		assertEquals(1, _.min([1, 2, 3]), 'can perform a regular Math.min');

		var neg = _.min([1, 2, 3], function(num){ return -num; });
		assertEquals(3, neg, 'can perform a computation-based min');
	}

	public void function testSortBy() {
		var people = [{name : 'curly', age : 50}, {name : 'moe', age : 30}];
		people = _.sortBy(people, function(person){ return person.age; });
		assertEquals(['moe', 'curly'], _.pluck(people, 'name'), 'stooges sorted by age');

		var list = [];
		list[2] = 4;
		list[3] = 1;
		list[5] = 3;
		list[6] = 2;
		assertEquals([1,2,3,4], _.sortBy(list, _.identity), 'sortBy with undefined values');

		var list = ["one", "two", "three", "four", "five"];
		var sorted = _.sortBy(list, function(val) { return len(val); });
		assertEquals(['one', 'two', 'four', 'five', 'three'], sorted, 'sorted by length');

		var ctx = { works: false };
		_.sortBy([1], function (v,i,c,context) {
			context.works = true;
		}, ctx);
		assertTrue(ctx.works);
	}

	public void function testGroupBy() {
	    var parity = _.groupBy([1, 2, 3, 4, 5, 6], function(num){ return num % 2; });
	    assertTrue(_.has(parity, 0), 'created a group for each value 0');
	    assertTrue(_.has(parity, 1), 'created a group for each value 1');
	    assertEquals(parity[0], [2, 4, 6], 'put each even number in the right group');

	    var list = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"];
	    var grouped = _.groupBy(list, function(val) { return len(val); });
	    assertEquals(['one', 'two', 'six', 'ten'], grouped['3']);
	    assertEquals(['four', 'five', 'nine'], grouped['4']);
	    assertEquals(['three', 'seven', 'eight'], grouped['5']);
	}

	public void function testIndexBy() {
	    var expected = { "40": {name: 'moe', age: 40}, "50": {name: 'larry', age: 50}, "60": {name: 'curly', age: 60} };
	    var parity = _.indexBy([{name: 'moe', age: 40}, {name: 'larry', age: 50}, {name: 'curly', age: 60}], 'age');

	    assertTrue(_.has(parity, 40), 'created a key for 40');
	    assertTrue(_.has(parity, 50), 'created a key for 50');
	    assertTrue(_.has(parity, 60), 'created a key for 66');

	    assertEquals(parity, expected, 'put each items in the correct group');
	}

	public void function testCountBy() {
		var parity = _.countBy([1, 2, 3, 4, 5], function(num){
			return num % 2 == 0 ? 'even' : 'odd';
		});
		assertEquals(2, parity['even']);
		assertEquals(3, parity['odd']);

		var list = [{length: 3}, {length:3}, {length: 5}, {length:4}];
		var grouped = _.countBy(list, 'length');
		assertEquals(2, grouped['3']);
		assertEquals(1, grouped['4']);
		assertEquals(1, grouped['5']);

		var context = {};
		_.countBy([{}], function(val, idx, obj, this){ assertTrue(_.isEqual(this, context)); }, context);

		grouped = _.countBy([4.2, 6.1, 6.4], function(num) {
			return fix(num) > 4 ? 'b' : 'a';
		});
		assertEquals(1, grouped.a);
		assertEquals(2, grouped.b);

		var array = [{}];
		_.countBy(array, function(value, index, obj){ assertEquals(obj, array); });
	}

	public void function testSortedIndex() {
	    var numbers = [10, 20, 30, 40, 50];
	    var num = 35;
	    var index = _.sortedIndex(numbers, num);
	    assertEquals(4, index, '35 should be inserted at index 4');
	}

	public void function testShuffle() {
		var numbers = _.range(100);
		var shuffled = _.shuffle(numbers);
		assertNotEquals(numbers, shuffled, 'shuffle actually shuffled');
		assertEquals(numbers, _.sortBy(shuffled), 'contains the same members before and after shuffle');
	}

	public void function testToArray() {
		var testStruct = {one:1, two:2};
	    assertFalse(_.isArray(testStruct), 'struct is not an array');
	    assertTrue(_.isArray(_.toArray(testStruct)), 'struct object converted into array');
	    var a = [1,2,3];
	    var newArray = _.toArray(a);
	    a[4] = 4;// modify original array
	    assertNotEquals(a, newArray, 'array is cloned');
	    assertEquals([1, 2, 3], newArray, 'cloned array contains same elements');

	    var numbers = _.toArray({one : 1, two : 2, three : 3});
	    assertTrue(_.has(numbers, 1));
	    assertTrue(_.has(numbers, 2));
	    assertTrue(_.has(numbers, 3));
	    // assertEquals(numbers, [1, 2, 3], 'object flattened into array');

	    var objectWithToArrayFunction = {toArray: function() {
	        return [1, 2, 3];
	    }};
	    assertEquals([1, 2, 3], _.toArray(objectWithToArrayFunction), 'toArray method used if present');

	    var objectWithToArrayValue = {toArray: 1};
	    assertEquals([1], _.toArray(objectWithToArrayValue), 'toArray property ignored if not a function');

	    assertEquals([1,2,'',4], _.toArray('1,2,,4'), "Empty list elements should create zero-length string value");
	    assertEquals([1,2,3,''], _.toArray('1,2,3,'), "Empty list elements should create zero-length string value");
	    assertEquals(['',2,3,4], _.toArray(',2,3,4'), "Empty list elements should create zero-length string value");
	    assertEquals(['','','',''], _.toArray(',,,'), "Empty list elements should create zero-length string value");
	    assertEquals([''], _.toArray(''), "Empty list elements should create zero-length string value");


		// note: Using _.isEqual() within this test because assertEquals() isn't currently correct for queries.
		// If converting to assertEquals (someday), please ensure that these tests can fail on mismatching queries
	    var query = QueryNew("someColumn,otherColumn");
		assertTrue(_.isEqual([], _.toArray(query)), "Should convert empty queries to empty arrays");

		var expected = [{someColumn: "someValue"}];
	    var query = QueryNew("someColumn");
		QueryAddRow(query);
		QuerySetCell(query, "someColumn", "someValue", 1);
		assertTrue(_.isEqual(expected, _.toArray(query)), "Should convert single-column queries");

		var expected = [{firstColumn: "value 1", secondColumn: "value 2"}];
	    var query = QueryNew("firstColumn,secondColumn");
		QueryAddRow(query);
		QuerySetCell(query, "firstColumn", "value 1", 1);
		QuerySetCell(query, "secondColumn", "value 2", 1);
		assertTrue(_.isEqual(expected, _.toArray(query)), "Should convert multi-column queries");

		var expected = [{firstColumn: "col1 row1", secondColumn: "col2 row1"},
					 {firstColumn: "col1 row2", secondColumn: "col2 row2"}];
		var query = QueryNew("firstColumn,secondColumn");
		QueryAddRow(query, 2);
		QuerySetCell(query, "firstColumn", "col1 row1", 1);
		QuerySetCell(query, "secondColumn", "col2 row1", 1);
		QuerySetCell(query, "firstColumn", "col1 row2", 2);
		QuerySetCell(query, "secondColumn", "col2 row2", 2);
		assertTrue(_.isEqual(expected, _.toArray(query)), "Should convert multi-column, multi-row queries");

		var expected = [];
		var xml = xmlParse('<array />');
		assertEquals(expected, _.toArray(xml), "Should convert empty xml to empty array");

		var expected = ['1'];
		var xml = xmlParse('<array><element>1</element></array>');
		assertEquals(expected, _.toArray(xml), "Should convert single-element xml to single-element array");

		var expected = ['a'];
		var xml = xmlParse('<array><element>a</element></array>');
		assertEquals(expected, _.toArray(xml), "Should convert single-element xml to single-element array");

		var expected = ['a', 'b'];
		var xml = xmlParse('<array><element>a</element><element>b</element></array>');
		assertEquals(expected, _.toArray(xml), "Should convert multi-element xml to multi-element array");

		var expected = [[]];
		var xml = xmlParse('<array><array /></array>');
		assertEquals(expected, _.toArray(xml), "Should convert nested array");

		var expected = [[], '1'];
		var xml = xmlParse('<array><array /><element>1</element></array>');
		assertEquals(expected, _.toArray(xml));

		var expected = [];
		var xml = xmlParse('<array a="1"/>');
		assertEquals(expected, _.toArray(xml), "Should ignore attributes");
	}

	public void function testToQuery() {
		// note: Using _.isEqual() within this test because assertEquals() isn't currently correct for queries.
		// If converting to assertEquals (someday), please ensure that these tests can fail on mismatching queries

		assertTrue(_.isEqual(QueryNew(""), _.toQuery([])), "Empty array returns an empty query");

		var array = [{someColumn: "StringValue"}];
		var expected = QueryNew("someColumn");
		QueryAddRow(expected);
		QuerySetCell(expected, "someColumn", "StringValue", 1);
		assertTrue(_.isEqual(array, _.toArray(expected)), "Sanity test");
		assertTrue(_.isEqual(expected, _.toQuery(array)), "Can convert a single column, single row query with a string value");

		var array = [{someColumn: 10}];
		var expected = QueryNew("someColumn");
		QueryAddRow(expected);
		QuerySetCell(expected, "someColumn", 10, 1);
		assertTrue(_.isEqual(array, _.toArray(expected)), "Sanity test");
		assertTrue(_.isEqual(expected, _.toQuery(array)), "Can convert a single column, single row query with integer value");

		var array = [{someColumn: 2.2}];
		var expected = QueryNew("someColumn");
		QueryAddRow(expected);
		QuerySetCell(expected, "someColumn", 2.2, 1);
		assertTrue(_.isEqual(array, _.toArray(expected)), "Sanity test");
		assertTrue(_.isEqual(expected, _.toQuery(array)), "Can convert a single column, single row query with float value");

		var array = [{someColumn: 0}];
		var expected = QueryNew("someColumn");
		QueryAddRow(expected);
		QuerySetCell(expected, "someColumn", 0, 1);
		assertTrue(_.isEqual(array, _.toArray(expected)), "Sanity test");
		assertTrue(_.isEqual(expected, _.toQuery(array)), "Can convert a single column, single row query with numeric zero value");

		var array = [{someColumn: "row 1"}, {someColumn: "row 2"}];
		var expected = QueryNew("someColumn");
		QueryAddRow(expected, 2);
		QuerySetCell(expected, "someColumn", "row 1", 1);
		QuerySetCell(expected, "someColumn", "row 2", 2);
		assertTrue(_.isEqual(array, _.toArray(expected)), "Sanity test");
		assertTrue(_.isEqual(expected, _.toQuery(array)), "Can convert a single column, multi-row query with string value");

		var array = [{firstColumn: "col1 row1", secondColumn: "col2 row1"},
					 {firstColumn: "col1 row2", secondColumn: "col2 row2"}];
		var expected = QueryNew("firstColumn,secondColumn");
		QueryAddRow(expected, 2);
		QuerySetCell(expected, "firstColumn", "col1 row1", 1);
		QuerySetCell(expected, "secondColumn", "col2 row1", 1);
		QuerySetCell(expected, "firstColumn", "col1 row2", 2);
		QuerySetCell(expected, "secondColumn", "col2 row2", 2);
		assertTrue(_.isEqual(array, _.toArray(expected)), "Sanity test");
		assertTrue(_.isEqual(expected, _.toQuery(array)), "Can convert a multi-column, multi-row query with string value");

		var array = [{firstColumn: "col1 row1"},
					 {secondColumn: "col2 row2"}];
		var expected = QueryNew("firstColumn,secondColumn");
		QueryAddRow(expected, 2);
		QuerySetCell(expected, "firstColumn", "col1 row1", 1);
		QuerySetCell(expected, "secondColumn", "col2 row2", 2);
		// assertTrue(_.isEqual(array, _.toArray(expected)), "Sanity test");// this doesn't work because empty cells have empty strings in them
		assertTrue(_.isEqual(expected, _.toQuery(array)), "Can convert sparse-key array of structs to a multi-column, multi-row query with string value");

		var array = [{someColumn: "val", otherColumn: "other val"}];
		var expected = QueryNew("someColumn,otherColumn");
		QueryAddRow(expected);
		QuerySetCell(expected, "someColumn", "val", 1);
		QuerySetCell(expected, "otherColumn", "other val", 1);
		assertTrue(_.isEqual(array, _.toArray(expected)), "Sanity test");
		assertTrue(_.isEqual(expected, _.toQuery(array, "someColumn,otherColumn")), "Can pass in the column name list");

		var array = [{someColumn: 10, otherColumn: "other val"}];
		var expected = QueryNew("someColumn,otherColumn");
		QueryAddRow(expected);
		QuerySetCell(expected, "someColumn", 10, 1);
		QuerySetCell(expected, "otherColumn", "other val", 1);
		assertTrue(_.isEqual(array, _.toArray(expected)), "Sanity test");
		assertTrue(_.isEqual(expected, _.toQuery(array, "someColumn,otherColumn", "integer,varchar")), "Can pass in the column type list");
	}

	public void function testToXml() {
		assertTrue(isXml(_.toXml('')), "Should return xml object");

		assertEquals(xmlParse("<element />"), _.toXml(''), "Convert empty string");
		assertEquals(xmlParse("<array />"), _.toXml([]), "Convert empty array");
		assertEquals(xmlParse("<struct />"), _.toXml({}), "Convert empty struct");
		assertEquals(xmlParse("<element />"), _.toXml(function(){}), "Convert empty function");
		assertEquals(xmlParse("<query />"), _.toXml(QueryNew('')), "Convert empty query");

		assertEquals(xmlParse("<element>0</element>"), _.toXml(0), "Convert number 0");
		assertEquals(xmlParse("<element>-1</element>"), _.toXml(-1), "Convert negative non-zero number");
		assertEquals(xmlParse("<element>-0</element>"), _.toXml(-0), "Convert negative zero");
		assertEquals(xmlParse("<element>1</element>"), _.toXml(1), "Convert non-zero number");
		assertEquals(xmlParse("<element>A</element>"), _.toXml('A'), "Convert letter");

		assertEquals(xmlParse("<array><element>A</element></array>"), _.toXml(['A']), "Convert single-element array");
		assertEquals(xmlParse("<struct><a>1</a></struct>"), _.toXml({a: 1}), "Convert single-element struct");
		assertEquals(xmlParse("<query><struct><a>1</a></struct></query>"), _.toXml(_.toQuery([{a: 1}])), "Convert single-element query");
		assertEquals(xmlParse("<object><init /></object>"), _.toXml(new MyClass()), "Convert object");
		assertEquals(xmlParse("<element>1, 2</element>"), _.toXml("1, 2"), "Convert list");
		// TODO: make list conversion work like so??? What about single-item lists, though?
		// assertEquals(xmlParse("<list><item>1</item><item>2</item></list>"), _.toXml("1, 2"), "Convert list");

		assertEquals(xmlParse("<array><element>A</element><element>1</element></array>"), _.toXml(['A', 1]), "Convert multi-element array");
		assertEquals(xmlParse("<struct><a>1</a><b>2</b></struct>"), _.toXml({a: 1, b: 2}), "Convert multi-element struct");
		assertEquals(xmlParse("<query><struct><a>1</a><b>2</b></struct></query>"), _.toXml(_.toQuery([{a: 1, b: 2}])), "Convert multi-element query");
		assertEquals(xmlParse("<object><init /><a>1</a></object>"), _.toXml(new MyClass({a: 1})), "Convert multi-property object");

		assertEquals(xmlParse("<someName />"), _.toXml('', 'someName'), "Name empty string element");
		assertEquals(xmlParse("<someName />"), _.toXml([], 'someName'), "Name empty array");
		assertEquals(xmlParse("<someName />"), _.toXml({}, 'someName'), "Name empty struct");
		assertEquals(xmlParse("<someName />"), _.toXml(function(){}, 'someName'), "Name empty function");
		assertEquals(xmlParse("<someName />"), _.toXml(QueryNew(''), 'someName'), "Name empty query");
		assertEquals(xmlParse("<someName><init /></someName>"), _.toXml(new MyClass(), 'someName'), "Name empty object");

		var expected = xmlParse("<outer><inner /></outer>");
		assertEquals(expected, _.toXml([[]], "outer", "inner"), "Name nested arrays");

		var expected = xmlParse("<e1><e2><array /></e2></e1>");
		assertEquals(expected, _.toXml([[[]]], "e1", "e2"), "Partially named nested arrays");

		var expected = xmlParse("<outer><inner>1</inner></outer>");
		assertEquals(expected, _.toXml([function(){ return 1; }], "outer", "inner"), "Name nested function");
	}

	public void function testSize() {
	    assertEquals(3, _.size({one : 1, two : 2, three : 3}), 'can compute the size of an object');
	    assertEquals(3, _.size([1, 2, 3]), 'can compute the size of an array');
	    assertEquals(3, _.size("1, 2, 3"), 'can compute the size of a comma-delimted list');
	    assertEquals(1, _.size("10"), 'can compute the size of a comma-delimted list with a single number in it');
	    assertEquals(1, _.size(99), 'can compute the size of a comma-delimted list with a single number in it');
	    assertEquals(0, _.size(), 'can compute the size of a empty value');
	}

	public void function testIssue30() {
		var expected = 'a';
		var actual = '';
		_.each({a: 1}, function (val, key) {
			actual = key;
		});
		assertEquals(expected, actual, "iterator key should be struct key");
	}

	public void function testInvoke() {
	    var String = function() {
	      local.call = function () {
	      	return 42;
	      };
	      return local;
	    };
	    var s = String("foo");
	    assertEquals(42, s.call(), "call function exists");

		var getObj = function() {
			var obj = {
				val: [],
				sort: function () {
					arraySort(obj.val, "numeric");
					return obj.val;
				}
			};
			return obj;
		};
		var obj1 = getObj();
		var obj2 = getObj();
		obj1.val = [5, 1, 7];
		obj2.val = [3, 2, 1];
		list = [obj1, obj2];
		list2 = list;
	    var result = _.invoke(list, 'sort');
	    assertEquals([1, 5, 7], result[1], 'first array sorted');
	    assertEquals([1, 2, 3], result[2], 'second array sorted');

	    var sortBackwards = function(obj) {
			arraySort(obj.val, "numeric", "desc");
			return obj.val;
		};
	    var result = _.invoke(list2, sortBackwards);
	    assertEquals([7, 5, 1], result[1], 'first array sorted');
	    assertEquals([3, 2, 1], result[2], 'second array sorted');
	}

	public void function testFind() {
		var obj = {
			one: 100
		};
		var keyIsKeyAndNotIndex = false;
		var valIsExpected = false;

		_.find(obj, function (val, key) {
			if (key == 'one') keyIsKeyAndNotIndex = true;
			if (val == 100) valIsExpected = true;
			return true;
		});

		assertTrue(keyIsKeyAndNotIndex);
		assertTrue(valIsExpected);

		var valCorrect = false;
		var idxCorrect = false;

		_.find([10], function (val, index) {
			if (val == 10) valCorrect = true;
			if (index == 1) idxCorrect = true;
			return true;
		});

		assertTrue(valCorrect);
		assertTrue(idxCorrect);
	}

	public void function setUp() {
		variables._ = new underscore.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "_");
	}
}
