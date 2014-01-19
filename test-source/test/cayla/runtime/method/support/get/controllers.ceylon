import io.cayla.web { Handler, route, Response, ok, get }

shared object mycontroller {
	get route("/")
	shared class Index() extends Handler() {
		shared actual Response handle() {
			return ok {
				"hello";
			};
		}
	}
}