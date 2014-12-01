import ceylon.test { ... }
import ceylon.language.meta.declaration { Package }
import io.cayla.web { Application }
import ceylon.net.http { Method, get, post }
import ceylon.net.http.client { Response, Request }
import ceylon.net.uri { Uri, parse }
import test.cayla { assertResolve }

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
	value runtime = assertResolve(app.start());
	try {
		variable Response response = assertRequest{ uri = "http://localhost:8080/"; method = success; };
		assertEquals(response.status, 200);
		assertEquals(response.contentType, "text/html");
		assertEquals(response.contents, "hello");
		response = assertRequest { uri = "http://localhost:8080/"; method = failure; };
		assertEquals(response.status, 404);
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
