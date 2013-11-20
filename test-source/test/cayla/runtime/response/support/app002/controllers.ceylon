import cayla { Controller, route, Response }
import vietj.promises { Deferred, Promise }

shared object mycontroller {
	route("/")
	shared class Index() extends Controller() {
		shared actual Promise<Response> handle() {
			Deferred<Response> response = Deferred<Response>();
			response.reject(Exception());
			return response.promise;
		}
	}
}