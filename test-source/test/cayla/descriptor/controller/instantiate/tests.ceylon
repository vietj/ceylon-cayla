import ceylon.test { ... }
import ceylon.language.meta.declaration { ... }
import cayla.descriptor { scanControllersInObject }
import test.cayla.descriptor.controller.instantiate.support.app001 { Controllers001=Controllers }
import test.cayla.descriptor.controller.instantiate.support.app002 { Controllers002=Controllers }
import test.cayla.descriptor.controller.instantiate.support.app003 { Controllers003=Controllers }
import test.cayla.descriptor.controller.instantiate.support.app004 { Controllers004=Controllers }
import test.cayla.descriptor.controller.instantiate.support.app005 { Controllers005=Controllers }
import cayla { Controller }

shared test void testApp001() {
	value controllers = scanControllersInObject(Controllers001());
	assertEquals(1, controllers.size);
	value controllerDesc = controllers.first;
	assert(exists controllerDesc);
	Object controller = controllerDesc.instantiate();
	assert(is Controllers001.Index controller);
	assertTrue(controllerDesc.isInstance(controller));
	object h extends Controller() {}
	assertFalse(controllerDesc.isInstance(h));
}

shared test void testApp002() {
	value desc = scanControllersInObject(Controllers002());
	assertEquals([], desc);
}

shared test void testApp003() {
	value controllers = scanControllersInObject(Controllers003());
	assertEquals(1, controllers.size);
	value controllerDesc = controllers.first;
	assert(exists controllerDesc);
	try {
		controllerDesc.instantiate();
		fail();
	} catch (Exception expected) {
	}
	Object controller = controllerDesc.instantiate("s"->"s_value");
	assert(is Controllers003.Index controller);
	assertEquals("s_value", controller.s);
}

shared test void testApp004() {
	value controllers = scanControllersInObject(Controllers004());
	assertEquals(1, controllers.size);
	value controllerDesc = controllers.first;
	assert(exists controllerDesc);
	Object controller1 = controllerDesc.instantiate();
	assert(is Controllers004.Index controller1);
	assertEquals("default_s_value", controller1.s);
	Object controller2 = controllerDesc.instantiate("s"->"s_value");
	assert(is Controllers004.Index controller2);
	assertEquals("s_value", controller2.s);
}

shared test void testApp005() {
	value controllers = scanControllersInObject(Controllers005());
	assertEquals(1, controllers.size);
	value controllerDesc = controllers.first;
	assert(exists controllerDesc);
	Object controller1 = controllerDesc.instantiate();
	assert(is Controllers005.Index controller1);
	assertEquals(null, controller1.s);
	Object controller2 = controllerDesc.instantiate("s"->"s_value");
	assert(is Controllers005.Index controller2);
	assertEquals("s_value", controller2.s);
}