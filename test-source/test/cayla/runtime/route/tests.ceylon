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

shared test void testRoot001() {
	Package pkg = `package test.cayla.runtime.route.support.root001`;
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

shared test void testRoot002() {
    Package pkg = `package test.cayla.runtime.route.support.root002`;
    Application app = Application(pkg);
    value runtime = app.start().future.get(1000);
    assert(is Runtime runtime);
    try {
        Response response1 = assertRequest("http://localhost:8080/?foo=HellO");
        assertEquals(200, response1.status);
        assertEquals("text/html", response1.contentType);
        assertEquals(">HellO<", response1.contents);
        Response response2 = assertRequest("http://localhost:8080/");
        assertEquals(500, response2.status);
    } finally {
        runtime.stop();
    }
}

shared test void testRoot003() {
    Package pkg = `package test.cayla.runtime.route.support.root003`;
    Application app = Application(pkg);
    value runtime = app.start().future.get(1000);
    assert(is Runtime runtime);
    try {
        Response response1 = assertRequest("http://localhost:8080/?foo=HellO");
        assertEquals(200, response1.status);
        assertEquals("text/html", response1.contentType);
        assertEquals(">HellO<", response1.contents);
        Response response2 = assertRequest("http://localhost:8080/");
        assertEquals(200, response2.status);
        assertEquals("text/html", response2.contentType);
        assertEquals("null", response2.contents);
    } finally {
        runtime.stop();
    }
}

shared test void testRoot004() {
    Package pkg = `package test.cayla.runtime.route.support.root004`;
    Application app = Application(pkg);
    value runtime = app.start().future.get(1000);
    assert(is Runtime runtime);
    try {
        Response response1 = assertRequest("http://localhost:8080/?foo=HellO");
        assertEquals(200, response1.status);
        assertEquals("text/html", response1.contentType);
        assertEquals(">HellO<", response1.contents);
        Response response2 = assertRequest("http://localhost:8080/");
        assertEquals(200, response2.status);
        assertEquals("text/html", response2.contentType);
        assertEquals(">the_default<", response2.contents);
    } finally {
        runtime.stop();
    }
}

shared test void testRoot005() {
    Package pkg = `package test.cayla.runtime.route.support.root005`;
    Application app = Application(pkg);
    value runtime = app.start().future.get(1000);
    assert(is Runtime runtime);
    try {
        Response response1 = assertRequest("http://localhost:8080/?foo=HellO");
        assertEquals(200, response1.status);
        assertEquals("text/html", response1.contentType);
        assertEquals(">HellO<", response1.contents);
        Response response2 = assertRequest("http://localhost:8080/");
        assertEquals(200, response2.status);
        assertEquals("text/html", response2.contentType);
        assertEquals("null", response2.contents);
    } finally {
        runtime.stop();
    }
}

shared test void testSegment001() {
	Package pkg = `package test.cayla.runtime.route.support.segment001`;
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

shared test void testExpression001() {
	Package pkg = `package test.cayla.runtime.route.support.expression001`;
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

shared test void testAny001() {
    Package pkg = `package test.cayla.runtime.route.support.any001`;
    Application app = Application(pkg);
    value runtime = app.start().future.get(1000);
    assert(is Runtime runtime);
    try {
        Response response1 = assertRequest("http://localhost:8080/");
        assertEquals(200, response1.status);
        assertEquals("text/html", response1.contentType);
        assertEquals("><", response1.contents);
        Response response2 = assertRequest("http://localhost:8080/bar");
        assertEquals(200, response2.status);
        assertEquals("text/html", response2.contentType);
        assertEquals(">bar<", response2.contents);
        Response response3 = assertRequest("http://localhost:8080/bar/juu");
        assertEquals(200, response3.status);
        assertEquals("text/html", response3.contentType);
        assertEquals(">bar/juu<", response3.contents);
    } finally {
        runtime.stop();
    }
}

shared test void testOneOrMore001() {
    Package pkg = `package test.cayla.runtime.route.support.oneormore001`;
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
        Response response3 = assertRequest("http://localhost:8080/bar/juu");
        assertEquals(200, response3.status);
        assertEquals("text/html", response3.contentType);
        assertEquals(">bar/juu<", response3.contents);
    } finally {
        runtime.stop();
    }
}
