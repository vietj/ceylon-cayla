import vietj.promises { Promise }

object sample {
	
	route("/")
	shared class Index() extends Controller() {
		shared actual default Response handle() => ok().template("web/index.html",
		{"c1"->Controller1("the_param"), "c2"->Controller2("the_param")});
	}
	
	route("/foo/:param")
	shared class Controller1(shared String param) extends Controller() {
		shared actual default Response handle() => ok().template("web/controller1.html",
		{"index"->Index(), "c2"->Controller2(param), "param"->param});
	}
	
	route("/bar")
	shared class Controller2(shared String param) extends Controller() {
		shared actual default Response handle() => ok().template("web/controller2.html",
		{"index"->Index(), "c1"->Controller1(param), "param"->param});
	}
}

doc("Run a basic application example." )
shared void run(){
	value application = Application(sample);
	Promise<Runtime> runtime = application.start();
	runtime.always((Runtime|Exception arg) => print(arg is Runtime then "started" else "failed: ``arg.string``"));
	process.readLine();
	runtime.then_((Runtime runtime) => runtime.stop()).then_((Anything anyting) => print("stopped"));
}

