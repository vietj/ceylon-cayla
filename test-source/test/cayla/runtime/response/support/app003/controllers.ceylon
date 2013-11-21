import cayla { Controller, route, Response }

shared object mycontroller {
	route("/")
	shared class Index() extends Controller() {
		shared actual Response handle() {
			throw Exception();
		}
	}
}