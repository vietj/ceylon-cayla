import io.cayla.web { Handler, route, Response, ok, post }

shared object mycontroller {
	post route("/")
	shared class Index() extends Handler() {
		shared actual Response handle() {
			return ok {
				"hello";
			};
		}
	}
}