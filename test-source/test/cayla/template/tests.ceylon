import ceylon.test { ... }
import cayla.template { ... }

shared test void testEmpty() {
    assertEquals("<div></div>", DIV {}.string);
}

shared test void testElementContent() {
    assertEquals("<div><div></div><h1></h1></div>", DIV { DIV {}, H1 {} }.string);
}

shared test void testTextContent() {
    assertEquals("<div>foobar</div>", DIV { "foo", "bar" }.string);
}

shared test void testLazyTextContent() {
    variable String s = "a";
    value element = DIV { "``s``", () => "``s``" };
    assertEquals("<div>aa</div>", element.string);
    s = "b";
    assertEquals("<div>ab</div>", element.string);
}

shared test void testMixedContent() {
    assertEquals("<div>a<div></div>b<h1></h1>c</div>", DIV { "a", DIV {}, "b", H1 {}, "c" }.string);
}

shared test void testLazyAttribute() {
    variable String s = "foo";
    value element = A { href = () => s; "the link" };
    assertEquals("<a href=\"foo\">the link</a>", element.string);
    s = "bar";
    assertEquals("<a href=\"bar\">the link</a>", element.string);
}

shared test void testEach() {
    value element =
    UL {
        each({for (i in 0..3)
            LI {"``i``"}
        })
    };
    assertEquals("<ul><li>0</li><li>1</li><li>2</li><li>3</li></ul>", element.string);
}

shared test void testWhen() {
    variable Integer x = 0;
    value element =
    DIV {
        when(() => x).
        eval { to = 0; "abc" }.
        eval { to = 1; "def" }.
        otherwise { "ghi" }
    };
    assertEquals("<div>abc</div>", element.string);
    x = 1;
    assertEquals("<div>def</div>", element.string);
    x = 2;
    assertEquals("<div>ghi</div>", element.string);
    x = 3;
    assertEquals("<div>ghi</div>", element.string);
}

shared test void testTag() {
    DIV tag(Child* children) => DIV { id="foo"; DIV { id = "bar"; children = children; } };
    value div = tag(DIV { id = "juu"; });
    assertEquals("<div id=\"foo\"><div id=\"bar\"><div id=\"juu\"></div></div></div>", div.string);
}

shared test void testInput() {
    
    value v = INPUT { type="text"; name="name"; };
    assertEquals("<input type=\"text\" name=\"name\"></input>", v.string);
    
    
}