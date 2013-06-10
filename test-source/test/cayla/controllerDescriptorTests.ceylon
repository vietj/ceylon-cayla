import cayla { ... }
import ceylon.test { ... }

void controllerDescriptorTests() {
	
	//
	testSatisfiedSame();
	testSatisfiedSubset();
	testUnsatisfiedSubset();
	testUnsatisfiedDisjoint();
	
	//
	testDefaultSatisfiedSame();
	testDefaultSatisfiedSubset();
	
	//
	testProvideOptionalParameter();
	testMissingOptionalParameter();
	
	//
	testEmptyParameters();
	testParameters();
	testNotResolved();
	
	//
	testInstanceOf();
	
}

abstract class TestApp<C>() extends Application() {
	
	shared void testSatisfied({<String->String>*} expected, {<String->String>*} params) {
		LazyMap<String, String> expectedMap = LazyMap(expected);
		ApplicationDescriptor appDesc = build();
		if (exists desc = appDesc.controllers.first) {
			Controller? controller = desc.create(params);
			if (exists c = controller) {
				if (is C c) {
					assertController(expectedMap, c);
				} else {
					fail("Was expecting controller to be of the correct instance");
				}
			} else {
				fail("Was expecting controller instance");
			}
		} else {
			fail("Was expecting a controller");
		}
	}
	
	shared formal void assertController(Map<String, String> expectedMap, C controller);
	
	shared void testUnsatisfied(<String->String>* params) {
		ApplicationDescriptor appDesc = build();
		if (exists desc = appDesc.controllers.first) {
			Controller? controller = desc.create(params);
			if (exists c = controller) {
				fail("Was expecting controller instance");
			}
		} else {
			fail("Was expecting a controller");
		}
	}
}

class MyApp() extends TestApp<MyController>() {
	shared class MyController(shared String foo, shared String bar) extends Controller() {
	}
	shared actual void assertController(Map<String, String> expectedMap, MyController controller) {
		assertEquals(expectedMap["foo"], controller.foo);
		assertEquals(expectedMap["bar"], controller.bar);
	}
}

void testSatisfiedSame() {
	MyApp().testSatisfied({"foo" -> "foo_value", "bar" -> "bar_value"}, {"foo" -> "foo_value", "bar" -> "bar_value"});
}

void testSatisfiedSubset() {
	MyApp().testSatisfied({"foo" -> "foo_value", "bar" -> "bar_value"}, {"foo" -> "foo_value", "bar" -> "bar_value", "daa" -> "daa_value"});
}

void testUnsatisfiedSubset() {
	MyApp().testUnsatisfied("foo" -> "foo_value");
}

void testUnsatisfiedDisjoint() {
	MyApp().testUnsatisfied("juu" -> "juu_value");
}

class MyApp2() extends TestApp<MyController2>() {
	shared class MyController2(shared String foo, shared String bar = "default_bar") extends Controller() {
	}
	shared actual void assertController(Map<String, String> expectedMap, MyController2 controller) {
		assertEquals(expectedMap["foo"], controller.foo);
		assertEquals(expectedMap["bar"], controller.bar);
	}
}

void testDefaultSatisfiedSame() {
	MyApp2().testSatisfied({"foo" -> "foo_value", "bar" -> "bar_value"}, {"foo" -> "foo_value", "bar" -> "bar_value"});
}

void testDefaultSatisfiedSubset() {
	MyApp2().testSatisfied({"foo" -> "foo_value", "bar" -> "default_bar"}, {"foo" -> "foo_value"});
}

class MyApp3() extends Application() {
	shared class MyController() extends Controller() {
	}
}

void testInstanceOf() {
	MyApp3 app = MyApp3();
	ApplicationDescriptor desc = app.build();
	if (exists controllerDesc = desc.controllers.first) {
		if (exists controller = controllerDesc.create()) {
			assertTrue(controllerDesc.isInstance(controller));
			assertEquals(controllerDesc, desc.descriptor(controller));
		} else {
			fail();
		}
	} else {
		fail();
	}
}

class OptionalParametersApp() extends Application() {
	shared class MyController(shared String? opt) extends Controller() {
	}
}

void testProvideOptionalParameter() {
	OptionalParametersApp app = OptionalParametersApp();
	ApplicationDescriptor desc = app.build();
	if (exists controllerDesc = desc.controllers.first) {
		if (exists controller = controllerDesc.create({"opt"->"opt_value"})) {
			Map<String, String> parameters = controllerDesc.getParameters(controller);
			assertEquals(LazyMap({"opt"->"opt_value"}), parameters);
		} else {
			fail();
		}
	} else {
		fail();
	}
}

void testMissingOptionalParameter() {
	OptionalParametersApp app = OptionalParametersApp();
	ApplicationDescriptor desc = app.build();
	if (exists controllerDesc = desc.controllers.first) {
		if (exists controller = controllerDesc.create({})) {
			Map<String, String> parameters = controllerDesc.getParameters(controller);
			assertEquals(LazyMap({}), parameters);
		} else {
			fail();
		}
	} else {
		fail();
	}
}

class EmptyParametersApp() extends Application() {
	shared class MyController() extends Controller() {
	}
}

void testEmptyParameters() {
	EmptyParametersApp app = EmptyParametersApp();
	ApplicationDescriptor desc = app.build();
	if (exists controllerDesc = desc.controllers.first) {
		if (exists controller = controllerDesc.create()) {
			Map<String, String> parameters = controllerDesc.getParameters(controller);
			assertEquals(LazyMap({}), parameters);
		} else {
			fail();
		}
	} else {
		fail();
	}
}
class MyApp4() extends Application() {
	shared class MyController(shared String foo) extends Controller() {
	}
}

void testParameters() {
	MyApp4 app = MyApp4();
	ApplicationDescriptor desc = app.build();
	if (exists controllerDesc = desc.controllers.first) {
		if (exists controller = controllerDesc.create({"foo"->"foo_value"})) {
			Map<String, String> parameters = controllerDesc.getParameters(controller);
			assertEquals(LazyMap({"foo"->"foo_value"}), parameters);
		} else {
			fail();
		}
	} else {
		fail();
	}
}

void testNotResolved() {
	MyApp4 app = MyApp4();
	ApplicationDescriptor desc = app.build();
	if (exists controllerDesc = desc.controllers.first) {
		if (exists controller = controllerDesc.create({})) {
			fail();
		} else {
			// Ok
		}
	} else {
		fail();
	}
}