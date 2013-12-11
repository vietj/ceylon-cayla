import cayla {
    route,
    Handler,
    Application,
    ok
}
import cayla.template {
    loadSimpleTemplate,
    Template
}

Template(<String->Object>*) index = loadSimpleTemplate("web/index.html");
Template(<String->Object>*) template1 = loadSimpleTemplate("web/template1.html");
Template(<String->Object>*) template2 = loadSimpleTemplate("web/template2.html");

route("/")
class Index()
        extends Handler() {
    handle() => ok {
        index(
            "c1"->Controller1("hello"),
            "c2"->Controller2("goodbye")
        );
    };
}

route("/foo/:param")
class Controller1(shared String param)
        extends Handler() {
    handle() => ok {
        template1(
            "index"->Index(),
            "c2"->Controller2(param),
            "param"->param
        );
    };
}

route("/bar")
class Controller2(shared String param)
        extends Handler() {
    handle() => ok {
        template2(
            "index"->Index(),
            "c1"->Controller1(param),
            "param"->param
        );
    };
}

shared void run() {
    Application(`package examples.cayla.parameters`).run();
}