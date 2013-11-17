import cayla.descriptor { controller }
import ceylon.test { test, assertEquals }
import test.cayla.descriptor.handler.route.support.app001 { Controller001=MyController }
import cayla { Route }

shared test void test001() {
	value desc = controller(Controller001());
	assert(exists desc);
	assertEquals(1, desc.handlers.size);
	value handlerDesc = desc.handlers.first;
	assert(exists handlerDesc);
	Route? route = handlerDesc.route;
	assert(exists route);
	assertEquals("/the_route", route.path);
}

