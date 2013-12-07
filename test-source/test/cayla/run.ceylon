import ceylon.test { createTestRunner, SimpleLoggingListener }
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
		`package test.cayla.runtime.response`
	], [SimpleLoggingListener()]);
    value _result = runner.run();
    print(_result);
    /*
    for(result in _result.results) {
        if (exists a = result.exception) {
            a.printStackTrace();
        }
    }
     */
}