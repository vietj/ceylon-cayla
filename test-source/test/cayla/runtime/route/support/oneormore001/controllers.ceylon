import cayla { Controller, route, Response, ok }

shared object mycontroller {
	route("/+foo")
	shared class Index(shared String foo) extends Controller() {
		shared actual Response handle() {
			return ok().body(">``foo``<");
		}
	}
}