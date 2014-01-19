import io.cayla.web { Handler, route, Response, ok }

shared object path {
    shared variable String val = "";
}

route("/")
shared class Index() extends Handler() {
	shared actual Response handle() {
		return ok{"``Foo(path.val)``";};
	}
}

route("/prefix/*bar")
shared class Foo(shared String bar) extends Handler() {
}
