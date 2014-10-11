import ceylon.language { StringBuilder }

shared class Element(
    shared String name,
    shared String id,
    shared Attr className,
    shared Attr style,
    Map<String, Attr> attrs,
    variable {Child*} children) extends Node() {

    void printAttr(StringBuilder buffer, String name, Attr val) {
        String s;
        if (is String val) {
            s = val;
        }
        else if (is String() val) {
            s = val();
        }
        else {
            s = "";
        }
        if (s.size > 0) {
            buffer.append(" ");
            buffer.append(name);
            buffer.append("=\"");
            buffer.append(s);
            buffer.append("\"");
        }
    }
    
    shared actual default void render(StringBuilder buffer) {
        buffer.append("<");
        buffer.append(name);
        printAttr(buffer, "id", id);
        printAttr(buffer, "class", className);
        printAttr(buffer, "style", style);
        for (attr in attrs) {
            printAttr(buffer, attr.key, attr.item);
        }
        buffer.append(">");
        for (child in children) {
            dispatch(child, buffer);
        }
        buffer.append("</");
        buffer.append(name);
        buffer.append(">");
    }
    
}