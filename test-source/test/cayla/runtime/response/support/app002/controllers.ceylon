import io.cayla.web { Handler, route, Response, RequestContext }
import ceylon.promise { Promise }

shared object mycontroller {
	route("/")
	shared class Index() extends Handler() {
		shared actual Promise<Response> invoke(RequestContext context) {
			value response = context.deferred<Response>();
			response.reject(Exception());
			return response.promise;
		}
	}
}