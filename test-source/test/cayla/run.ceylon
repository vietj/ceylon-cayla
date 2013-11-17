import ceylon.test { createTestRunner, failure, error }
"Run the module `test.cayla`."
shared void run() {
	value runner = createTestRunner([
		`package test.cayla.pattern`,
		`package test.cayla.router`,
		`package test.cayla.descriptor.controller.instantiate`,
		`package test.cayla.descriptor.controller.parameters`,
		`package test.cayla.descriptor.controller.route`,
		`package test.cayla.descriptor.application`,
		`package test.cayla.runtime.route`
	]);
    value _result = runner.run();
    print(_result);
    for(result in _result.results) {
        if (exists a = result.exception) {
            a.printStackTrace();
        }
    }
}