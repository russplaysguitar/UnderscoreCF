<!--- note: To run, you must update the "directory" and "componentPath" attributes --->

<cfinvoke component="mxunit.runner.DirectoryTestSuite"
		  componentPath="underscore.mxunit_tests" 
          method="run"
          directory="#expandPath('.')#"
		  recurse="false"
		  returnvariable="results" />

<cfoutput>#results.getResultsOutput('extjs')#</cfoutput>