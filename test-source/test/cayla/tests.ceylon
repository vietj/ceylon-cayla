import ceylon.test { ... }
import ceylon.language.meta.declaration { ... }
import cayla.descriptor { ControllerDescriptor }
import test.cayla.examples.app001 { Controller001=MyController }
import test.cayla.examples.app002 { Controller002=MyController }
import test.cayla.examples.app003 { Controller003=MyController }
import test.cayla.examples.app004 { Controller004=MyController }

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

test void testApp003() {
	value desc = ControllerDescriptor(Controller003());
	assertEquals(1, desc.handlers.size);
	value handlerDesc = desc.handlers.first;
	assert(exists handlerDesc);
	try {
		handlerDesc.instantiate();
		fail();
	} catch (Exception expected) {
	}
	Object handler = handlerDesc.instantiate("s"->"s_value");
	assert(is Controller003.Index handler);
	assertEquals("s_value", handler.s);
}

test void testApp004() {
	value desc = ControllerDescriptor(Controller004());
	assertEquals(1, desc.handlers.size);
	value handlerDesc = desc.handlers.first;
	assert(exists handlerDesc);
	handlerDesc.instantiate();
	Object handler = handlerDesc.instantiate("s"->"s_value");
	assert(is Controller003.Index handler);
	assertEquals("s_value", handler.s);
}