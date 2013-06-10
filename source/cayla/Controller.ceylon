shared abstract class Controller() /* given R satisfies Response */ {
	
	// doc "a"
	// shared formal R response;
	
	shared actual String string {
		if (exists context = current.get) {
			return context.url(this);
		} else {
			// Cannot generate anything
			return "";
		}
	}
	
	doc "Handle the request and return a response"
	shared default Response handle() {
		return ok();
	}
}