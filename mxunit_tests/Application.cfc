component {
	this.mappings["/underscore"] = getParentDirectory(getCurrentTemplatePath());
    this.mappings["/mxunit"] = expandPath("/testbox/system/compat");

	private string function getParentDirectory(required path) {
		return GetDirectoryFromPath(
			GetDirectoryFromPath(
				arguments.path
			).ReplaceFirst( "[\\\/]{1}$", "")
		);
	}
}