import cayla { Handler, route, Response, ok }

shared object mycontroller {
	route("/")
	shared class Index(shared String? foo) extends Handler() {
		shared actual Response handle() {
			String s;
			if (exists foo) {
				s = ">``foo``<";
			} else {
				s = "null";
			}
			return ok{s;};
		}
	}
}