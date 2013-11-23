import cayla { Controller, route, Response, ok }

shared object mycontroller {
	route("/")
	shared class Index(shared String foo = "the_default") extends Controller() {
		shared actual Response handle() {
			return ok().body(">``foo``<");
		}
	}
}