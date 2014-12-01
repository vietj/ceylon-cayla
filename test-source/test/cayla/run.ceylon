import ceylon.test { createTestRunner, assertEquals }
import ceylon.test.core { DefaultLoggingListener }
import ceylon.collection { LinkedList }
import ceylon.promise { ExecutionContext, defineGlobalExecutionContext }

"Run the module `test.cayla`."
shared void run() {
  
  variable Integer executions = 0;
  object ctx satisfies ExecutionContext {
    shared actual ExecutionContext childContext() => this;
    shared actual void run(void task()) {
      executions++;
      task();
    }
  }
  
  defineGlobalExecutionContext(ctx);
  
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
	], [DefaultLoggingListener()]);
    value _result = runner.run();
    print(_result);
    /*
    for(result in _result.results) {
        if (exists a = result.exception) {
            a.printStackTrace();
        }
    }
     */
    
    if (executions > 0) {
      throw AssertionError("No global execution context should be used");
    }
}

shared void assertSameIterable<Element>({Element*} expected, {Element*} actual) {
	assertEquals(LinkedList(expected), LinkedList(actual));
}