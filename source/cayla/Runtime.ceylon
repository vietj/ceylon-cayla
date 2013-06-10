import vietj.vertx { ... }
import vietj.vertx.http { HttpServer, HttpServerRequest, HttpServerResponse }

shared class Runtime(ApplicationDescriptor _descriptor, Vertx vertx, HttpServer server) {
	
	shared ApplicationDescriptor descriptor = _descriptor;
	
	shared void handle(HttpServerRequest req) {
		
		Response response;
		if (exists match = _descriptor.resolve(req.path)) {
			
			// Merge parameters
			{<String->String>*} parameters = req.parameters.mapItems(
				(String key, {String+} item) => item.first
				).chain(match.params);
			
			// Attempt to create controller
			Controller? controller = match.target.create(parameters);
			
			//
			if (exists controller) {
				current.set(RequestContext(this, req));
				try {
					response = controller.handle();
				}
				finally {
					current.set(null);
				}
			} else {
				response = error().body("Could not create controller for ``req.path`` with ``parameters``");
			}
		} else {
			response = notFound().body("Could not match a controller for ``req.path``");
		}
		
		// Send through vert.x
		response.send(req.response);
	}
	
	shared void stop() {
		vertx.stop();
	}
}