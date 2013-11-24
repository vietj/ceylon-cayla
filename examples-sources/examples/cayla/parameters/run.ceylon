import cayla { Response, route, Controller, Application }
import cayla.template { loadSimpleTemplate, Template }

Template index = loadSimpleTemplate("web/index.html");
Template controller1 = loadSimpleTemplate("web/controller1.html");
Template controller2 = loadSimpleTemplate("web/controller2.html");

route("/")
class Index() extends Controller() {
    shared actual default Response handle() => index.ok({"c1"->Controller1("the_param"), "c2"->Controller2("the_param")});
}

route("/foo/:param")
class Controller1(shared String param) extends Controller() {
    shared actual default Response handle() => controller1.ok(
        {"index"->Index(), "c2"->Controller2(param), "param"->param});
}

route("/bar")
class Controller2(shared String param) extends Controller() {
    shared actual default Response handle() => controller2.ok(
        {"index"->Index(), "c1"->Controller1(param), "param"->param});
}


"Run the module `examples.cayla.parameters`."
shared void run() {
    Application(`package examples.cayla.parameters`).run();
}