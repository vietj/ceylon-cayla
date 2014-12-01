import ceylon.language { StringBuilder }

void dispatch(Child child, StringBuilder buffer) {
    if (is String child) {
        buffer.append(child);
    }
    else if (is String() child) {
        buffer.append(child());
    }
    else{
        child.render(buffer);
    }
}
