import cayla.router { ... }
import cayla.interop { InnerClassReflector { findControllers } }
import java.lang { ObjectArray }
import ceylon.collection { HashMap }
import vietj.promises { Promise }
import vietj.vertx { Vertx }
import vietj.vertx.http { HttpServer }
import ceylon.net.uri { Path, Query }

shared class ApplicationDescriptor(Application application) {
	
	//
	Router root = Router();
	
	//
	ObjectArray<InnerClassReflector<Application, Controller>> v = findControllers<Application, Controller>(application);
	variable {ControllerDescriptor*} tmp = {};
	value routers = HashMap<Router,ControllerDescriptor>();
	for (i in 0..v.size-1) {
		InnerClassReflector<Application, Controller> ref = v.get(i);
		ControllerDescriptor controller = ControllerDescriptor(ref);
		tmp = {controller, *tmp};
		if (exists route = controller.route) {
			Router router = root.addRoute(route);
			routers.put(router, controller);
		}
	}
	
	shared {ControllerDescriptor*} controllers = tmp;
	
	shared RouteMatch<ControllerDescriptor>? resolve(String path) {
		if (exists match = root.resolve(path), exists controller = routers.get(match.target)) {
			return match.as(controller);
		}
		return null;
	}
	
	shared [Path,Query]? path(Controller controller) {
		if (exists found = routers.find((Router->ControllerDescriptor<Application,Controller> elem) => elem.item.isInstance(controller))) {
			Map<String, String> parameters = found.item.getParameters(controller);
			return found.key.path(parameters);
		}
		return null;
	}
	
	shared ControllerDescriptor? descriptor(Controller controller) {
		return controllers.find((ControllerDescriptor elem) => elem.isInstance(controller));
	}
	
	shared Promise<Runtime> start() {
		Vertx vertx = Vertx();
		HttpServer server = vertx.createHttpServer();
		Runtime runtime = Runtime(this, vertx, server);
		server.requestHandler(runtime.handle);
		Promise<Null> promise = server.listen(8080);
		return promise.then_((Null n) => runtime);
	}
}

