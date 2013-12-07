import cayla { Response, route, Handler, Application, ok }
import cayla.template { loadSimpleTemplate, Template }

Template(<String->Object>*) index = loadSimpleTemplate("web/index.html");
Template(<String->Object>*) controller1 = loadSimpleTemplate("web/controller1.html");
Template(<String->Object>*) controller2 = loadSimpleTemplate("web/controller2.html");

route("/")
class Index() extends Handler() {
    shared actual default Response handle() => ok {
        index(
            "c1"->Controller1("the_param"),
            "c2"->Controller2("the_param")
        );
    };
}

route("/foo/:param")
class Controller1(shared String param) extends Handler() {
    shared actual default Response handle() => ok {
        controller1(
            "index"->Index(),
            "c2"->Controller2(param),
            "param"->param
        );
    };
}

route("/bar")
class Controller2(shared String param) extends Handler() {
    shared actual default Response handle() => ok {
        controller2(
            "index"->Index(),
            "c1"->Controller1(param),
            "param"->param
        );
    };
}


"Run the module `examples.cayla.parameters`."
shared void run() {
    Application(`package examples.cayla.parameters`).run();
}