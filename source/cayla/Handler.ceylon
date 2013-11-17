shared abstract class Handler() {
	
	"Handle the request and return a response"
	shared default Response handle() {
		return ok();
	}
}