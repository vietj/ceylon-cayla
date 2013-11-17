import ceylon.test { ... }
import ceylon.language.meta.declaration { Package }
import cayla { Application, Runtime }
import ceylon.net.http.client { Response, Request }
import ceylon.net.uri { Uri, parse }

shared Response assertRequest(String uri, {<String->{String*}>*} headers = {}) {
    Uri tmp = parse(uri);
    Request req = Request(tmp);
    for (header in headers) {
        req.setHeader(header.key, *header.item);
    }
    return req.execute();
}

void assertOK(String expected, Package pkg) {
	Application app = Application(pkg);
	value runtime = app.start().future.get(1000);
	assert(is Runtime runtime);
	try {
		Response response = assertRequest("http://localhost:8080/");
		assertEquals(200, response.status);
		assertEquals("text/html", response.contentType);
		assertEquals(expected, response.contents);
	} finally {
		runtime.stop();
	}
}

shared test void test001() {
	assertOK("http://localhost:8080", `package test.cayla.runtime.url.support.app001`);
}

shared test void test002() {
	assertOK("http://localhost:8080/foo", `package test.cayla.runtime.url.support.app002`);
}

shared test void test003() {
	assertOK("http://localhost:8080/juu", `package test.cayla.runtime.url.support.app003`);
}
