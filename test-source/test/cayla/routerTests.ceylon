import cayla.router { ... }
import ceylon.test { ... }

void routerTests() {
	testSimpleRoute();
	testComplexRoute();
}

void testComplexRoute() {
	Router root = Router();
	Router foo = root.addRoute("/foo");
	Router bar = root.addRoute("/foo/:bar");
	
	assertEquals("/", root.string);
	assertEquals("/foo", foo.string);
	assertEquals("/foo/:bar", bar.string);
	
	RouteMatch<Router>? match = root.resolve("/foo/tutu");
	if (exists match) {
		assertEquals(bar, match.target);
		assertEquals(["foo", "tutu"], match.path);
		assertEquals(LazyMap({"bar"->"tutu"}), match.params);
	} else {
		fail();
	}
	
	//
	assertNull(bar.path(LazyMap({})));
	value path = bar.path(LazyMap({"bar"->"bar_value"}));
	if (exists path) {
		assertEquals("/foo/bar_value", path[0].string);
	} else {
		fail();
	}
}

void testSimpleRoute() {
	
	Router root = Router();
	Router foo = root.addRoute("/foo");
	Router bar = root.addRoute("/foo/bar");
	Router juu = root.addRoute("/foo/juu");

	assertEquals(null, root.getIndex());

	//
	assertEquals(root, foo.parent);
	assertEquals(0, foo.getIndex());
	assertEquals(foo, root.get(0));
	
	//
	assertEquals(foo, bar.parent);
	assertEquals(0, bar.getIndex());
	assertEquals(bar, foo.get(0));
	assertEquals(juu, bar.sibling);
	
	//
	assertEquals(foo, juu.parent);
	assertEquals(1, juu.getIndex());
	assertEquals(juu, foo.get(1));
	assertEquals(null, juu.sibling);
	
	//
	RouteMatch<Router>? m1 = root.resolve("/");
	if (exists m1) {
		assertEquals(root, m1.target);
	} else {
		fail();
	}
		
	//
	RouteMatch<Router>? m2 = root.resolve("/foo");
	if (exists m2) {
		assertEquals(foo, m2.target);
	} else {
		fail();
	}
	
	//
	RouteMatch<Router>? m3 = root.resolve("/foo/bar");
	if (exists m3) {
		assertEquals(bar, m3.target);
	} else {
		fail();
	}

	//
	RouteMatch<Router>? m4 = root.resolve("/foo/juu");
	if (exists m4) {
		assertEquals(juu, m4.target);
	} else {
		fail();
	}

		//
	RouteMatch<Router>? m5 = root.resolve("/foo/whatever");
	assertNull(m5);
}
