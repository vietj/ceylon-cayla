import ceylon.language.meta.declaration { Package }
import cayla.router { Router, RouteMatch }
import ceylon.collection { HashMap }
import ceylon.net.uri { Path, Query }
import cayla { Controller }

"""Describes the application.
   """
shared class ApplicationDescriptor(Package|Object container) {
	
	//
	shared ControllerDescriptor[] controllers;
	switch (container)
	case (is Package) {
		controllers = scanControllersInPackage(container);
	}
	else {
		controllers = scanControllersInObject(container);
	}

	// Router
	Router root = Router();
	value routers = HashMap({
		for (controller in controllers)
			if (exists route = controller.route)
				root.addRoute(route.path)->controller
	});
	
	"Resolves a controller descriptor for a path"
	shared RouteMatch<ControllerDescriptor>? resolve("The path" Path|String path) {
		if (exists match = root.resolve(path), exists controller = routers.get(match.target)) {
			return match.as(controller);
		}
		return null;
	}
	
	"Renders the path of the specified controller, returns null when the controller does not belong to this application."
	shared [Path,Query]? path("The controller to render a path for" Controller controller) {
		if (exists found = routers.find((Router->ControllerDescriptor elem) => elem.item.isInstance(controller))) {
			Map<String, String> parameters = found.item.parameters(controller);
			return found.key.path(parameters);
		}
		return null;
	}

	"Resolves a descriptor for the specified controller, returns null when the controller does not belong to this application."
	shared ControllerDescriptor? describe(Controller controller) {
		for (controllerDescriptor in controllers) {
			if (controllerDescriptor.isInstance(controller)) {
				return controllerDescriptor;
			}
		}
		return null;
	}
}