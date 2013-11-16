import ceylon.test { createTestRunner }
"Run the module `test.cayla`."
shared void run() {
	value runner = createTestRunner([
		`package test.cayla.handler.instantiate`,
		`package test.cayla.handler.parameters`,
		`package test.cayla.application`
	]);
    value result = runner.run();
    print(result);
}