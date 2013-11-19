import cayla { Controller, route, Response, ok, post }

shared object mycontroller {
	post route("/")
	shared class Index() extends Controller() {
		shared actual Response handle() {
			return ok().body("hello");
		}
	}
}