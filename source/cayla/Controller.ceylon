shared abstract class Controller() {
	
	"Invoke the controller with the specified context"
	shared default Response invoke(RequestContext context) {
		return handle();
	}
	
	"Handle the request and return a response"
	shared default Response handle() {
		return ok();
	}

	shared actual String string {
		if (exists context = current.get) {
			return context.url(this);
		} else {
			// Cannot generate anything
			return "";
		}
	}
}