import cayla { Handler, route, Response, ok }

shared object mycontroller {
	route("/foo")
	shared class Index() extends Handler() {
		shared actual Response handle() {
			return ok{"foo";};
		}
	}
}