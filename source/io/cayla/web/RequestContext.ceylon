import java.lang { ThreadLocal }
import ceylon.net.uri { Uri, Authority }
import io.vertx.ceylon.core.http { HttpServerRequest }
import ceylon.language.meta.model {
    Type
}
import ceylon.collection {
    HashMap
}

object current {
	
	ThreadLocal<RequestContext> threadLocal = ThreadLocal<RequestContext>();
	
	shared RequestContext? get => threadLocal.get();

	shared void set(RequestContext? context) {
		threadLocal.set(context);
	}
	
}

"Returns the current request context, if any, or throws"
shared RequestContext requestContext {
    assert(exists ret = current.get);
    return ret;
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

    value userSpecified = HashMap<Type<Anything>, Anything>();
    
    shared void bind<T>(Type<T> type, T item){
        userSpecified.put(type, item);
    }

    shared void unbind(Type<Object> type){
        userSpecified.remove(type);
    }

    shared T get<T>(Type<T> type){
        assert(is T ret = userSpecified[type]);
        return ret;
    }

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