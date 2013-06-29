import vietj.promises { Promise }

class MyApp() extends Application() {
	
	route "/"
	shared class Index() extends Controller() {
		shared actual default Response handle() => ok().body(
			"<html><body>
			 <h1>Application index</h1>
			 <ul>
			 <li><a href='``Controller1("the_param")``'>Controller 1 with path parameter</a></li>
			 <li><a href='``Controller2("the_param")``'>Controller 2 with query parameter</a></li>
			 </ul>
			 </body></html>");
	}

	route "/foo/:param"
	shared class Controller1(shared String param) extends Controller() {
		shared actual default Response handle() => ok().body(
			"<html><body>
			 <h1>Application controller 1 with parameter ``param``</h1>
			 <ul>
			 <li><a href='``Index()``'>Index</a></li>
			 <li><a href='``Controller2("the_param")``'>Controller 2 with query parameter</a></li>
			 </ul>
			 </body></html>");
	}
	
	route "/bar"
	shared class Controller2(shared String param) extends Controller() {
		shared actual default Response handle() => ok().body(
			"<html><body>
			 <h1>Application controller 2 with parameter ``param``</h1>
			 <ul>
			 <li><a href='``Index()``'>Index</a></li>
			 <li><a href='``Controller1("the_param")``'>Controller 1 with path parameter</a></li>
			 </ul>
			 </body></html>");
	}
}

shared void run(){
	
	MyApp app = MyApp();
	Promise<Runtime> runtime = app.start();
	runtime.always((Runtime|Exception arg) => print(arg is Runtime then "started" else "failed: ``arg.string``"));
	process.readLine();
	runtime.then_((Runtime runtime) => runtime.stop()).then_((Anything anyting) => print("stopped"));

}

