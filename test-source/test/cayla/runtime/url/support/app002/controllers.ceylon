import cayla { Controller, route, Response, ok }

route("/")
shared class Index() extends Controller() {
	shared actual Response handle() {
		return ok().body("``Foo()``");
	}
}

route("/foo")
shared class Foo() extends Controller() {
}
