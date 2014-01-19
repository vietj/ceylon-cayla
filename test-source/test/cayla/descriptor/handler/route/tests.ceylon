import io.cayla.web.descriptor { scanHandlersInObject }
import ceylon.test { test, assertEquals }
import test.cayla.descriptor.handler.route.support.app001 { Controller001=MyController }
import io.cayla.web { Route }

shared test void test001() {
	value controllers = scanHandlersInObject(Controller001());
	assertEquals(1, controllers.size);
	value controllerDesc = controllers.first;
	assert(exists controllerDesc);
	{Route+}? route = controllerDesc.route;
	assert(exists route);
	assertEquals("/the_route", route.first.path);
}

