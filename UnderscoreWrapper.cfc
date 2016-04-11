component displayname="UnderscoreWrapper" {

	property name="obj";
	property name="_";

	public UnderscoreWrapper function init(any obj = {}, _ = new Underscore()) {
		variables.obj = arguments.obj;
		variables._ = arguments._;

		return this;
	}

	public any function value() {
		return variables.obj;
	}

	public UnderscoreWrapper function onMissingMethod(required string missingMethodName, required any missingMethodArguments) {
		var methodToCall = variables._[arguments.missingMethodName];
		
		variables.obj = methodToCall(
			argumentCollection = constructArgumentCollection(arguments.missingMethodArguments)
		);

		return this;
	}

	private struct function constructArgumentCollection(required struct args) {
		var argumentCollection = { "1" = variables.obj };
		for (var i = 1; i <= structCount(arguments.args); i++) {
			argumentCollection[i + 1] = arguments.args[i];
		}
		return argumentCollection;
	}
}