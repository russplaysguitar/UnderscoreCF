<cfscript>
	myObj = {a:1,b:2};
	_myObj = new Underscore(myObj);
	_ = new Underscore();

	_.each(myObj);
</cfscript>