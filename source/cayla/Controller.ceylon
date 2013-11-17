shared abstract class Controller() {
	
	"Handle the request and return a response"
	shared default Response handle() {
		return ok();
	}
}