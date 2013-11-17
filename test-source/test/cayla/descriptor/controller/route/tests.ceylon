import cayla.descriptor { scanControllersInObject }
import ceylon.test { test, assertEquals }
import test.cayla.descriptor.controller.route.support.app001 { Controllers001=Controllers }
import cayla { Route }

shared test void test001() {
	value controllers = scanControllersInObject(Controllers001());
	assertEquals(1, controllers.size);
	value controllerDesc = controllers.first;
	assert(exists controllerDesc);
	Route? route = controllerDesc.route;
	assert(exists route);
	assertEquals("/the_route", route.path);
}

