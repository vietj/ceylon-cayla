import cayla { Controller, route, Response, ok }

shared object path {
    shared variable String val = "";
}

route("/")
shared class Index() extends Controller() {
	shared actual Response handle() {
		return ok{"``Foo(path.val)``";};
	}
}

route("/prefix/+bar")
shared class Foo(shared String bar) extends Controller() {
}
