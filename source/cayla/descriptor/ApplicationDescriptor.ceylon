import ceylon.language.meta.declaration { Package }
import cayla.router { Router, RouteMatch }
import ceylon.collection { HashMap }
import ceylon.net.uri { Path, Query }
import cayla { Controller }

shared class ApplicationDescriptor(Package pkg) {
	
	//
	shared ControllerDescriptor[] controllers = scanControllersInPackage(pkg);

	// Router
	Router root = Router();
	value routers = HashMap({
		for (controller in controllers)
			if (exists route = controller.route)
				root.addRoute(route.path)->controller
	});
	
	shared RouteMatch<ControllerDescriptor>? resolve(Path|String path) {
		if (exists match = root.resolve(path), exists controller = routers.get(match.target)) {
			return match.as(controller);
		}
		return null;
	}
	
	shared [Path,Query]? path(Controller controller) {
		if (exists found = routers.find((Router->ControllerDescriptor elem) => elem.item.isInstance(controller))) {
			Map<String, String> parameters = found.item.parameters(controller);
			return found.key.path(parameters);
		}
		return null;
	}

	shared ControllerDescriptor? descriptorOf(Controller controller) {
		for (controllerDescriptor in controllers) {
			if (controllerDescriptor.isInstance(controller)) {
				return controllerDescriptor;
			}
		}
		return null;
	}
}