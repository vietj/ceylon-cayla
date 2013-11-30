import cayla { Controller, route }

route("/foo")
shared object foo {
    
    route("/bar")
    shared object bar {
        
        route("/")
        shared class Index() extends Controller() {
        }
        shared Boolean isIndex(Object o) {
            return o is Index;
        }
        shared Controller instance() {
            return Index();
        }
    }
    shared Boolean isIndex(Object o) {
        return bar.isIndex(o);
    }
    shared Controller instance() {
        return bar.instance();
    }
}

