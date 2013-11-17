import ceylon.test { ... }
import ceylon.language.meta.declaration { ... }
import cayla.descriptor { ControllerDescriptor, controller }
import test.cayla.descriptor.handler.instantiate.support.app001 { Controller001=MyController }
import test.cayla.descriptor.handler.instantiate.support.app002 { Controller002=MyController }
import test.cayla.descriptor.handler.instantiate.support.app003 { Controller003=MyController }
import test.cayla.descriptor.handler.instantiate.support.app004 { Controller004=MyController }
import test.cayla.descriptor.handler.instantiate.support.app005 { Controller005=MyController }
import cayla { Handler }

shared test void testApp001() {
	value desc = controller(Controller001());
	assert(exists desc);
	assertEquals(1, desc.handlers.size);
	value handlerDesc = desc.handlers.first;
	assert(exists handlerDesc);
	Object handler = handlerDesc.instantiate();
	assert(is Controller001.Index handler);
	assertTrue(handlerDesc.isInstance(handler));
	object h extends Handler() {}
	assertFalse(handlerDesc.isInstance(h));
}

shared test void testApp002() {
	value desc = controller(Controller002());
	assertNull(desc);
}

shared test void testApp003() {
	value desc = controller(Controller003());
	assert(exists desc);
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

shared test void testApp004() {
	value desc = controller(Controller004());
	assert(exists desc);
	assertEquals(1, desc.handlers.size);
	value handlerDesc = desc.handlers.first;
	assert(exists handlerDesc);
	Object handler1 = handlerDesc.instantiate();
	assert(is Controller004.Index handler1);
	assertEquals("default_s_value", handler1.s);
	Object handler2 = handlerDesc.instantiate("s"->"s_value");
	assert(is Controller004.Index handler2);
	assertEquals("s_value", handler2.s);
}

shared test void testApp005() {
	value desc = controller(Controller005());
	assert(exists desc);
	assertEquals(1, desc.handlers.size);
	value handlerDesc = desc.handlers.first;
	assert(exists handlerDesc);
	Object handler1 = handlerDesc.instantiate();
	assert(is Controller005.Index handler1);
	assertEquals(null, handler1.s);
	Object handler2 = handlerDesc.instantiate("s"->"s_value");
	assert(is Controller005.Index handler2);
	assertEquals("s_value", handler2.s);
}