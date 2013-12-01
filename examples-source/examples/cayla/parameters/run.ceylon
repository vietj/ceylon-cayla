import cayla { Response, route, Controller, Application }
import cayla.template { loadSimpleTemplate, Template }

Template(<String->Object>*) index = loadSimpleTemplate("web/index.html");
Template(<String->Object>*) controller1 = loadSimpleTemplate("web/controller1.html");
Template(<String->Object>*) controller2 = loadSimpleTemplate("web/controller2.html");

route("/")
class Index() extends Controller() {
    shared actual default Response handle() => index(
            "c1"->Controller1("the_param"),
            "c2"->Controller2("the_param")
        ).ok();
}

route("/foo/:param")
class Controller1(shared String param) extends Controller() {
    shared actual default Response handle() => controller1(
            "index"->Index(),
            "c2"->Controller2(param),
            "param"->param
        ).ok();
}

route("/bar")
class Controller2(shared String param) extends Controller() {
    shared actual default Response handle() => controller2(
            "index"->Index(),
            "c1"->Controller1(param),
            "param"->param
        ).ok();
}


"Run the module `examples.cayla.parameters`."
shared void run() {
    Application(`package examples.cayla.parameters`).run();
}