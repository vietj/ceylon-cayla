import cayla.descriptor { scanControllersInObject }
import ceylon.test { test, assertEquals }
import test.cayla.descriptor.controller.parameters.support.app001 { Controllers001=Controllers }
import test.cayla.descriptor.controller.parameters.support.app002 { Controllers002=Controllers }
import test.cayla.descriptor.controller.parameters.support.app003 { Controllers003=Controllers }

shared test void test001() {
	value controllers = scanControllersInObject(Controllers001());
	assertEquals(1, controllers.size);
	value controllerDesc = controllers.first;
	assert(exists controllerDesc);
	Controllers001.Index controller = Controllers001().create();
	assertEquals(LazyMap({}), controllerDesc.parameters(controller));
}

shared test void test002() {
	value controllers = scanControllersInObject(Controllers002());
	assertEquals(1, controllers.size);
	value controllerDesc = controllers.first;
	assert(exists controllerDesc);
	Controllers002.Index controller = Controllers002().create("s_value");
	assertEquals(LazyMap({"s"->"s_value"}), controllerDesc.parameters(controller));
}

shared test void test003() {
	value controllers = scanControllersInObject(Controllers003());
	assertEquals(1, controllers.size);
	value controllerDesc = controllers.first;
	assert(exists controllerDesc);
	Controllers003.Index controller1 = Controllers003().create("s_value");
	assertEquals(LazyMap({"s"->"s_value"}), controllerDesc.parameters(controller1));
	Controllers003.Index controller2 = Controllers003().create(null);
	assertEquals(LazyMap({}), controllerDesc.parameters(controller2));
}
