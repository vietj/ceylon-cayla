import ceylon.test { createTestRunner }
"Run the module `test.cayla`."
shared void run() {
	value runner = createTestRunner([
		`package test.cayla.pattern`,
		`package test.cayla.router`,
		`package test.cayla.descriptor.handler.instantiate`,
		`package test.cayla.descriptor.handler.parameters`,
		`package test.cayla.descriptor.handler.route`,
		`package test.cayla.descriptor.application`
	]);
    value result = runner.run();
    print(result);
}