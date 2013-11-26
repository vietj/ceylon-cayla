import cayla { Response, route, Controller, Application, RequestContext, ok, Config }
import vietj.promises { Promise }
import vietj.vertx.http { HttpClientResponse, textBody }
"Run the module `examples.cayla.proxy`."

// Get some markup via the client and return it - should rewrite the markup URL
route("/*path")
class ProxyController(shared String path) extends Controller() {
    shared actual default Promise<Response> invoke(RequestContext context) {
        value client = context.runtime.vertx.createHttpClient(80, "portail.free.fr");
        value request = client.request("GET", "/``path``").end();
        return request.response.
                then__((HttpClientResponse response) => response.parseBody(textBody)).
                then_((String body) => ok().body(body));
    }
}

shared void run() {
    Application(`package examples.cayla.proxy`, Config{port = 8080;}).run();
}