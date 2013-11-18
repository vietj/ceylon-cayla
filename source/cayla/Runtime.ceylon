import vietj.vertx { Vertx }
import vietj.vertx.http { HttpServerRequest }
"""The application runtime.
   
   The runtime is obtained from the [[Application.start]] method.
   """
shared class Runtime("The application" shared Application application, "Vert.x" shared Vertx vertx) {
	
	"Handles the Vert.x request and dispatch it to a controller"
	shared void handle(HttpServerRequest request) {
		Response response;
		if (exists match = application.descriptor.resolve(request.uri.path)) {
			
			// Merge parameters
			{<String->String>*} parameters = request.parameters.mapItems(
				(String key, {String+} item) => item.first
			).chain(match.params);
			
			// Attempt to create controller
			Controller? controller = match.target.instantiate(*parameters);
			
			//
			if (exists controller) {
				value context = RequestContext(this, request);
				current.set(context);
				try {
					response = controller.invoke(context);
				}
				finally {
					current.set(null);
				}
			} else {
				response = error().body("Could not create controller for ``request.path`` with ``parameters``");
			}
		} else {
			response = notFound().body("Could not match a controller for ``request.path``");
		}
		
		// Send through vert.x
		response.send(request.response);
	}
	
	"Stop the application"
	shared void stop() {
		vertx.stop();
	}
}
