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

	public UnderscoreWrapper function onMissingMethod(required string methodName, required any methodArgs) {
		var method = variables._[arguments.methodName];
		arrayPrepend(arguments.methodArgs, variables.obj);
		variables.obj = method(argumentCollection = arguments.methodArgs);

		return this;
	}
}