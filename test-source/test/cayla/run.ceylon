import ceylon.test { createTestRunner }
"Run the module `test.cayla`."
shared void run() {
	value runner = createTestRunner([
	`testApp001`,`testApp002`,`testApp003`,`testApp004`,`testApp005`,
	`package test.cayla.support.handler.parameters`]);
    value result = runner.run();
    print(result);
}