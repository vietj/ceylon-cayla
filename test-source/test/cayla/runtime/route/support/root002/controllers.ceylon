import io.cayla.web { Handler, route, Response, ok }

shared object mycontroller {
	route("/")
	shared class Index(shared String foo) extends Handler() {
		shared actual Response handle() {
			return ok{">``foo``<";};
		}
	}
}