import cayla { Controller }

shared object foo {
    shared object bar {
        shared class Index() extends Controller() {
        }
        shared Boolean isIndex(Object o) {
            return o is Index;
        }
    }
    shared Boolean isIndex(Object o) {
        return bar.isIndex(o);
    }
}

