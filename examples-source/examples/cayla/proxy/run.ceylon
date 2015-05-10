import io.cayla.web {
    Response,
    route,
    Handler,
    Application,
    RequestContext,
    ok,
    Config
}

import ceylon.promise {
    Promise
}
import io.vertx.ceylon.core.http {
    HttpClientResponse,
    textBody
}

// Get some markup via the client and return it - should rewrite the markup URL
route("/*path")
class ProxyController(shared String path) extends Handler() {
    shared actual default Promise<Response> invoke(RequestContext context) {
        value client = context.runtime.vertx.createHttpClient(80, "portail.free.fr");
        value request = client.get("/``path``").end();
        return request.response.
                flatMap<String>((HttpClientResponse response) => response.parseBody(textBody)).
                map((String body) => ok { body; });
    }
}

shared void run() {
    Application(`package examples.cayla.proxy`, Config{port = 8080;}).run();
}