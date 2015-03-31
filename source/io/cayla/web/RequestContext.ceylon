import java.lang { ThreadLocal }
import ceylon.net.uri { Uri, Authority }
import io.vertx.ceylon.core.http { HttpServerRequest }

object current {
	
	shared ThreadLocal<RequestContext> threadLocal = ThreadLocal<RequestContext>();
	
	shared RequestContext? get => threadLocal.get();

	shared void set(RequestContext? context) {
		threadLocal.set(context);
	}
	
}

"""The request context provides the information available during a request such as:
   - the Vert.x request
   - generating an URL for a controller
   """
shared class RequestContext(shared Runtime runtime, "The Vert.x request" shared HttpServerRequest request) {
	
	"Render an URL for the specified controller"
	shared String url("The controller to create an URL for" Handler controller) {
		if (exists path = runtime.application.descriptor.path(controller)) {
			value uri = Uri {
				scheme = "http";
				authority = Authority {
					host = runtime.application.config.hostName else "localhost";
					port = runtime.application.config.port;
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