import ceylon.test { test, assertEquals }
import ceylon.language.meta.declaration { Package }
import cayla.descriptor { ApplicationDescriptor, ControllerDescriptor }
import test.cayla.application.descriptor.support.app001 { controller001=mycontroller }

shared test void test001() {
	Package pkg = `package test.cayla.application.descriptor.support.app001`;
	ApplicationDescriptor desc = ApplicationDescriptor(pkg);
	assertEquals(1, desc.controllers.size);
	ControllerDescriptor? controller = desc.controllers[0];
	assert(exists controller);
	assertEquals(controller001, controller.controller);
}
