import cayla.descriptor { scanHandlersInObject }
import ceylon.test { test, assertEquals }
import test.cayla.descriptor.handler.route.support.app001 { Controller001=MyController }
import cayla { Route }

shared test void test001() {
	value handlers = scanHandlersInObject(Controller001());
	assertEquals(1, handlers.size);
	value handlerDesc = handlers.first;
	assert(exists handlerDesc);
	Route? route = handlerDesc.route;
	assert(exists route);
	assertEquals("/the_route", route.path);
}

