import ceylon.test { ... }
import ceylon.language.meta.declaration { Package }
import cayla.descriptor { ApplicationDescriptor, ControllerDescriptor }
import test.cayla.descriptor.application.support.app001 { controller001=controllers }
import test.cayla.descriptor.application.support.app002 { controller002=controllers }
import test.cayla.descriptor.application.support.app003 { Index003=Index }

shared test void test001() {
	Package pkg = `package test.cayla.descriptor.application.support.app001`;
	ApplicationDescriptor desc = ApplicationDescriptor(pkg);
	assertEquals(1, desc.controllers.size);
	ControllerDescriptor? controller = desc.controllers[0];
	assert(exists controller);
}

shared test void test002() {
	Package pkg = `package test.cayla.descriptor.application.support.app002`;
	ApplicationDescriptor desc = ApplicationDescriptor(pkg);
	value matches = desc.resolve("/foo_value/bar");
	assert(exists match = matches.first);
	assertEquals(LazyMap({"foo"->"foo_value"}), match.params);
	value controller = match.target.instantiate(*match.params);
	assert(exists index = controller002.isInstance(controller));
	assertEquals("foo_value", index.foo);
	assertEquals("default_bar", index.bar);
}

shared test void test003() {
	Package pkg = `package test.cayla.descriptor.application.support.app003`;
	ApplicationDescriptor desc = ApplicationDescriptor(pkg);
	value matches = desc.resolve("/foo_value/bar");
	assert(exists match = matches.first);
	assertEquals(LazyMap({"foo"->"foo_value"}), match.params);
	value controller = match.target.instantiate(*match.params);
	assert(is Index003 controller);
	assertEquals("foo_value", controller.foo);
	assertEquals("default_bar", controller.bar);
}
