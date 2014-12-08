import io.cayla.web { Handler }

shared object foo {
    shared object bar {
        class Index() extends Handler() {
        }
    }
}

