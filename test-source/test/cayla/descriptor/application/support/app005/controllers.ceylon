import io.cayla.web { Handler }

shared object foo {
    shared object bar {
        shared class Index() extends Handler() {
        }
    }
}

