component {
	this.mappings["/underscore"] = getParentDirectory(getCurrentTemplatePath());

	private string function getParentDirectory(required path) {
		return GetDirectoryFromPath(
			GetDirectoryFromPath(
				arguments.path
			).ReplaceFirst( "[\\\/]{1}$", "")
		);
	}
}