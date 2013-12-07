import cayla.descriptor { scanHandlersInObject }
import ceylon.test { test, assertEquals }
import test.cayla.descriptor.handler.method.support.app001 { Controller001=MyController }
import test.cayla.descriptor.handler.method.support.app002 { Controller002=MyController }
import test.cayla.descriptor.handler.method.support.app003 { Controller003=MyController }
import ceylon.net.http { get, put, post }
import ceylon.collection { HashSet }

shared test void test001() {
	value controllers = scanHandlersInObject(Controller001());
	assertEquals(1, controllers.size);
	value controllerDesc = controllers.first;
	assert(exists controllerDesc);
	assertEquals({}, controllerDesc.methods);
}

shared test void test002() {
	value controllers = scanHandlersInObject(Controller002());
	assertEquals(1, controllers.size);
	value controllerDesc = controllers.first;
	assert(exists controllerDesc);
	assertEquals({get}, controllerDesc.methods);
}

shared test void test003() {
	value controllers = scanHandlersInObject(Controller003());
	assertEquals(1, controllers.size);
	value controllerDesc = controllers.first;
	assert(exists controllerDesc);
	assertEquals(HashSet({put,post}), HashSet(controllerDesc.methods));
}
