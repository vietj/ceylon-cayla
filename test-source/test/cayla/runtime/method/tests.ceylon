import ceylon.test { ... }
import ceylon.language.meta.declaration { Package }
import cayla { Application, Runtime }
import ceylon.net.http { Method, get, post }
import ceylon.net.http.client { Response, Request }
import ceylon.net.uri { Uri, parse }

shared Response assertRequest(String uri, {<String->{String*}>*} headers = {}, Method method = get) {
    Uri tmp = parse(uri);
    Request req = Request(tmp, method);
    for (header in headers) {
        req.setHeader(header.key, *header.item);
    }
    return req.execute();
}

void assertMethod(Package pkg, Method success, Method failure) {
	Application app = Application(pkg);
	value runtime = app.start().future.get(1000);
	assert(is Runtime runtime);
	try {
		variable Response response = assertRequest{ uri = "http://localhost:8080/"; method = success; };
		assertEquals(200, response.status);
		assertEquals("text/html", response.contentType);
		assertEquals("hello", response.contents);
		response = assertRequest { uri = "http://localhost:8080/"; method = failure; };
		assertEquals(404, response.status);
	} finally {
		runtime.stop();
	}
}

shared test void test001() {
	assertMethod(`package test.cayla.runtime.method.support.get`, get, post);
}

shared test void test002() {
	assertMethod(`package test.cayla.runtime.method.support.post`, post, get);
}
