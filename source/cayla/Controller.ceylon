shared abstract class Controller() {
	
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