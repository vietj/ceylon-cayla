import ceylon.language.meta.declaration { Package }
import cayla.router { Router, RouteMatch }
import ceylon.collection { HashMap }
import ceylon.net.uri { Path, Query }
import cayla { Handler }

shared class ApplicationDescriptor(Package pkg) {
	
	//
	shared HandlerDescriptor[] handlers = scanHandlersInPackage(pkg);

	// Router
	Router root = Router();
	value routers = HashMap({
		for (handler in handlers)
			if (exists route = handler.route)
				root.addRoute(route.path)->handler
	});
	
	shared RouteMatch<HandlerDescriptor>? resolve(Path|String path) {
		if (exists match = root.resolve(path), exists controller = routers.get(match.target)) {
			return match.as(controller);
		}
		return null;
	}
	
	shared [Path,Query]? path(Handler controller) {
		if (exists found = routers.find((Router->HandlerDescriptor elem) => elem.item.isInstance(controller))) {
			Map<String, String> parameters = found.item.parameters(controller);
			return found.key.path(parameters);
		}
		return null;
	}

	shared HandlerDescriptor? descriptorOf(Handler handler) {
		for (handlerDescriptor in handlers) {
			if (handlerDescriptor.isInstance(handler)) {
				return handlerDescriptor;
			}
		}
		return null;
	}
}