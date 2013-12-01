shared class DIV({Child*} children, String id = "", Attr className = "", Attr style = "")
        extends Element("div", id, className, style, emptyMap, children) {}

shared class UL({Child*} children, String id = "", Attr className = "", Attr style = "")
        extends Element("ul", id, className, style, emptyMap, children) {}

shared class LI({Child*} children, String id = "", Attr className = "", Attr style = "")
        extends Element("li", id, className, style, emptyMap, children) {}

shared class A({Child*} children, Attr href, String id = "", Attr className = "", Attr style = "")
        extends Element("a", id, className, style, LazyMap({"href"->href}), children) {}

shared class HTML({Child*} children, String id = "", Attr className = "", Attr style = "")
        extends Element("html", id, className, style, emptyMap, children) {
    shared actual default void render(StringBuilder to) {
        to.append("<!DOCTYPE html>");
        super.render(to);
    }
}

shared class HEAD({Child*} children, String id = "", Attr className = "", Attr style = "")
        extends Element("head", id, className, style, emptyMap, children) {}

shared class TITLE({Child*} children, String id = "", Attr className = "", Attr style = "")
        extends Element("title", id, className, style, emptyMap, children) {}

shared class LINK({Child*} children, Attr rel, Attr href, String id = "", Attr className = "", Attr style = "")
        extends Element("link", id, className, style, LazyMap({"rel"->rel,"href"->href}), children) {}

shared class BODY({Child*} children, String id = "", Attr className = "", Attr style = "")
        extends Element("body", id, className, style, emptyMap, children) {}

shared class H1({Child*} children, String id = "", Attr className = "", Attr style = "")
        extends Element("h1", id, className, style, emptyMap, children) {}

shared class FORM({Child*} children, Attr action, Attr method = "POST", String id = "", Attr className = "", Attr style = "")
        extends Element("form", id, className, style, LazyMap({"action"->action,"method"->method}), children) {}

shared class INPUT({Child*} children, Attr type, Attr name, String id = "", Attr className = "", Attr style = "")
        extends Element("input", id, className, style, LazyMap({"type"->type,"name"->name}), children) {}

shared class BUTTON({Child*} children, Attr type = "submit", String id = "", Attr className = "", Attr style = "")
        extends Element("button", id, className, style, LazyMap({"type"->type}), children) {}
