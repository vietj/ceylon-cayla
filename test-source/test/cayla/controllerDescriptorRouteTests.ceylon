import cayla { ... }
import ceylon.test { ... }
import cayla.router { RouteMatch }

void controllerDescriptorRouteTests() {
	testControllerDescriptorRoute();
}

void testControllerDescriptorRoute() {
	
	class MyApp() extends Application() {
		route "/:foo/bar"
		shared class MyController2(shared String foo, shared String bar = "default_bar") extends Controller() {
		}
	}
	
	value app = MyApp();
	ApplicationDescriptor desc = app.build();
	
	RouteMatch<ControllerDescriptor>? resolved = desc.resolve("/foo_value/bar");
	if (exists resolved) {
		assertEquals(LazyMap({"foo"->"foo_value"}), resolved.params);
		
	} else {
		fail();
	}
}