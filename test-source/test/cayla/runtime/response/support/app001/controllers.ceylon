import io.cayla.web { Handler, route, Response, ok, RequestContext }
import ceylon.promise { Promise }

shared object mycontroller {
	route("/")
	shared class Index() extends Handler() {
		
		shared actual Promise<Response> invoke(RequestContext context) {
			value response = context.deferred<Response>();
			response.fulfill(ok { "hello_promise"; });
			return response.promise;
		}
	}
}