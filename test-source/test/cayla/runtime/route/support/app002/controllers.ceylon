import cayla { Controller, route, Response, ok }

shared object mycontroller {
	route("/foo")
	shared class Index() extends Controller() {
		shared actual Response handle() {
			return ok().body("foo");
		}
	}
}