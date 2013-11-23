import cayla { Response, route, Controller, Runtime, Application, RequestContext, ok }
import vietj.promises { Promise }
import vietj.vertx.http { HttpClientResponse, textBody }
"Run the module `examples.cayla.proxy`."

// Get some markup via the client and return it
route("/")
class ProxyController() extends Controller() {
    shared actual default Promise<Response> invoke(RequestContext context) {
        value client = context.runtime.vertx.createHttpClient(80, "portail.free.fr");
        value request = client.request("GET", "/index.html").end();
        return request.response.
                then__((HttpClientResponse response) => response.parseBody(textBody)).
                then_((String body) => ok().body(body));
    }
}

shared void run() {
    value application = Application(`package examples.cayla.proxy`);
    Promise<Runtime> runtime = application.start();
    runtime.always((Runtime|Exception arg) => print(arg is Runtime then "started" else "failed: ``arg.string``"));
    process.readLine();
    runtime.then_((Runtime runtime) => runtime.stop()).then_((Anything anyting) => print("stopped"));
}