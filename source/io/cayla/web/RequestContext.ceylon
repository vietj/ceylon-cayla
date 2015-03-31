import java.lang { ThreadLocal }
import ceylon.net.uri { Uri, Authority }
import io.vertx.ceylon.core.http { HttpServerRequest }
import ceylon.promise { Deferred }

object current {
	
	shared ThreadLocal<RequestContext> threadLocal = ThreadLocal<RequestContext>();
	
	shared RequestContext? get => threadLocal.get();

	shared void set(RequestContext? context) {
		threadLocal.set(context);
	}
	
}

"""The request context provides the information available during a request such as:
   - the Vert.x request
   - the request parameters
   - generating an URL for a controller
   """
shared class RequestContext(
  "The runtime"
  shared Runtime runtime,
  "The request aggregated parameters from the query part, the optional form and the path parameters"
  shared Map<String, [String+]> params,
  "The Vert.x request" shared HttpServerRequest request) {
	
	shared Deferred<Result> deferred<Result>() => runtime.vertx.executionContext.deferred<Result>();
	
	"Render an URL for the specified controller"
	shared String url("The controller to create an URL for" Handler controller) {
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