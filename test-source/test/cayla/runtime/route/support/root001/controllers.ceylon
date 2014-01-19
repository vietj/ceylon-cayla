import io.cayla.web { Handler, route, Response, ok }

shared object mycontroller {
	route("/")
	shared class Index() extends Handler() {
		shared actual Response handle() {
			return ok{"hello";};
		}
	}
}