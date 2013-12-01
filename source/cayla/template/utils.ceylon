void dispatch(Child child, StringBuilder buffer) {
    if (is String child) {
        buffer.append(child);
    }
    if (is String() child) {
        buffer.append(child());
    }
    if (is Node child) {
        child.render(buffer);
    }
}
