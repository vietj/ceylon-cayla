import cayla { Handler, route, Response, ok }
import ceylon.promises { Deferred, Promise }

shared object mycontroller {
	route("/")
	shared class Index() extends Handler() {
		shared actual Promise<Response> handle() {
			Deferred<Response> response = Deferred<Response>();
			response.resolve(ok { "hello_promise"; });
			return response.promise;
		}
	}
}