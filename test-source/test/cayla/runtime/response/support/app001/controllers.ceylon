import cayla { Controller, route, Response, ok }
import vietj.promises { Deferred, Promise }

shared object mycontroller {
	route("/")
	shared class Index() extends Controller() {
		shared actual Promise<Response> handle() {
			Deferred<Response> response = Deferred<Response>();
			response.resolve(ok().body("hello_promise"));
			return response.promise;
		}
	}
}