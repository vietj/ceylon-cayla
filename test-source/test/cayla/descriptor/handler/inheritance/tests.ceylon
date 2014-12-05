import io.cayla.web.descriptor { scanHandlersInPackage }
import ceylon.test { test, assertTrue, assertFalse, assertEquals, fail }
import io.cayla.web { Handler }
import ceylon.collection { HashMap }
import test.cayla.descriptor.handler.inheritance.support.app001 { ArgIndex=Index }
import test.cayla.descriptor.handler.inheritance.support.app002 { NoArgIndex = Index }
import test.cayla.descriptor.handler.inheritance.support.app003 { mycontroller }

shared test void testClassArg() {
  value controllers = scanHandlersInPackage(`package test.cayla.descriptor.handler.inheritance.support.app001`);
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

shared test void testClassNoArg() {
    value controllers = scanHandlersInPackage(`package test.cayla.descriptor.handler.inheritance.support.app002`);
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

shared test void testNestedClassArg() {
  value controllers = scanHandlersInPackage(`package test.cayla.descriptor.handler.inheritance.support.app003`);
  assertEquals(1, controllers.size);
  value controllerDesc = controllers.first;
  assert(exists controllerDesc);
  try {
    controllerDesc.instantiate();
    fail();
  } catch (Exception expected) {
  }
  Object controller = controllerDesc.instantiate("s"->"s_value");
  assert(is Handler controller);
  // todo : how to ref a class in an object  ?
  // assert(is ArgIndex controller);
  // assertEquals("s_value", controller.s);
  assertEquals(HashMap{"s"->"s_value"}, controllerDesc.parameters(controller));
}

