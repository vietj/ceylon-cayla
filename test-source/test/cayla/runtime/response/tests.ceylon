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

shared test void test001() {
	Package pkg = `package test.cayla.runtime.response.support.app001`;
	Application app = Application(pkg);
	value runtime = app.start().future.get(1000);
	assert(is Runtime runtime);
	try {
		Response response = assertRequest("http://localhost:8080/");
		assertEquals(200, response.status);
		assertEquals("text/html", response.contentType);
		assertEquals("hello_promise", response.contents);
	} finally {
		runtime.stop();
	}
}

shared test void test002() {
	Package pkg = `package test.cayla.runtime.response.support.app002`;
	Application app = Application(pkg);
	value runtime = app.start().future.get(1000);
	assert(is Runtime runtime);
	try {
		Response response = assertRequest("http://localhost:8080/");
		assertEquals(500, response.status);
	} finally {
		runtime.stop();
	}
}

shared test void test003() {
	Package pkg = `package test.cayla.runtime.response.support.app003`;
	Application app = Application(pkg);
	value runtime = app.start().future.get(1000);
	assert(is Runtime runtime);
	try {
		Response response = assertRequest("http://localhost:8080/");
		assertEquals(500, response.status);
	} finally {
		runtime.stop();
	}
}