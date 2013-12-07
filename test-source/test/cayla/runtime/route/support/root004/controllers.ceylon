import cayla { Handler, route, Response, ok }

shared object mycontroller {
	route("/")
	shared class Index(shared String foo = "the_default") extends Handler() {
		shared actual Response handle() {
			return ok{">``foo``<";};
		}
	}
}