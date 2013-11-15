import ceylon.test { createTestRunner }
"Run the module `test.cayla`."
shared void run() {
	value runner = createTestRunner([`testApp001`,`testApp002`]);
    value result = runner.run();
    print(result);
}