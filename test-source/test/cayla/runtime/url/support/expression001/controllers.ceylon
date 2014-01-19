import io.cayla.web { Handler, route, Response, ok }

route("/")
shared class Index() extends Handler() {
	shared actual Response handle() {
		return ok{"``Foo("juu")``";};
	}
}

route("/:bar")
shared class Foo(shared String bar) extends Handler() {
}
