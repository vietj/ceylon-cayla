import io.cayla.web { Handler, route }

route("/foo")
shared object foo {
    
    route("/bar")
    shared object bar {
        
        route("/")
        shared class Index() extends Handler() {
        }
        shared Boolean isIndex(Object o) {
            return o is Index;
        }
        shared Handler instance() {
            return Index();
        }
    }
    shared Boolean isIndex(Object o) {
        return bar.isIndex(o);
    }
    shared Handler instance() {
        return bar.instance();
    }
}

