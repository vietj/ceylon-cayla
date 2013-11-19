import cayla { Controller, route, Response, ok, get }

shared object mycontroller {
	get route("/")
	shared class Index() extends Controller() {
		shared actual Response handle() {
			return ok().body("hello");
		}
	}
}