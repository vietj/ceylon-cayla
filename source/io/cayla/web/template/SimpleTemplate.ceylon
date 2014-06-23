import ceylon.file { File, current, Resource }

shared Template(<String->Object>*) loadSimpleTemplate(String|File file) {
    Resource r;
    switch (file)
    case (is String) {
        r = current.childPath(file).resource;
    }
    case (is File) {
        r = file;
    }
    if (is File f = r) {
        value sb = StringBuilder();
        value reader = f.Reader();
        try {
            while (exists l = reader.readLine()) {
                sb.append(l);
                sb.appendNewline();
            }
            value chars = sb.string;
            Template foo(<String->Object>* values) {
                object binding satisfies Template {
                    shared actual void render(StringBuilder to) {
                        // Not efficient at all! but well for now it's ok
                        variable String s = chars;
                        for (k->v in values) {
                            s = s.replace("${``k``}", v.string);
                        }
                        to.append(s);
                    }
                }
                return binding;
            }
            return foo;
        } finally {
            // Shouldn't be null the default value in the reader API ?
            reader.destroy(null);
        }
    } else {
        throw Exception("TEMPLATE ``file`` NOT FOUND");
    }
}
