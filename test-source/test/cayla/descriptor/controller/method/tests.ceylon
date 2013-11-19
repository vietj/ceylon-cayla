import cayla.descriptor { scanControllersInObject }
import ceylon.test { test, assertEquals }
import test.cayla.descriptor.controller.method.support.app001 { Controllers001=Controllers }
import test.cayla.descriptor.controller.method.support.app002 { Controllers002=Controllers }
import test.cayla.descriptor.controller.method.support.app003 { Controllers003=Controllers }
import ceylon.net.http { get, put, post }
import ceylon.collection { HashSet }

shared test void test001() {
	value controllers = scanControllersInObject(Controllers001());
	assertEquals(1, controllers.size);
	value controllerDesc = controllers.first;
	assert(exists controllerDesc);
	assertEquals({}, controllerDesc.methods);
}

shared test void test002() {
	value controllers = scanControllersInObject(Controllers002());
	assertEquals(1, controllers.size);
	value controllerDesc = controllers.first;
	assert(exists controllerDesc);
	assertEquals({get}, controllerDesc.methods);
}

shared test void test003() {
	value controllers = scanControllersInObject(Controllers003());
	assertEquals(1, controllers.size);
	value controllerDesc = controllers.first;
	assert(exists controllerDesc);
	assertEquals(HashSet({put,post}), HashSet(controllerDesc.methods));
}
