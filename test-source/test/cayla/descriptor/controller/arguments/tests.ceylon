import cayla.descriptor { scanControllersInPackage }
import ceylon.test { test, assertTrue, assertFalse, assertEquals, fail, assertThatException }
import cayla { Controller }
import test.cayla.descriptor.controller.arguments.support.empty { EmptyIndex = Index }
import test.cayla.descriptor.controller.arguments.support.sharedstring { SharedStringIndex = Index }
import test.cayla.descriptor.controller.arguments.support.shareddefaultstring { SharedDefaultStringIndex = Index }
import test.cayla.descriptor.controller.arguments.support.sharedstringornull { SharedStringOrNullIndex = Index }
import test.cayla.descriptor.controller.arguments.support.shareddefaultstringornull001 { SharedDefaultStringOrNullIndex001 = Index }
import test.cayla.descriptor.controller.arguments.support.shareddefaultstringornull002 { SharedDefaultStringOrNullIndex002 = Index }
import test.cayla.descriptor.controller.arguments.support.sharedboolean { SharedBooleanIndex=Index }
import test.cayla.descriptor.controller.arguments.support.sharedinteger { SharedIntegerIndex=Index }
import test.cayla.descriptor.controller.arguments.support.shareddefaultinteger { SharedDefaultIntegerIndex = Index }

shared test void testEmpty() {
    value controllers = scanControllersInPackage(`package test.cayla.descriptor.controller.arguments.support.empty`);
    assertEquals(1, controllers.size);
    value controllerDesc = controllers.first;
    assert(exists controllerDesc);
    Object controller = controllerDesc.instantiate();
    assert(is EmptyIndex controller);
    assertTrue(controllerDesc.isInstance(controller));
    object h extends Controller() {}
    assertFalse(controllerDesc.isInstance(h));
    assertEquals(LazyMap({}), controllerDesc.parameters(controller));
}

shared test void testSharedString() {
    value controllers = scanControllersInPackage(`package test.cayla.descriptor.controller.arguments.support.sharedstring`);
    assertEquals(1, controllers.size);
    value controllerDesc = controllers.first;
    assert(exists controllerDesc);
    try {
        controllerDesc.instantiate();
        fail();
    } catch (Exception expected) {
    }
    Object controller = controllerDesc.instantiate("s"->"s_value");
    assert(is SharedStringIndex controller);
    assertEquals("s_value", controller.s);
    assertEquals(LazyMap({"s"->"s_value"}), controllerDesc.parameters(controller));
}

shared test void testSharedDefaultString() {
    value controllers = scanControllersInPackage(`package test.cayla.descriptor.controller.arguments.support.shareddefaultstring`);
    assertEquals(1, controllers.size);
    value controllerDesc = controllers.first;
    assert(exists controllerDesc);
    Object controller1 = controllerDesc.instantiate();
    assert(is SharedDefaultStringIndex controller1);
    assertEquals("default_s_value", controller1.s);
    Object controller2 = controllerDesc.instantiate("s"->"s_value");
    assert(is SharedDefaultStringIndex controller2);
    assertEquals("s_value", controller2.s);
}

shared test void testSharedStringOrNull() {
    value controllers = scanControllersInPackage(`package test.cayla.descriptor.controller.arguments.support.sharedstringornull`);
    assertEquals(1, controllers.size);
    value controllerDesc = controllers.first;
    assert(exists controllerDesc);
    Object controller1 = controllerDesc.instantiate();
    assert(is SharedStringOrNullIndex controller1);
    assertEquals(null, controller1.s);
    assertEquals(LazyMap({}), controllerDesc.parameters(controller1));
    Object controller2 = controllerDesc.instantiate("s"->"s_value");
    assert(is SharedStringOrNullIndex controller2);
    assertEquals("s_value", controller2.s);
    assertEquals(LazyMap({"s"->"s_value"}), controllerDesc.parameters(controller2));
}

shared test void testSharedDefaultStringOrNull001() {
    value controllers = scanControllersInPackage(`package test.cayla.descriptor.controller.arguments.support.shareddefaultstringornull001`);
    assertEquals(1, controllers.size);
    value controllerDesc = controllers.first;
    assert(exists controllerDesc);
    Object controller1 = controllerDesc.instantiate();
    assert(is SharedDefaultStringOrNullIndex001 controller1);
    assertEquals("default_value", controller1.s);
    Object controller2 = controllerDesc.instantiate("s"->"s_value");
    assert(is SharedDefaultStringOrNullIndex001 controller2);
    assertEquals("s_value", controller2.s);
}

shared test void testSharedDefaultStringOrNull002() {
    value controllers = scanControllersInPackage(`package test.cayla.descriptor.controller.arguments.support.shareddefaultstringornull002`);
    assertEquals(1, controllers.size);
    value controllerDesc = controllers.first;
    assert(exists controllerDesc);
    Object controller1 = controllerDesc.instantiate();
    assert(is SharedDefaultStringOrNullIndex002 controller1);
    assertEquals(null, controller1.s);
    Object controller2 = controllerDesc.instantiate("s"->"s_value");
    assert(is SharedDefaultStringOrNullIndex002 controller2);
    assertEquals("s_value", controller2.s);
}

shared test void testSharedBoolean() {
    value controllers = scanControllersInPackage(`package test.cayla.descriptor.controller.arguments.support.sharedboolean`);
    assertEquals(1, controllers.size);
    value controllerDesc = controllers.first;
    assert(exists controllerDesc);
    value controller1 = controllerDesc.instantiate("s"->"true");
    assert(is SharedBooleanIndex controller1);
    assertEquals(true, controller1.s);
    assertEquals(LazyMap({"s"->"true"}), controllerDesc.parameters(controller1));
    assertThatException(() => controllerDesc.instantiate("s"->"unparseable"));
}

shared test void testSharedInteger() {
    value controllers = scanControllersInPackage(`package test.cayla.descriptor.controller.arguments.support.sharedinteger`);
    assertEquals(1, controllers.size);
    value controllerDesc = controllers.first;
    assert(exists controllerDesc);
    value controller1 = controllerDesc.instantiate("s"->"4");
    assert(is SharedIntegerIndex controller1);
    assertEquals(4, controller1.s);
    assertEquals(LazyMap({"s"->"4"}), controllerDesc.parameters(controller1));
    assertThatException(() => controllerDesc.instantiate("s"->"unparseable"));
}

shared test void testSharedDefaultInteger() {
    value controllers = scanControllersInPackage(`package test.cayla.descriptor.controller.arguments.support.shareddefaultinteger`);
    assertEquals(1, controllers.size);
    value controllerDesc = controllers.first;
    assert(exists controllerDesc);
    Object controller1 = controllerDesc.instantiate();
    assert(is SharedDefaultIntegerIndex controller1);
    assertEquals(5, controller1.s);
    Object controller2 = controllerDesc.instantiate("s"->"3");
    assert(is SharedDefaultIntegerIndex controller2);
    assertEquals(3, controller2.s);
}

shared test void testUnshared() {
    assertThatException(() => scanControllersInPackage(`package test.cayla.descriptor.controller.arguments.support.unshared`));
}

shared test void testSharedObject() {
    assertThatException(() => scanControllersInPackage(`package test.cayla.descriptor.controller.arguments.support.sharedobject`));
}

