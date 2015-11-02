component {

	this.title 				= "UnderscoreCF";
	this.author 			= "Russ Spivey";
	this.webURL 			= "https://github.com/russplaysguitar/underscorecf";
	this.description 		= "An UnderscoreJS port for Coldfusion. Functional programming library.";
	this.version			= "2.4.0";
    this.autoMapModels      = false;
	this.dependencies 		= [];

	function configure(){
        binder.map("_").to("#moduleMapping#.Underscore");
        binder.map("Underscore").to("#moduleMapping#.Underscore");
	}

}
