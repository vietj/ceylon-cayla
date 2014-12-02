import ceylon.test { ... }
import ceylon.language.meta.declaration { Package }
import io.cayla.web { Application }
import ceylon.net.http.client { Response, Request }
import ceylon.net.uri { Uri, parse }
import test.cayla { assertResolve }

shared Response assertRequest(String uri, {<String->{String*}>*} headers = {}) {
    Uri tmp = parse(uri);
    Request req = Request(tmp);
    for (header in headers) {
        req.setHeader(header.key, *header.item);
    }
    return req.execute();
}

shared test void test001() {
	Package pkg = `package test.cayla.runtime.blocking.support.app001`;
	Application app = Application(pkg);
	value runtime = assertResolve(app.start());
	try {
		Response response = assertRequest("http://localhost:8080/");
		assertEquals(200, response.status);
		assertEquals("text/html", response.contentType);
		assertEquals("false", response.contents);
	} finally {
		runtime.stop();
	}
}
