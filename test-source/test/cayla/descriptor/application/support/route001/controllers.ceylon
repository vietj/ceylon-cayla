import cayla { Handler, route }

shared object controllers {
	route("/:foo/bar")
	shared class Index(shared String foo, shared String bar = "default_bar") extends Handler() {
	}
	
	shared Index? isInstance(Handler controller) {
		if (is Index controller) {
			return controller;
		} else {
			return null;
		}
	}
}