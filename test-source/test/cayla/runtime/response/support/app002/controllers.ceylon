import io.cayla.web { Handler, route, Response }
import ceylon.promise { Deferred, Promise }

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