import ceylon.language.meta.declaration { Package }
import io.cayla.web.router { Router, RouteMatch }
import ceylon.collection { HashMap }
import ceylon.net.uri { Path, Query, Parameter }
import io.cayla.web { Handler, Route }

"""Describes the application.
   """
shared class ApplicationDescriptor(Package|Object container) {
	
	//
	shared HandlerDescriptor[] handlers;
	switch (container)
	case (is Package) {
		handlers = scanHandlersInPackage(container);
	}
	else {
		handlers = scanHandlersInObject(container);
	}

    // The top router
	Router root = Router();
	
	// Utils function for creating a router (equivalent to a left fold)
	Router createRouter({Route*} route) {
		if (exists first = route.first) {
			return createRouter(route.rest).mount(first.path);
		} else {
			return root;
		}
	}

	// Router
	value routers = HashMap {
		for (handler in handlers)
			if (exists route = handler.route)
				createRouter(route)->handler
	};
	
	"Resolves an handler descriptor for a path"
	shared {RouteMatch<HandlerDescriptor>*} resolve("The path" String path) {
		return {
			for (match in root.matches(path))
				if (exists handler = routers.get(match.target))
					match.as(handler)
		};
	}
	
	"Renders the path of the specified handler, returns null when the handler does not belong to this application
	 or the path could not be rendered."
	shared [Path,Query]? path("The handler to render a path for" Handler handler) {
		if (exists found = routers.find((Router->HandlerDescriptor elem) => elem.item.isInstance(handler))) {
			Map<String, String> parameters = found.item.parameters(handler);
			if (exists render = found.key.path(parameters)) {
				value path = Path(true);
				for (segment in render[0]) {
					path.add(segment);
				}
				Query query = Query();
				for (parameter in render[1]) {
					query.add(Parameter(parameter.key, parameter.item));
				}
				return [path, query];
			}
		}
		return null;
	}

	"Resolves a descriptor for the specified handler, returns null when the handler does not belong to this application."
	shared HandlerDescriptor? describe(Handler handler) {
		for (controllerDescriptor in handlers) {
			if (controllerDescriptor.isInstance(handler)) {
				return controllerDescriptor;
			}
		}
		return null;
	}
}