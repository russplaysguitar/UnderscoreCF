<cfscript>
	myStruct= {a:1,b:2};
	myArr = [10,20];
	myObj = new myClass();
	myObj.a = 1;
	myObj.b = 2;

	_ = new Underscore();
	_myStruct = new Underscore(myStruct);
	_myArr = new Underscore(myArr);
	_myObj = new Underscore(myObj);

	_.forEach(myStruct, function(val, key) {
		writeDump(key & ": " & val);
	});
	writeDump("<br />");
	_.forEach(myArr, function(val, key) {
		writeDump(key & ": " & val);
	});
	writeDump("<br />");
	_.forEach(myObj, function(val, key) {
		writeDump(key & ": " & val);
	});	
	writeDump("<br />");
	a = _myObj.collect(iterator = function(val, key) {
		return(key & ": " & val);
	});	
	writeDump(a);
</cfscript>