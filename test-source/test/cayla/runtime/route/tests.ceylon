import ceylon.test { ... }
import ceylon.language.meta.declaration { Package }
import cayla { Application, Runtime }
import ceylon.net.http.client { Response, Parser, Request }
import ceylon.net.uri { Uri, parse }
import java.lang { Thread { currentThread } }

shared Response assertRequest(String uri, {<String->{String*}>*} headers = {}) {
    Uri tmp = parse(uri);
    Request req = Request(tmp);
    for (header in headers) {
        req.setHeader(header.key, *header.item);
    }
    return req.execute();
}

shared test void test001() {
	Package pkg = `package test.cayla.runtime.route.support.app001`;
	Application app = Application(pkg);
	value runtime = app.start().future.get(1000);
	assert(is Runtime runtime);
	try {
		Response response = assertRequest("http://localhost:8080/");
		assertEquals(200, response.status);
		assertEquals("text/html", response.contentType);
		assertEquals("hello", response.contents);
	} finally {
		runtime.stop();
	}
}

shared test void test002() {
	Package pkg = `package test.cayla.runtime.route.support.app002`;
	Application app = Application(pkg);
	value runtime = app.start().future.get(1000);
	assert(is Runtime runtime);
	try {
		Response response1 = assertRequest("http://localhost:8080/");
		assertEquals(404, response1.status);
		Response response2 = assertRequest("http://localhost:8080/foo");
		assertEquals(200, response2.status);
		assertEquals("text/html", response2.contentType);
		assertEquals("foo", response2.contents);
	} finally {
		runtime.stop();
	}
}

shared test void test003() {
	Package pkg = `package test.cayla.runtime.route.support.app003`;
	Application app = Application(pkg);
	value runtime = app.start().future.get(1000);
	assert(is Runtime runtime);
	try {
		Response response1 = assertRequest("http://localhost:8080/");
		assertEquals(404, response1.status);
		Response response2 = assertRequest("http://localhost:8080/bar");
		assertEquals(200, response2.status);
		assertEquals("text/html", response2.contentType);
		assertEquals(">bar<", response2.contents);
	} finally {
		runtime.stop();
	}
}
