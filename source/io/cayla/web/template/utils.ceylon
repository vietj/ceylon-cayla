import ceylon.language { StringBuilder }

void dispatch(Child child, StringBuilder buffer) {
    if (is String child) {
        buffer.append(child);
    }
    else if (is String() child) {
        buffer.append(child());
    }
    else if (is Node child) {
        child.render(buffer);
    }
    else {
        print("not handled ``child``");
    }
}
