import cayla.descriptor { ControllerDescriptor, controller }
import ceylon.test { test, assertEquals }
import test.cayla.handler.parameters.support.app001 { Controller001=MyController }
import test.cayla.handler.parameters.support.app002 { Controller002=MyController }
import test.cayla.handler.parameters.support.app003 { Controller003=MyController }

shared test void test001() {
	value desc = controller(Controller001());
	assert(exists desc);
	assertEquals(1, desc.handlers.size);
	value handlerDesc = desc.handlers.first;
	assert(exists handlerDesc);
	Controller001.Index handler = Controller001().create();
	assertEquals(LazyMap({}), handlerDesc.parameters(handler));
}

shared test void test002() {
	value desc = controller(Controller002());
	assert(exists desc);
	assertEquals(1, desc.handlers.size);
	value handlerDesc = desc.handlers.first;
	assert(exists handlerDesc);
	Controller002.Index handler = Controller002().create("s_value");
	assertEquals(LazyMap({"s"->"s_value"}), handlerDesc.parameters(handler));
}

shared test void test003() {
	value desc = controller(Controller003());
	assert(exists desc);
	assertEquals(1, desc.handlers.size);
	value handlerDesc = desc.handlers.first;
	assert(exists handlerDesc);
	Controller003.Index handler1 = Controller003().create("s_value");
	assertEquals(LazyMap({"s"->"s_value"}), handlerDesc.parameters(handler1));
	Controller003.Index handler2 = Controller003().create(null);
	assertEquals(LazyMap({}), handlerDesc.parameters(handler2));
}
