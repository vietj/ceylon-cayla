import ceylon.test { ... }
import ceylon.language.meta.declaration { Package }
import cayla.descriptor { ApplicationDescriptor, ControllerDescriptor }
import test.cayla.descriptor.application.support.route001 { controllersRoute001=controllers }
import test.cayla.descriptor.application.support.route002 { IndexRoute1=Index }
import test.cayla.descriptor.application.support.decl002 { fooDecl002=foo }

shared test void testDecl001() {
	Package pkg = `package test.cayla.descriptor.application.support.decl001`;
	ApplicationDescriptor desc = ApplicationDescriptor(pkg);
	assertEquals(1, desc.controllers.size);
	ControllerDescriptor? controller = desc.controllers[0];
	assert(exists controller);
}

shared test void testDecl002() {
    Package pkg = `package test.cayla.descriptor.application.support.decl002`;
    ApplicationDescriptor desc = ApplicationDescriptor(pkg);
    assert(exists match = desc.controllers.first);
    value controller = match.instantiate();
    assert(fooDecl002.isIndex(controller));
}

shared test void testRoute001() {
	Package pkg = `package test.cayla.descriptor.application.support.route001`;
	ApplicationDescriptor desc = ApplicationDescriptor(pkg);
	value matches = desc.resolve("/foo_value/bar");
	assert(exists match = matches.first);
	assertEquals(LazyMap({"foo"->"foo_value"}), match.params);
	value controller = match.target.instantiate(*match.params);
	assert(exists index = controllersRoute001.isInstance(controller));
	assertEquals("foo_value", index.foo);
	assertEquals("default_bar", index.bar);
}

shared test void testRoute002() {
	Package pkg = `package test.cayla.descriptor.application.support.route002`;
	ApplicationDescriptor desc = ApplicationDescriptor(pkg);
	value matches = desc.resolve("/foo_value/bar");
	assert(exists match = matches.first);
	assertEquals(LazyMap({"foo"->"foo_value"}), match.params);
	value controller = match.target.instantiate(*match.params);
	assert(is IndexRoute1 controller);
	assertEquals("foo_value", controller.foo);
	assertEquals("default_bar", controller.bar);
}

