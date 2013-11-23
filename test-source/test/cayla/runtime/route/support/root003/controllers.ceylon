import cayla { Controller, route, Response, ok }

shared object mycontroller {
	route("/")
	shared class Index(shared String? foo) extends Controller() {
		shared actual Response handle() {
			String s;
			if (exists foo) {
				s = ">``foo``<";
			} else {
				s = "null";
			}
			return ok().body(s);
		}
	}
}