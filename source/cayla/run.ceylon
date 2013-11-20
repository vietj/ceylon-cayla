import vietj.promises { Promise }
import vietj.vertx.http { HttpClientResponse, textBody }

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

	// Get some markup via the client and return it
	route("/proxy")
	shared class ProxyController() extends Controller() {
		shared actual default Promise<Response> invoke(RequestContext context) {
			value client = context.runtime.vertx.createHttpClient(80, "portail.free.fr");
			value request = client.request("GET", "/index.html").end();
			return request.response.
				then__((HttpClientResponse response) => response.parseBody(textBody)).
				then_((String body) => ok().body(body));
		}
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

