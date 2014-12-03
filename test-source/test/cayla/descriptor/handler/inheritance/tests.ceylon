import io.cayla.web.descriptor { scanHandlersInPackage }
import ceylon.test { test, assertTrue, assertFalse, assertEquals, fail }
import io.cayla.web { Handler }
import test.cayla.descriptor.handler.inheritance.support.noargs { NoArgIndex = Index }
import ceylon.collection { HashMap }
import test.cayla.descriptor.handler.inheritance.support.arg { ArgIndex=Index }

shared test void testNoArg() {
    value controllers = scanHandlersInPackage(`package test.cayla.descriptor.handler.inheritance.support.noargs`);
    assertEquals(1, controllers.size);
    value controllerDesc = controllers.first;
    assert(exists controllerDesc);
    Object controller = controllerDesc.instantiate();
    assert(is NoArgIndex controller);
    assertTrue(controllerDesc.isInstance(controller));
    object h extends Handler() {}
    assertFalse(controllerDesc.isInstance(h));
    assertEquals(HashMap{}, controllerDesc.parameters(controller));
}

shared test void testArg() {
  value controllers = scanHandlersInPackage(`package test.cayla.descriptor.handler.inheritance.support.arg`);
  assertEquals(1, controllers.size);
  value controllerDesc = controllers.first;
  assert(exists controllerDesc);
  try {
    controllerDesc.instantiate();
    fail();
  } catch (Exception expected) {
  }
  Object controller = controllerDesc.instantiate("s"->"s_value");
  assert(is ArgIndex controller);
  assertEquals("s_value", controller.s);
  assertEquals(HashMap{"s"->"s_value"}, controllerDesc.parameters(controller));
}
