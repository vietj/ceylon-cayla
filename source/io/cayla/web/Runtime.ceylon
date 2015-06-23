import io.vertx.ceylon.core { Vertx }
import io.vertx.ceylon.core.http { HttpServerRequest,
  HttpServer }
import ceylon.promise { Promise }
import ceylon.collection { HashMap }
"""The application runtime.
   
   The runtime is obtained from the [[Application.start]] method.
   """
shared class Runtime(
  "The application" shared Application application,
  "Vert.x" shared Vertx vertx,
  "The http server" HttpServer server) {
	
	"Handles the Vert.x request and dispatch it to a controller"
	shared void handle(HttpServerRequest request) {
		
		// When there is a body, we are invoked by Vert.x before parsing this body
		// so we need to use the Promise<Map<String, {String+}> to get the form
		
		// When there is a form we get it
		Map<String, [String+]> withForm(Map<String, [String+]> form) {
			return form;
		}
		// Otherwise we fail but we just return an empty map
		Map<String, [String+]> withoutForm(Throwable ignore) {
			return emptyMap;
		}
		
		// Dispatch now the request + form in Cayla
		void dispatch(Map<String, [String+]> form) {
			value result = _handle(request, form);
			switch (result)
			case (is Response){
				// we did not find a controller
				result.send(request.response);
			}
			case (is [RequestContext, Handler]){
				RequestContext context = result[0];
				Handler controller = result[1];
				current.set(context);
				variable Response|Promise<Response> response;
				try {
					controller.before(context);
					response = controller.invoke(context);
				}
				catch (Exception e) {
					response = error {
						e.message;
					};
				}
				value defResponse = response;
				switch (defResponse)
				case (is Response) {
					defResponse.send(request.response);
					controller.after();
				}
				case (is Promise<Response>) {
					void f(Response response) {
						response.send(request.response);
						controller.after();
					}
					void g(Throwable reason) {
						error {
							reason.message;
						}.send(request.response);
						controller.after(reason);
					}
					defResponse.compose(f, g);
				}
			}
		}
		
		// Chain stuff
		request.formAttributes.compose(withForm, withoutForm).compose(dispatch);
	}

	"Handles the Vert.x request and dispatch it to a controller"
	[RequestContext,Handler]|Response _handle(HttpServerRequest request, Map<String, [String+]> form) {

		for (match in application.descriptor.resolve(request.path)) {
			
			value desc = match.target;
			
			// Merge parameters : query / form / path
			HashMap<String, [String+]> parameters = HashMap<String, [String+]>();
			for (param in request.params) {
				parameters.put(param.key, param.item);
			}
			for (param in form) {
				value existing = parameters[param.key];
				if (exists existing) {
					parameters.put(param.key, existing.append(param.item));
				} else {
					parameters.put(param.key, param.item);
				}
			}
			for (param in match.params) {
				value existing = parameters[param.key];
				if (exists existing) {
					parameters.put(param.key, existing.withTrailing(param.item));
				} else {
					parameters.put(param.key, [param.item]);
				}
			}
			
			// Todo : make request return ceylon.net.http::Method instead
			value method = request.method;
			if (desc.methods.size == 0 || desc.methods.contains(method)) {

				// Attempt to create controller
				Handler controller;
				try {
					controller = match.target.instantiate(*
						parameters.map((String->[String+] element) => element.key->element.item.first)
					);
				} catch (Exception e) {
					// Somehow should distinguish the kind of error
					// and return an appropriate status code
					// missing parameter    -> 400
					// invocation exception -> 500
					// etc...
					return error {
						"Could not create controller for ``request.path`` with ``parameters``: ``e.message``";
					};
				}
				
				value context = RequestContext(this, parameters, request);
				return [context, controller];
			}
		}		
		return notFound {
			"Could not match a controller for ``request.method`` ``request.path``";
		};
	}
	
	"Stop the application"
	shared Promise<Anything> stop() {
		value done = server.close();
		vertx.stop();
		return done;
	}
}

