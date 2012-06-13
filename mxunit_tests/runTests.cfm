<!--- note: To run, you must update the "directory" and "componentPath" attributes --->

<cfinvoke component="mxunit.runner.DirectoryTestSuite"
          method="run"
          directory="#expandPath('/github/UnderscoreCF/mxunit_tests/')#"
	  componentPath="github.UnderscoreCF.mxunit_tests"
	  recurse="false"
      returnvariable="results" />

<cfoutput>#results.getResultsOutput('extjs')#</cfoutput>