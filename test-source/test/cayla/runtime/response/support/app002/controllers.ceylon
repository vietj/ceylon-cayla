import cayla { Handler, route, Response }
import ceylon.promises { Deferred, Promise }

shared object mycontroller {
	route("/")
	shared class Index() extends Handler() {
		shared actual Promise<Response> handle() {
			Deferred<Response> response = Deferred<Response>();
			response.reject(Exception());
			return response.promise;
		}
	}
}