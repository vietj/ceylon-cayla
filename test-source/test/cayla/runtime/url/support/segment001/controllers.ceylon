import cayla { Handler, route, Response, ok }

route("/")
shared class Index() extends Handler() {
	shared actual Response handle() {
		return ok{"``Foo()``";};
	}
}

route("/foo")
shared class Foo() extends Handler() {
}
