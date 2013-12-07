import cayla { Handler, route, Response, ok }

shared object mycontroller {
	route("/:foo")
	shared class Index(shared String foo) extends Handler() {
		shared actual Response handle() {
			return ok{">``foo``<";};
		}
	}
}