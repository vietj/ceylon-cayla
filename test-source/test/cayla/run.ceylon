import ceylon.test { createTestRunner }
"Run the module `test.cayla`."
shared void run() {
	value runner = createTestRunner([`doSomething`]);
    value result = runner.run();
    print(result);
}