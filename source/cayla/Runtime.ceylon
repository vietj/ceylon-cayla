import vietj.vertx { Vertx }
import vietj.vertx.http { HttpServerRequest }
shared class Runtime(Application application, Vertx vertx) {
	shared void handle(HttpServerRequest req) {
		Response response;
		if (exists match = application.descriptor.resolve(req.uri.path)) {
			
			// Merge parameters
			{<String->String>*} parameters = req.parameters.mapItems(
				(String key, {String+} item) => item.first
			).chain(match.params);
			
			// Attempt to create controller
			Controller? controller = match.target.instantiate(*parameters);
			
			//
			if (exists controller) {
				// current.set(RequestContext(this, req));
				try {
					response = controller.handle();
				}
				finally {
					// current.set(null);
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
