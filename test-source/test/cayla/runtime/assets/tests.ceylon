import ceylon.test { ... }
import ceylon.language.meta.declaration { Package }
import io.cayla.web { Application }
import ceylon.net.http.client { Response, Request }
import ceylon.net.uri { Uri, parse }
import test.cayla { assertResolve }
import io.cayla.web.asset {
  pathValidator
}

shared Response assertRequest(String uri, {<String->{String*}>*} headers = {}) {
    Uri tmp = parse(uri);
    Request req = Request(tmp);
    for (header in headers) {
        req.setHeader(header.key, *header.item);
    }
    return req.execute();
}

shared test void sendAsset() {
	Package pkg = `package test.cayla.runtime.assets.support.app001`;
	Application app = Application(pkg);
	value runtime = assertResolve(app.start());
	try {
		Response response = assertRequest("http://localhost:8080/assets/build.xml");
		assertEquals(response.status, 200);
		assertEquals("application/xml", response.contentType);
		assertTrue(response.contents.contains("<project name=\"cayla\" default=\"run\">"), "Wrong response content ``response.contents``");
	} finally {
		assertResolve(runtime.stop());
	}
}

shared test void missingAsset() {
  Package pkg = `package test.cayla.runtime.assets.support.app001`;
  Application app = Application(pkg);
  value runtime = assertResolve(app.start());
  try {
    Response response = assertRequest("http://localhost:8080/assets/doesnotexists.txt");
    assertEquals(response.status, 404);
  } finally {
    assertResolve(runtime.stop());
  }
}

shared test void resolveAssetUrl() {
  // Todo
}

shared test void forbiddenPath() {
  Package pkg = `package test.cayla.runtime.assets.support.app001`;
  Application app = Application(pkg);
  value runtime = assertResolve(app.start());
  try {
    Response response = assertRequest("http://localhost:8080/assets/foo/../something.txt");
    assertEquals(response.status, 403);
  } finally {
    assertResolve(runtime.stop());
  }
}

shared test void testPathValidator() {

  assertTrue(pathValidator(""));
  assertTrue(pathValidator("."));
  assertTrue(pathValidator("a"));
  assertFalse(pathValidator(".."));
  assertTrue(pathValidator("..a"));
  assertTrue(pathValidator("a.."));
  
  assertTrue(pathValidator("a/"));
  assertTrue(pathValidator("a/."));
  assertTrue(pathValidator("a/a"));
  assertFalse(pathValidator("a/.."));
  assertTrue(pathValidator("a/..a"));
  assertTrue(pathValidator("a/a.."));
  
  assertTrue(pathValidator("/a"));
  assertTrue(pathValidator("./a"));
  assertTrue(pathValidator("a/a"));
  assertFalse(pathValidator("../a"));
  assertTrue(pathValidator("..a/a"));
  assertTrue(pathValidator("a../a"));
  
}
