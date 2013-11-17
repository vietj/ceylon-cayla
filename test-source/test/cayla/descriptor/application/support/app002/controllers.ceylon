import cayla { Handler, route }

shared object mycontroller {
	route("/:foo/bar")
	shared class Index(shared String foo, shared String bar = "default_bar") extends Handler() {
	}
	
	shared Index? isInstance(Handler handler) {
		if (is Index handler) {
			return handler;
		} else {
			return null;
		}
	}
}