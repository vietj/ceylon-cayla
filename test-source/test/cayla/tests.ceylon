import ceylon.test { ... }
import ceylon.language.meta.declaration { ... }
import cayla.descriptor { ControllerDescriptor }
import test.cayla.examples.app001 { Controller001=MyController }
import test.cayla.examples.app002 { Controller002=MyController }

test void testApp001() {
	value desc = ControllerDescriptor(Controller001());
	assertEquals(1, desc.handlers.size);
	value handlerDesc = desc.handlers.first;
	assert(exists handlerDesc);
	Object handler = handlerDesc.instantiate();
	assert(is Controller001.Index handler);
}

test void testApp002() {
	value desc = ControllerDescriptor(Controller002());
	assertEquals(0, desc.handlers.size);
}