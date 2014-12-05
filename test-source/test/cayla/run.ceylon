import ceylon.test { createTestRunner, assertEquals }
import ceylon.test.core { DefaultLoggingListener }
import ceylon.collection { LinkedList }

"Run the module `test.cayla`."
shared void run() {
	value runner = createTestRunner([
		`package test.cayla.pattern`,
		`package test.cayla.router`,
		`package test.cayla.template`,
		`package test.cayla.descriptor.handler.arguments`,
		`package test.cayla.descriptor.handler.method`,
		`package test.cayla.descriptor.handler.route`,
		`package test.cayla.descriptor.application`,
		`package test.cayla.runtime.route`,
		`package test.cayla.runtime.method`,
		`package test.cayla.runtime.url`,
		`package test.cayla.runtime.response`,
		`package test.cayla.runtime.assets`
		], [DefaultLoggingListener()]);
	value _result = runner.run();
	print(_result);
}

shared void assertSameIterable<Element>({Element*} expected, {Element*} actual) {
	assertEquals(LinkedList(expected), LinkedList(actual));
}