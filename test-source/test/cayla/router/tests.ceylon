import ceylon.test { ... }
import io.cayla.web.router { ... }
import ceylon.collection { HashMap }
import test.cayla { assertSameIterable }

shared test void testSegmentMount() {
    Segment segment = Segment("hello");
    assertSameIterable({}, segment.match({}));
    assertSameIterable({1}, segment.match({"hello"}));
    assertSameIterable({}, segment.match({"goodbye"}));
    assertSameIterable({1}, segment.match({"hello","goodbye"}));
}

shared test void testExpressionMount() {
    Expression expr = Expression("hello");
    assertSameIterable({}, expr.match({}));
    assertSameIterable({1}, expr.match({"hello"}));
    assertSameIterable({1}, expr.match({"goodbye"}));
    assertSameIterable({1}, expr.match({"hello","goodbye"}));
}

shared test void testAnyMount() {
    Any expr = Any("hello");
    assertSameIterable({0}, expr.match({}));
    assertSameIterable({1,0}, expr.match({"hello"}));
    assertSameIterable({1,0}, expr.match({"goodbye"}));
    assertSameIterable({2,1,0}, expr.match({"hello","goodbye"}));
    assertSameIterable({3,2,1,0}, expr.match({"hello","goodbye","hey"}));
}

shared test void testOneOrMoreMount() {
    OneOrMore expr = OneOrMore("hello");
    assertSameIterable({}, expr.match({}));
    assertSameIterable({1}, expr.match({"hello"}));
    assertSameIterable({1}, expr.match({"goodbye"}));
    assertSameIterable({2,1}, expr.match({"hello","goodbye"}));
    assertSameIterable({3,2,1}, expr.match({"hello","goodbye","hey"}));
}

shared test void testMountSegment() {
    Router root = Router();
    Router foo = root.mount("/foo");
    assert(exists parent = foo.parent);
    assertEquals(root, parent[1]);
    value mount = parent[0];
    assert(is Segment mount);
    assertEquals("foo", mount.string);
    assertEquals("/foo", foo.string);
    assertEquals(foo, root[0]);
}

shared test void testMountExpression() {
    Router root = Router();
    Router foo = root.mount("/:foo");
    assert(exists parent = foo.parent);
    assertEquals(root, parent[1]);
    value mount = parent[0];
    assert(is Expression mount);
    assertEquals(":foo", mount.string);
    assertEquals("/:foo", foo.string);
    assertEquals(foo, root[0]);
}

shared void testMountOnSegment() {
    Router root = Router();
    Router foo = root.mount("/foo");
    Router bar = root.mount("/foo/bar");
    assert(exists fooParent = foo.parent);
    assertEquals(root, fooParent[1]);
    value fooMount = fooParent[0];
    assert(is Segment fooMount);
    assertEquals("foo", fooMount.string);
    assertEquals("/foo", foo.string);
    assertEquals(foo, root[0]);
    assert(exists barParent = bar.parent);
    assertEquals(foo, barParent[1]);
    value barMount = barParent[0];
    assert(is Segment barMount);
    assertEquals("bar", barMount.string);
    assertEquals("/foo/bar", bar.string);
    assertEquals(bar, foo[0]);
}

shared void testMountOnExpression() {
    Router root = Router();
    Router foo = root.mount("/:foo");
    Router bar = root.mount("/:foo/bar");
    assert(exists fooParent = foo.parent);
    assertEquals(root, fooParent[1]);
    value fooMount = fooParent[0];
    assert(is Segment fooMount);
    assertEquals(":foo", fooMount.string);
    assertEquals("/:foo", foo.string);
    assertEquals(foo, root[0]);
    assert(exists barParent = bar.parent);
    assertEquals(foo, barParent[1]);
    value barMount = barParent[0];
    assert(is Segment barMount);
    assertEquals("bar", barMount.string);
    assertEquals("/:foo/bar", bar.string);
    assertEquals(bar, foo[0]);
}

shared test void testResolveSegment() {
    Router root = Router();
    Router foo = root.mount("/foo");
    assertEquals(null, root.match("/"));
    assert(exists m = root.match("/foo"));
    assertEquals(foo, m.target);
    assertEquals(HashMap(), m.params);
    assertEquals(["foo"], m.path);
    assertEquals(null, root.match("/bar"));
    assertEquals(null, root.match("/foo/bar"));
}

shared test void testResolveExpression() {
    Router root = Router();
    Router foo = root.mount("/:foo");
    assertEquals(null, root.match("/"));
    assert(exists m1 = root.match("/foo"));
    assertEquals(foo, m1.target);
    assertEquals(HashMap{"foo"->"foo"}, m1.params);
    assertEquals(["foo"], m1.path);
    assert(exists m2 = root.match("/bar"));
    assertEquals(foo, m2.target);
    assertEquals(HashMap{"foo"->"bar"}, m2.params);
    assertEquals(["bar"], m2.path);
    assertEquals(null, root.match("/foo/bar"));
}

shared test void testResolveAny() {
    Router root = Router();
    Router foo = root.mount("/*foo");
    assert(exists m1 = root.match("/"));
    assertEquals(foo, m1.target);
    assertEquals(HashMap{"foo"->""}, m1.params);
    assertEquals([], m1.path);
    assert(exists m2 = root.match("/foo"));
    assertEquals(foo, m2.target);
    assertEquals(HashMap{"foo"->"foo"}, m2.params);
    assertEquals(["foo"], m2.path);
    assert(exists m3 = root.match("/bar"));
    assertEquals(foo, m3.target);
    assertEquals(HashMap{"foo"->"bar"}, m3.params);
    assertEquals(["bar"], m3.path);
    assert(exists m4 = root.match("/foo/bar"));
    assertEquals(foo, m4.target);
    assertEquals(HashMap{"foo"->"foo/bar"}, m4.params);
    assertEquals(["foo", "bar"], m4.path);
}

shared test void testResolveOneOrMore() {
    Router root = Router();
    Router foo = root.mount("/+foo");
    assertEquals(null, root.match("/"));
    assert(exists m1 = root.match("/foo"));
    assertEquals(foo, m1.target);
    assertEquals(HashMap{"foo"->"foo"}, m1.params);
    assertEquals(["foo"], m1.path);
    assert(exists m2 = root.match("/bar"));
    assertEquals(foo, m2.target);
    assertEquals(HashMap{"foo"->"bar"}, m2.params);
    assertEquals(["bar"], m2.path);
    assert(exists m3 = root.match("/foo/bar"));
    assertEquals(foo, m3.target);
    assertEquals(HashMap{"foo"->"foo/bar"}, m3.params);
    assertEquals(["foo","bar"], m3.path);
}

shared test void testResolve() {
    Router root = Router();
    Router juu = root.mount("/foo/:bar/*juu");
    assertEquals(null, root.match("/"));
    assertEquals(null, root.match("/foo"));
    assertEquals(null, root.match("/bar"));
    assert(exists m1 = root.match("/foo/bar"));
    assertEquals(juu, m1.target);
    assertEquals(HashMap{"juu"->"","bar"->"bar"}, m1.params);
    assertEquals(["foo","bar"], m1.path);
    assert(exists m2 = root.match("/foo/bar/juu"));
    assertEquals(juu, m2.target);
    assertEquals(HashMap{"juu"->"juu","bar"->"bar"}, m2.params);
    assertEquals(["foo","bar","juu"], m2.path);
    assert(exists m3 = root.match("/foo/bar/juu/daa"));
    assertEquals(juu, m3.target);
    assertEquals(HashMap{"juu"->"juu/daa","bar"->"bar"}, m3.params);
    assertEquals(["foo","bar","juu","daa"], m3.path);
}

shared test void testResolveSeveral() {
    Router root = Router();
    Router juu = root.mount("/foo/*bar/*juu");
    value matches = [*root.matches("/foo/bar/juu/daa")];
    assertEquals(4, matches.size);
    assert(exists m1 = matches[0]);
    assertEquals(juu, m1.target);
    assertEquals(HashMap{"bar"->"bar/juu/daa","juu"->""}, m1.params);
    assert(exists m2 = matches[1]);
    assertEquals(juu, m2.target);
    assertEquals(HashMap{"bar"->"bar/juu","juu"->"daa"}, m2.params);
    assert(exists m3 = matches[2]);
    assertEquals(juu, m3.target);
    assertEquals(HashMap{"bar"->"bar","juu"->"juu/daa"}, m3.params);
    assert(exists m4 = matches[3]);
    assertEquals(juu, m4.target);
    assertEquals(HashMap{"bar"->"","juu"->"bar/juu/daa"}, m4.params);
}

shared test void testPathSegment() {
    Router foo = Router().mount("/foo");
    assert(exists found1 = foo.path());
    assertEquals(["foo"], [*found1[0]]);
    assertEquals(HashMap{}, HashMap{entries = found1[1]; });
    assert(exists found2 = foo.path({"foo"->"foo_value"}));
    assertEquals(["foo"], [*found2[0]]);
    assertEquals(HashMap{"foo"->"foo_value"}, HashMap{ entries = found2[1]; });
    Router fooBar = Router().mount("/foo/bar");
    assert(exists found3 = fooBar.path());
    assertEquals(["foo","bar"], [*found3[0]]);
    assertEquals(HashMap{}, HashMap{ entries = found3[1]; });
    assert(exists found4 = fooBar.path({"foo"->"foo_value"}));
    assertEquals(["foo","bar"], [*found4[0]]);
    assertEquals(HashMap{"foo"->"foo_value"}, HashMap{ entries = found4[1]; });
}

shared test void testPathExpression() {
    Router foo = Router().mount("/:foo");
    assert(exists found1 = foo.path({"foo"->"foo_value"}));
    assertEquals(["foo_value"], [*found1[0]]);
    assertEquals(HashMap{}, HashMap{ entries = found1[1]; });
    assert(exists found2 = foo.path({"foo"->"foo_value","bar"->"bar_value"}));
    assertEquals(["foo_value"], [*found2[0]]);
    assertEquals(HashMap{"bar"->"bar_value"}, HashMap{ entries = found2[1]; });
}

shared test void testPathAny() {
    Router foo = Router().mount("/*foo");
    assert(exists found1 = foo.path({"foo"->""}));
    assertEquals([], [*found1[0]]);
    assertEquals(HashMap{}, HashMap{ entries = found1[1]; });
    assert(exists found2 = foo.path({"foo"->"foo_value"}));
    assertEquals(["foo_value"], [*found2[0]]);
    assertEquals(HashMap{}, HashMap{ entries = found2[1]; });
    assert(exists found3 = foo.path({"foo"->"foo_value/bar_value"}));
    assertEquals(["foo_value","bar_value"], [*found3[0]]);
    assertEquals(HashMap{}, HashMap{ entries = found3[1]; });
}

shared test void testPathOneOrMore() {
    Router foo = Router().mount("/+foo");
    assertEquals(null, foo.path({"foo"->""}));
    assert(exists found1 = foo.path({"foo"->"foo_value"}));
    assertEquals(["foo_value"], [*found1[0]]);
    assertEquals(HashMap{}, HashMap{ entries = found1[1]; });
    assert(exists found2 = foo.path({"foo"->"foo_value/bar_value"}));
    assertEquals(["foo_value","bar_value"], [*found2[0]]);
    assertEquals(HashMap{}, HashMap{ entries = found2[1]; });
}
