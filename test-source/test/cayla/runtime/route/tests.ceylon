import ceylon.test { ... }
import ceylon.language.meta.declaration { Package }
import io.cayla.web { Application, Runtime }
import ceylon.net.http.client { Response, Request }
import ceylon.net.uri { Uri, parse, Parameter }
import ceylon.net.http { Method, get, post }
import test.cayla {
    assertResolve
}

shared Response assertGet(String uri, {<String->{String*}>*} headers = {}) {
    return prepareRequest(get, uri, headers).execute();
}

shared Response assertPost(String uri, {<String->{String*}>*} headers = {}, {<String->{String*}>*} form = {}) {
    value req = prepareRequest(post, uri, headers);
    for (param in form) {
        for (val in param.item) {
            req.setParameter(Parameter(param.key, val));
        }
    }
    return req.execute();
}

shared Request prepareRequest(Method method, String uri, {<String->{String*}>*} headers = {}, {<String->{String*}>*} form = {}) {
    Uri tmp = parse(uri);
    Request req = Request(tmp, method);
    for (header in headers) {
        req.setHeader(header.key, *header.item);
    }
    return req;
}

shared test void testRoot001() {
	Package pkg = `package test.cayla.runtime.route.support.root001`;
	Application app = Application(pkg);
	value runtime = app.start().future.get(1000);
	assert(is Runtime runtime);
	try {
		Response response = assertGet("http://localhost:8080/");
		assertEquals(200, response.status);
		assertEquals("text/html", response.contentType);
		assertEquals("hello", response.contents);
	} finally {
		assertResolve(runtime.stop());
	}
}

shared test void testRoot002() {
    Package pkg = `package test.cayla.runtime.route.support.root002`;
    Application app = Application(pkg);
    value runtime = app.start().future.get(1000);
    assert(is Runtime runtime);
    try {
        
        // Get
        Response response1 = assertGet("http://localhost:8080/?foo=HellO");
        assertEquals(200, response1.status);
        assertEquals("text/html", response1.contentType);
        assertEquals(">HellO<", response1.contents);
        
        // Post
        Response response2 = assertPost {
            uri = "http://localhost:8080/";
            form = { "foo"->["HellO"] };
        };
        assertEquals(200, response2.status);
        assertEquals("text/html", response2.contentType);
        assertEquals(">HellO<", response2.contents);
        
        // Nothing
        Response response3 = assertGet("http://localhost:8080/");
        assertEquals(500, response3.status);
    } finally {
      assertResolve(runtime.stop());
    }
}

shared test void testRoot003() {
    Package pkg = `package test.cayla.runtime.route.support.root003`;
    Application app = Application(pkg);
    value runtime = app.start().future.get(1000);
    assert(is Runtime runtime);
    try {
        Response response1 = assertGet("http://localhost:8080/?foo=HellO");
        assertEquals(200, response1.status);
        assertEquals("text/html", response1.contentType);
        assertEquals(">HellO<", response1.contents);
        Response response2 = assertGet("http://localhost:8080/");
        assertEquals(200, response2.status);
        assertEquals("text/html", response2.contentType);
        assertEquals("null", response2.contents);
    } finally {
      assertResolve(runtime.stop());
    }
}

shared test void testRoot004() {
    Package pkg = `package test.cayla.runtime.route.support.root004`;
    Application app = Application(pkg);
    value runtime = app.start().future.get(1000);
    assert(is Runtime runtime);
    try {
        Response response1 = assertGet("http://localhost:8080/?foo=HellO");
        assertEquals(200, response1.status);
        assertEquals("text/html", response1.contentType);
        assertEquals(">HellO<", response1.contents);
        Response response2 = assertGet("http://localhost:8080/");
        assertEquals(200, response2.status);
        assertEquals("text/html", response2.contentType);
        assertEquals(">the_default<", response2.contents);
    } finally {
      assertResolve(runtime.stop());
    }
}

shared test void testRoot005() {
    Package pkg = `package test.cayla.runtime.route.support.root005`;
    Application app = Application(pkg);
    value runtime = app.start().future.get(1000);
    assert(is Runtime runtime);
    try {
        Response response1 = assertGet("http://localhost:8080/?foo=HellO");
        assertEquals(200, response1.status);
        assertEquals("text/html", response1.contentType);
        assertEquals(">HellO<", response1.contents);
        Response response2 = assertGet("http://localhost:8080/");
        assertEquals(200, response2.status);
        assertEquals("text/html", response2.contentType);
        assertEquals("null", response2.contents);
    } finally {
      assertResolve(runtime.stop());
    }
}

shared test void testSegment001() {
	Package pkg = `package test.cayla.runtime.route.support.segment001`;
	Application app = Application(pkg);
	value runtime = app.start().future.get(1000);
	assert(is Runtime runtime);
	try {
		Response response1 = assertGet("http://localhost:8080/");
		assertEquals(404, response1.status);
		Response response2 = assertGet("http://localhost:8080/foo");
		assertEquals(200, response2.status);
		assertEquals("text/html", response2.contentType);
		assertEquals("foo", response2.contents);
	} finally {
		assertResolve(runtime.stop());
	}
}

shared test void testExpression001() {
	Package pkg = `package test.cayla.runtime.route.support.expression001`;
	Application app = Application(pkg);
	value runtime = app.start().future.get(1000);
	assert(is Runtime runtime);
	try {
		Response response1 = assertGet("http://localhost:8080/");
		assertEquals(404, response1.status);
		Response response2 = assertGet("http://localhost:8080/bar");
		assertEquals(200, response2.status);
		assertEquals("text/html", response2.contentType);
		assertEquals(">bar<", response2.contents);
	} finally {
		assertResolve(runtime.stop());
	}
}

shared test void testAny001() {
    Package pkg = `package test.cayla.runtime.route.support.any001`;
    Application app = Application(pkg);
    value runtime = app.start().future.get(1000);
    assert(is Runtime runtime);
    try {
        Response response1 = assertGet("http://localhost:8080/");
        assertEquals(200, response1.status);
        assertEquals("text/html", response1.contentType);
        assertEquals("><", response1.contents);
        Response response2 = assertGet("http://localhost:8080/bar");
        assertEquals(200, response2.status);
        assertEquals("text/html", response2.contentType);
        assertEquals(">bar<", response2.contents);
        Response response3 = assertGet("http://localhost:8080/bar/juu");
        assertEquals(200, response3.status);
        assertEquals("text/html", response3.contentType);
        assertEquals(">bar/juu<", response3.contents);
    } finally {
      assertResolve(runtime.stop());
    }
}

shared test void testOneOrMore001() {
    Package pkg = `package test.cayla.runtime.route.support.oneormore001`;
    Application app = Application(pkg);
    value runtime = app.start().future.get(1000);
    assert(is Runtime runtime);
    try {
        Response response1 = assertGet("http://localhost:8080/");
        assertEquals(404, response1.status);
        Response response2 = assertGet("http://localhost:8080/bar");
        assertEquals(200, response2.status);
        assertEquals("text/html", response2.contentType);
        assertEquals(">bar<", response2.contents);
        Response response3 = assertGet("http://localhost:8080/bar/juu");
        assertEquals(200, response3.status);
        assertEquals("text/html", response3.contentType);
        assertEquals(">bar/juu<", response3.contents);
    } finally {
      assertResolve(runtime.stop());
    }
}
