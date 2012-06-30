<cfsilent>
<cfscript>
	_ = new underscore.Underscore();

	metadata = getComponentMetaData("underscore.Underscore");

	collectionFunctions = "each,map,reduce,find,filter,reject,all,any,include,invoke,pluck,max,min,sortBy,groupBy,sortedIndex,shuffle,toArray,size";

	arrayFunctions = "first,initial,last,rest,compact,flatten,without,union,intersection,difference,uniq,zip,indexOf,lastIndexOf,range,arrayConcat";

	funcFunctions = "bind,bindAll,memoize,delay,once,after,wrap";

	objectFunctions = "keys,values,functions,extend,pick,defaults,clone,has,isEmpty,isArray,isObject,isFunction,isString,isNumber,isBoolean,isDate,isNaN";

	utilFunctions = "times,mixin,result";

	// chainFunctions = "chain,value";

	all = [
		{title: "Collections", list: collectionFunctions},
		{title: "Arrays", list: arrayFunctions},
		{title: "Functions", list: funcFunctions},
		{title: "Objects", list: objectFunctions},
		{title: "Utilities", list: utilFunctions}
	];

	display = function (metadata, functionList) {
		var functions = listToArray(functionList);
		var funcMetas = _.map(functions, function(v){
			var result = _.filter(metadata.functions, function(mf){
				return mf.name == v;
			});
			if (arrayLen(result) > 0)
				return result[1];
			else
				return {};
		});
		_.each(funcMetas, function(val, key) {
			if(structKeyExists(val, "hint")) {
				writeOutput("<p id='" & val.name &"'>");
				writeOutput("<b class='header'>" & val.name & "</b> ");
				if(structKeyExists(val, "header")) {
					writeOutput("<code>" & val.header & "</code>");
				}
				writeOutput("<br />" & val.hint & "<br />");
				if(structKeyExists(val, "example")) {
					writeOutput("<pre>" & val.example & "</pre>");
				}
				writeOutput("</p>");
			}
		});
	};
</cfscript>
</cfsilent>
<!DOCTYPE html>
<html>
<head>
	<title>Underscore.cfc</title>
	<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="chrome=1" />
	<meta name="viewport" content="width=device-width" />
	<link rel="stylesheet" type="text/css" href="style.css" />
</head>
<body>
	<div id="sidebar" class="interface">
		<a class="toc_title" href="#">
		    Underscore.cfc <!-- <span class="version">(.01)</span> -->
	    </a>
	    <a class="toc_title" href="#">
	    	Introduction
	    </a>
    	<cfloop array="#all#" index="index">
    		<cfoutput>
		    <a class="toc_title" href="###index.title#">
			    #index.title#
		    </a>
			</cfoutput>
		    <ul class="toc_section">
		    	<cfscript>
			    	 _.each(listToArray(index.list), function (val) {
				    	writeOutput("<li>- <a href='##" & val & "'>" & val & "</a></li>");
				    });
				</cfscript>			    	
		    </ul>
    	</cfloop>
	</div>
	<div class="container">
		<h1>Underscore.cfc</h1>
		<p id="Introduction">
			<cfoutput>#metadata.introduction#</cfoutput>
		</p>
		<h2>Download</h2>
		<div><a href="https://github.com/russplaysguitar/UnderscoreCF/downloads">Latest Version (Trunk)</a> - <i>Links to GitHub Download page</i></div>
		<h2 id="Collections">Collection Functions (Arrays, Structs, Queries, or Objects)</h2>
		<cfset display(metadata, collectionFunctions) >
		<h2 id="Arrays">Array Functions</h2>
		<cfset display(metadata, arrayFunctions) >
		<h2 id="Functions">Function (uh, ahem) Functions</h2>
		<cfset display(metadata, funcFunctions) >
		<h2 id="Objects">Object/Struct Functions</h2>
		<cfset display(metadata, objectFunctions) >
		<h2 id="Utilities">Utility Functions</h2>
		<cfset display(metadata, utilFunctions) >
	</div>
	<a href="http://github.com/russplaysguitar/underscorecf"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png" alt="Fork me on GitHub"></a>
</body>
</html>