import ceylon.test { ... }
import ceylon.language.meta.declaration { Package }
import io.cayla.web.descriptor { ApplicationDescriptor }
import ceylon.language.meta { type }
import ceylon.collection {
  LinkedList
}

shared test void testApp001() =>
    assertHandler(`package test.cayla.descriptor.application.support.app001`, "Index");

shared test void testApp002() =>
    assertHandler(`package test.cayla.descriptor.application.support.app002`, "Index");

shared test void testApp003() =>
    assertHandler(`package test.cayla.descriptor.application.support.app003`, "controllers.Index");

shared test void testApp004() =>
    assertNoHandlers(`package test.cayla.descriptor.application.support.app004`);

shared test void testApp005() =>
    assertHandler(`package test.cayla.descriptor.application.support.app005`, "foo.bar.Index");

shared test void testApp006() =>
    assertNoHandlers(`package test.cayla.descriptor.application.support.app006`);

void assertHandler(Package pkg, String expectedQualifiedName) {
  ApplicationDescriptor app = ApplicationDescriptor(pkg);
  assertEquals(1, app.handlers.size);
  assert(exists desc = app.handlers.first);
  value handler = desc.instantiate();
  assertEquals(type(handler).declaration.qualifiedName, pkg.qualifiedName + "::" + expectedQualifiedName);
}

void assertNoHandlers(Package pkg) {
  ApplicationDescriptor app = ApplicationDescriptor(pkg);
  assertEquals(LinkedList(), LinkedList(app.handlers));
}
