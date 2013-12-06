import cayla { Controller, route, Response, ok }

shared object mycontroller {
	route("/")
	shared class Index() extends Controller() {
		shared actual Response handle() {
			return ok{"hello";};
		}
	}
}