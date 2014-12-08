import ceylon.test { ... }
import ceylon.language.meta.declaration { Package }
import io.cayla.web.descriptor { ApplicationDescriptor }
import test.cayla.descriptor.route.support.app001 { controllersRoute001=controllers }
import test.cayla.descriptor.route.support.app002 { IndexRoute1=Index }
import test.cayla.descriptor.route.support.app003 { fooRoute003=foo }
import ceylon.net.uri { Path, Query, PathSegment }
import ceylon.collection { HashMap }

shared test void testRoute001() {
	Package pkg = `package test.cayla.descriptor.route.support.app001`;
	ApplicationDescriptor desc = ApplicationDescriptor(pkg);
	value matches = desc.resolve("/foo_value/bar");
	assert(exists match = matches.first);
	assertEquals(HashMap{"foo"->"foo_value"}, match.params);
	value controller = match.target.instantiate(*match.params);
	assert(exists index = controllersRoute001.isInstance(controller));
	assertEquals("foo_value", index.foo);
	assertEquals("default_bar", index.bar);
}

shared test void testRoute002() {
	Package pkg = `package test.cayla.descriptor.route.support.app002`;
	ApplicationDescriptor desc = ApplicationDescriptor(pkg);
	value matches = desc.resolve("/foo_value/bar");
	assert(exists match = matches.first);
	assertEquals(HashMap{"foo"->"foo_value"}, match.params);
	value controller = match.target.instantiate(*match.params);
	assert(is IndexRoute1 controller);
	assertEquals("foo_value", controller.foo);
	assertEquals("default_bar", controller.bar);
}

shared test void testRoute003() {
    Package pkg = `package test.cayla.descriptor.route.support.app003`;
    ApplicationDescriptor desc = ApplicationDescriptor(pkg);
    assertEquals(1, desc.handlers.size);
    value instance = fooRoute003.instance();
    assertEquals([Path(true, PathSegment("foo"), PathSegment("bar")),Query()], desc.path(instance));
    value matches = desc.resolve("/foo/bar");
    assert(exists match = matches.first);
    assertEquals(HashMap{}, match.params);
    value controller = match.target.instantiate(*match.params);
    assert(fooRoute003.isIndex(controller));
    assertEquals(0, desc.resolve("/foo").size);
}
