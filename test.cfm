<cffunction name="flush">
	<cfflush />
</cffunction>

start tests:<br />
<br />
<cfscript>
	myStruct= {a:1,b:2};
	myArr = [1,2,3];
	myObj = new Component();
	myObj.a = 1;
	myObj.b = 2;
	myObj.c = 3;

	_ = new Underscore();

	_myStruct = new Underscore(myStruct);
	_myArr = new Underscore(myArr);
	_myObj = new Underscore(myObj);

	_.forEach(myStruct, function(val, key) {
		writeDump(key & ": " & val);
	});
	writeOutput("<br />");
	
	_.forEach(myArr, function(val, key) {
		writeDump(key & ": " & val);
	});
	writeOutput("<br />");
	
	_.forEach(myObj, function(val, key) {
		writeDump(key & ": " & val);
	});	
	writeOutput("<br />");
	
	collectObj = _myObj.collect(iterator = function(val, key) {
		return(key & ": " & val);
	});	
	writeDump(collectObj);
	writeOutput("<br />");

	collectArr = _myArr.collect(iterator = function(val, key) {
		return(key & ": " & val);
	});	
	writeDump(collectArr);
	writeOutput("<br />");

	reduceObj = _myObj.reduce(iterator = function(memo, num){
		return memo + num;
	}, memo = 0);
	writeDump(reduceObj);
	writeOutput("<br />");

	reduceArr = _myArr.reduce(iterator = function(memo, num){
		return memo + num;
	}, memo = 0);
	writeDump(reduceArr);	

	even = _.find([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });
	writeDump(even);
	writeOutput("<br />");

	any = _.any(obj = [0, 'yes', false], iterator = function(val) {
		return val;
	});
	writeDump(any);
	writeOutput("<br />");	

	evens = _.filter([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });
	writeDump(evens);
	writeOutput("<br />");	

	odds = _.reject([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });
	writeDump(odds);
	writeOutput("<br />");	

	all = _.all([2, 3, 4], function(val) {
		return val > 1;
	});
	writeDump(all);
	writeOutput("<br />");	

	include = _.include([1, 2, 3], 3);
	writeDump("include:" & include);
	writeOutput("<br />");	

	writeOutput("pluck: ");
	stooges = [{name : 'moe', age : 40}, {name : 'larry', age : 50}, {name : 'curly', age : 60}];
	pluck = _.pluck(stooges, 'name');
	writeDump(pluck);
	writeOutput("<br />");	
	stooges = [{name : 'moe', age : 40}, {name : 'larry', age : 50}, {name : 'curly', age : 60}];
	pluck2 = _.pluck(stooges, function (elem) { return elem.name;});
	writeDump(pluck2);
	writeOutput("<br />");

	stooges = [{name : 'moe', age : 40}, {name : 'larry', age : 50}, {name : 'curly', age : 60}];
	max = _.max(stooges, function(stooge){ return stooge.age; });
	writeOutput("max");
	writeDump(max);
	writeOutput("<br />");	

	max = _.max([1,2,3,4]);
	writeOutput("max");
	writeDump(max);
	writeOutput("<br />");	

	writeOutput("min");
	writeDump(_.min([10, 5, 100, 2, 1000]));
	writeOutput("<br />");


	invokeObj = [
		{
			x:1,
			z:function(){return true;}
		},{
			x:2,
			z:function(){return false;}
		}
	];
	invoke = _.invoke(invokeObj, function (args){return args;}, {z:10});
	writeDump(invoke);
	writeOutput("<br />");


	toArray = _.toArray({a:10,b:20});
	writeDump(toArray);
	writeOutput("<br />");

	writeOutput("slice: ");
	slice1 = _.slice([1,2,3,4,5,6],1);
	writeDump(slice1);
	slice2 = _.slice([1,2,3,4,5,6],2,3);
	writeDump(slice2);
	slice3 = _.slice([1,2,3,4,5,6],7);
	writeDump(slice3);

	writeOutput("sort:");
	sort = _.sort([10,1,5,20,15,3]);
	writeDump(sort);
	writeOutput("<br />");	

	writeOutput("sort by:");
	sortBy = _.sortBy([7, 2, 3, 1, 5, 6], function(num){ return num; });
	writeDump(sortBy);
	writeOutput("<br />");

	writeOutput("groupby:");
	groupBy = _.groupBy([1.3, 2.1, 2.4], function(num){ return fix(num); });
	writeDump(groupBy);
	writeOutput("<br />");

	groupBy2 = _.groupBy([{name:'one', length:3}, {name:'two', length:3}, {name:'three', length:5}], 'length');
	writeDump(groupBy2);
	writeOutput("<br />");

	sortedIndex = _.sortedIndex([10, 20, 30, 40, 50], 35);
	writeDump(sortedIndex);
	writeOutput("<br />");	

	writeOutput("shuffle: ");
	shuffle = _.shuffle([1, 2, 3, 4, 5, 6]);
	writeDump(shuffle);
	writeOutput("<br />");	

	writeOutput("first:");
	first = _.first([5, 4, 3, 2, 1]);
	writeDump(first);
	writeOutput("<br />");	

	first2 = _.first([5, 4, 3, 2, 1], 3);
	writeDump(first2);
	writeOutput("<br />");	

	writeOutput("initial:");
	initial = _.initial([5, 4, 3, 2, 1]);
	writeDump(initial);
	writeOutput("<br />");	

	initial2 = _.initial([5, 4, 3, 2, 1], 3);
	writeDump(initial2);
	writeOutput("<br />");	

	writeOutput("last");
	last = _.last([5, 4, 3, 2, 1]);
	writeDump(last);
	writeOutput("<br />");	

	last2 = _.last([5, 4, 3, 2, 1], 3);
	writeDump(last2);
	writeOutput("<br />");	

	writeOutput("rest");
	rest = _.rest([5, 4, 3, 2, 1]);
	writeDump(rest);
	writeOutput("<br />");	

	rest2 = _.rest([5, 4, 3, 2, 1], 3);
	writeDump(rest2);
	writeOutput("<br />");	

	writeOutput("compact: ");
	compact = _.compact([0, 1, false, 2, '', 3]);
	writeDump(compact);
	writeOutput("<br />");	

	writeOutput("flatten: ");
	flatten = _.flatten([1, [2], [3, [[4]]]]);
	writeDump(flatten);
	writeOutput("<br />");

	flatten2 = _.flatten([1, [2], [3, [[4]]]], true);
	writeDump(flatten2);
	writeOutput("<br />");	

	writeOutput("without:");
	without = _.without([1, 2, 1, 0, 3, 1, 4], [0, 1]);
	writeDump(without);	
	writeOutput("<br />");	

	writeOutput("difference: ");
	difference = _.difference([1, 2, 3, 4, 5], [5, 2, 10]);
	writeDump(difference);	
	writeOutput("<br />");	

	writeOutput("uniq:");
	uniq = _.uniq([1, 2, 1, 3, 1, 4]);
	writeDump(uniq);
	writeOutput("<br />");	

	uniq = _.uniq([1, 2, 3, 3, 4, 4, 5], true);
	writeDump(uniq);
	writeOutput("<br />");

	uniq = _.uniq([1, 2, 3, 3, 4, 4, 5], true, function (val) { return val; });
	writeDump(uniq);
	writeOutput("<br />");	

	writeOutput("union: ");
	union = _.union([1, 2, 3], [101, 2, 1, 10], [2, 1]);
	writeDump(union);
	writeOutput("<br />");

	writeOutput("intersection: ");
	intersection = _.intersection([1, 2, 3], [101, 2, 1, 10], [2, 1]);
	writeDump(intersection);
	writeOutput("<br />");

	writeOutput("zip: ");
	zip = _.zip(['moe', 'larry', 'curly'], [30, 40, 50], [true, false, false]);
	writeDump(zip);
	writeOutput("<br />");

	writeOutput("indexOf: ");
	lastIndexOf = _.lastIndexOf([10, 2, 3, 4, 3, 11], 10, false);
	writeDump(lastIndexOf);
	writeOutput("<br />");
	lastIndexOf = _.lastIndexOf([1, 2, 3, 4, 6, 10], 10, true);
	writeDump(lastIndexOf);
	writeOutput("<br />");

	writeOutput("lastIndexOf");
	lastIndexOf = _.lastIndexOf([1, 2, 3, 1, 2, 3], 2);
	writeDump(lastIndexOf);
	writeOutput("<br />");

	writeOutput("range: ");
	range = _.range(10);
	writeDump(range);
	writeOutput("<br />");

	range2 = _.range(1, 11);
	writeDump(range2);
	writeOutput("<br />");

	range3 = _.range(0, 30, 5);
	writeDump(range3);
	writeOutput("<br />");

	range4 = _.range(0, -10, -1);
	writeDump(range4);
	writeOutput("<br />");

	range5 = _.range(0);
	writeDump(range5);
	writeOutput("<br />");

	writeOutput("bind: <br />");
	func = function(greeting) { 
		return greeting & ': ' & this.name;
	};
	func = _.bind(func, {name:'moe'}, {greeting:'hi'});
	writeDump(func());
	writeOutput("<br />");

	writeOutput("bindAll: ");
	buttonView = {
	  label   : 'underscore',
	  onClick : function(){ writeOutput('clicked: ' & this.label); },
	  onHover : function(){ writeOutput('hovering: ' & this.label); }
	};
	bindAll = _.bindAll(buttonView);
	writeDump(bindAll);
	bindAll.onclick();
	writeOutput("<br />");
	bindAll.onHover();


	// writeOutput("<br />");
	// a = {};
	// b = [1];
	// a[b] = 2;
	// writeDump(a);

	x = {};
	k = {"1":5.0};
	sk = serializeJSON(k);
	x[sk] = 1;
	writeDump(x);
	writeDump(x[sk]);

	writeOutput("<br />");
	writeOutput("memoize:");
	fibonacci = function(n) {
		if (n < 2) {
			return n;
		}
		else {
			return fibonacci(n - 1) + fibonacci(n - 2);
		}
	};
	num = 22;
	writeDump(fibonacci(num));	
	flush();
	fib = _.memoize(function(n) {
		// writeDump(n);
		if (n < 2) {
			return n;
		}
		else {
			return fib(n - 1) + fib(n - 2);
		}
	});
	writeDump(fib(num));	
	flush();
	writeOutput("<br />");

	delay = _.delay(function (msg) {return msg;}, 1000, {msg = "hi"});
	writeDump(delay);
	writeoutput("<br />");

	writeOutput("once: ");
	once = _.once(function () { writeDump("should only see this once"); return 1; });
	once2 = once();
	writeDump(once2);
	once3 = once();
	writeDump(once3);
	writeoutput("<br />");

	writeOutput("wrap: ");
	hello = function(name) { 
		return "hello: " & name; 
	};
	hello2 = _.wrap(hello, function(func) {
		return "before, " & func("moe") & ", after";
	});
	wrap = hello2();	
	writeDump(wrap);
	writeoutput("<br />");

	writeOutput("after: ");
	notes = ["one","two"];
	render = function () {
		writeDump("render should only happen once");
	};
	renderNotes = _.after(arrayLen(notes), render);
	_.each(notes, function(note) {
		renderNotes();
	});	
	writeoutput("<br />");
	
	writeOutput("keys: ");
	keys = _.keys({one : 1, two : 2, three : 3});
	writeDump(keys);
	writeoutput("<br />");
	
	writeOutput("extend: ");
	extend = _.extend({name : 'moe'}, {age : 50});
	writeDump(extend);
	writeoutput("<br />");
	
	writeOutput("pick: ");
	pick = _.pick({name : 'moe', age: 50, userid : 'moe1'}, 'name', 'age');
	writeDump(pick);
	writeoutput("<br />");

	writeOutput("defaults: ");
	iceCream = {flavor : "chocolate"};
	defaults = _.defaults(iceCream, {flavor : "vanilla", sprinkles : "lots"});	
	writeDump(defaults);
	writeoutput("<br />");

	writeOutput("clone: ");
	clone = _.clone({name : 'moe'});
	writeDump(clone);
	writeoutput("<br />");

/*
	writeOutput("tap: ");
	tap = _.chain([1,2,3,200]).filter(function(num) {
		return num % 2 == 0;
	}).tap(function () {
		writeDump(arguments);
	}).map(function(num) { 
		return num * num; 
	}).value();
	writeDump(tap);
	writeoutput("<br />");
*/

/*
	writeOutput("chain: ");
	stooges = [{name : 'curly', age : 25}, {name : 'moe', age : 21}, {name : 'larry', age : 23}];
	chain = _.chain(stooges);
	writeDump(chain);
	youngest = chain.map(iterator = function(stooge){
		return stooge.name & ' is ' & stooge.age; 
	});//.first().value();
	writeDump(youngest);	
*/

	// writeOutput("isEqual: ");
	// moe   = {name : 'moe', luckyNumbers : [13, 27, 34]};
	// clone = {name : 'moe', luckyNumbers : [13, 27, 34]};
	// writeDump(moe == clone);

	writeOutput("isString: ");
	isstring = _.isString("asdf");
	writeDump(isstring);
	isstring = _.isString(1);
	writeDump(isstring);
	isstring = _.isString({x:1});
	writeDump(isstring);
	isstring = _.isString([1]);
	writeDump(isstring);
	isstring = _.isString("");
	writeDump(isstring);		

	writeOutput("<br />");
	writeOutput("times: ");
	context = new Component();
	context.x = 1;
	_.times(3, function(i){ writeDump(this.x+i); }, context);

	writeOutput("<br />");
	writeOutput("mixin: ");
	_.mixin({
		upper: function(string) {
			return uCase(string);
		}
	});
	fabio = _.upper("fabio");
	writeDump(fabio);

	writeOutput("<br />");
	writeOutput("unshift: ");
	unshift = _.unshift([3,4],"1","2");
	writeDump(unshift);

	writeOutput("<br />");
	writeOutput("result: ");
	object = {cheese: 'crumpets', stuff: function(){ return 'nonsense'; }};
	result = _.result(object, 'cheese');	
	writeDump(result);
	writeOutput("<br />");
	result2 = _.result(object, 'stuff');
	writeDump(result2);

	list = [{one : 1}, {two : 2}];
	writeDump(_.without(list, list[1]));

	list = [];
    // list[2] = javaCast("null", 0);
    // list[3] = javaCast("null", 0);
    list[8] = 2;
    list[10] = 2;
    list[11] = 5;
    list[14] = 5;
    list[16] = 8;
    list[19] = 8;
    list[33] = "hi";

    writeDump(list);
</cfscript>
<br />
end tests