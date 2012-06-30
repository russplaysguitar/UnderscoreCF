component {
	public function init (struct input = {}) {
		for (arg in arguments.input) {
			this[arg] = input[arg];
		}
	}
}