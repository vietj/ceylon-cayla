import cayla.router { ... }
import ceylon.test { ... }
import ceylon.collection { HashMap }

shared test void testComplexRoute() {
	Router root = Router();
	Router foo = root.addRoute("/foo");
	Router bar = root.addRoute("/foo/:bar");
	
	assertEquals("/", root.string);
	assertEquals("/foo", foo.string);
	assertEquals("/foo/:bar", bar.string);
	
	{RouteMatch<Router>*} matches = root.resolve("/foo/tutu");
	if (exists match = matches.first) {
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

shared test void testRoot() {
	Router root = Router();
	value match1 = root.resolve("/");
	assertEquals({}, match1);
	Router route = root.addRoute("/");
	assertEquals(route, root);
	value matches2 = root.resolve("/");
	assert(exists match2 = matches2.first);
	assertEquals(root, match2.target);
}

shared test void testPatternRoute() {
	Router root = Router();
	Router route = root.addRoute("/:foo");
	value match1 = root.resolve("/");
	assertEquals({}, match1);
	assert(exists match2 = root.resolve("/bar").first);
	assertEquals(route, match2.target);
	assertEquals(HashMap({"foo"->"bar"}), match2.params);
}

shared test void testSimpleRoute() {
	
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
	value m1 = root.resolve("/");
	assertEquals(0, m1.size);
		
	//
	value m2 = root.resolve("/foo");
	if (exists m = m2.first) {
		assertEquals(foo, m.target);
	} else {
		fail();
	}
	
	//
	value m3 = root.resolve("/foo/bar");
	if (exists m = m3.first) {
		assertEquals(bar, m.target);
	} else {
		fail();
	}

	//
	value m4 = root.resolve("/foo/juu");
	if (exists m = m4.first) {
		assertEquals(juu, m.target);
	} else {
		fail();
	}

		//
	value m5 = root.resolve("/foo/whatever");
	assertEquals(0, m5.size);
}

shared test void testMultiMatches() {
	Router root = Router();
	Router route1 = root.addRoute("/foo");
	Router route2 = root.addRoute("/:foo");
	value match = [*root.resolve("/foo").map((RouteMatch<Router> elem) => elem.target)];
	assertEquals([route1,route2], match);
}

