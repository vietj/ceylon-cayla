import java.lang { ThreadLocal }
import ceylon.net.uri { Path, Query, Uri, Authority }
import vietj.vertx.http { HttpServerRequest }

object current {
	
	shared ThreadLocal<RequestContext> threadLocal = ThreadLocal<RequestContext>();
	
	shared RequestContext? get => threadLocal.get();

	shared void set(RequestContext? context) {
		threadLocal.set(context);
	}
	
}

shared class RequestContext(Runtime runtime, HttpServerRequest req) {
	
	shared String url(Controller controller) {
		if (exists path = runtime.application.descriptor.path(controller)) {
			value uri = Uri {
				scheme = "http";
				authority = Authority {
					host = "localhost";
					port = 8080;
				};  
				path = path[0]; 
				query = path[1]; };
			return uri.string;
		} else {
			// Could not resolve : handle this better
			return "";
		}
	}
}