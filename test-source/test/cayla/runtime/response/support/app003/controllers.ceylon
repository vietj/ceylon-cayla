import io.cayla.web { Handler, route, Response }

shared object mycontroller {
	route("/")
	shared class Index() extends Handler() {
		shared actual Response handle() {
			throw Exception();
		}
	}
}