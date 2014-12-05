import ceylon.test { ... }
import ceylon.language.meta.declaration { Package }
import io.cayla.web { Application }
import ceylon.net.http.client { Response, Request }
import ceylon.net.uri { Uri, parse }
import test.cayla.runtime.url.support.any001 { pathAny001=path }
import test.cayla.runtime.url.support.oneormore001 { pathOneOrMore001=path }
import test.cayla { assertResolve }

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
	value runtime = assertResolve(app.start());
	try {
		Response response = assertRequest("http://localhost:8080/");
		assertEquals(200, response.status);
		assertEquals("text/html", response.contentType);
		assertEquals(expected, response.contents);
	} finally {
		assertResolve(runtime.stop());
	}
}

shared test void testRoot001() {
	assertOK("http://localhost:8080", `package test.cayla.runtime.url.support.root001`);
}

shared test void testSegment001() {
	assertOK("http://localhost:8080/foo", `package test.cayla.runtime.url.support.segment001`);
}

shared test void testExpression001() {
	assertOK("http://localhost:8080/juu", `package test.cayla.runtime.url.support.expression001`);
}

shared test void testAny001() {
    pathAny001.val = "";
    assertOK("http://localhost:8080/prefix", `package test.cayla.runtime.url.support.any001`);
    pathAny001.val = "juu";
    assertOK("http://localhost:8080/prefix/juu", `package test.cayla.runtime.url.support.any001`);
    pathAny001.val = "juu/daa";
    assertOK("http://localhost:8080/prefix/juu/daa", `package test.cayla.runtime.url.support.any001`);
}

shared test void testOneOrMore001() {
    pathOneOrMore001.val = "";
    assertOK("", `package test.cayla.runtime.url.support.oneormore001`);
    pathOneOrMore001.val = "juu";
    assertOK("http://localhost:8080/prefix/juu", `package test.cayla.runtime.url.support.oneormore001`);
    pathOneOrMore001.val = "juu/daa";
    assertOK("http://localhost:8080/prefix/juu/daa", `package test.cayla.runtime.url.support.oneormore001`);
}
