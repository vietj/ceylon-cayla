import ceylon.test { createTestRunner }
"Run the module `test.cayla`."
shared void run() {
	value runner = createTestRunner([
		`package test.cayla.pattern`,
		`package test.cayla.router`,
		`package test.cayla.handler.instantiate`,
		`package test.cayla.handler.parameters`,
		`package test.cayla.handler.route`,
		`package test.cayla.application.descriptor`
	]);
    value result = runner.run();
    print(result);
}