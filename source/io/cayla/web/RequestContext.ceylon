import java.lang { ThreadLocal }
import ceylon.net.uri { Uri, Authority }
import io.vertx.ceylon.core.http { HttpServerRequest }
import ceylon.language.meta.model {
    Type
}
import ceylon.collection {
    HashMap
}
import ceylon.language.meta {
    type
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
	shared String url("The controller to create an URL for" Handler controller,
	"Set to true for absolute URLs" Boolean absolute = false) {
		if (exists path = runtime.application.descriptor.path(controller)) {
			Uri uri;
			if(absolute){
				value config = runtime.application.config;
				uri = Uri {
					scheme = "http";
					authority = Authority {
						host = config.externalHostName else config.hostName else "localhost";
						port = config.externalPort else config.port;
					};  
					path = path[0]; 
					query = path[1];
				};
			}else{
				uri = Uri {
					path = path[0]; 
					query = path[1];
				};
			}
			value stringUri = uri.string;
			// make sure that for relative URI to the root ("") we turn it into a "/"
			// Note that it won't happen for absolute URIs where http://foo.com is good
			return stringUri.empty then "/" else stringUri;
		} else {
			// Could not resolve : handle this better
			// DO NOT use controller.string as in most cases it would call this very method and run out of stack
			print("Could not find path for controller ``type(controller)``");
			return "";
		}
	}
}