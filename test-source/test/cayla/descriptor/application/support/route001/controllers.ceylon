import cayla { Controller, route }

shared object controllers {
	route("/:foo/bar")
	shared class Index(shared String foo, shared String bar = "default_bar") extends Controller() {
	}
	
	shared Index? isInstance(Controller controller) {
		if (is Index controller) {
			return controller;
		} else {
			return null;
		}
	}
}