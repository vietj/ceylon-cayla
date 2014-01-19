import io.cayla.web {
    Response,
    route,
    Handler,
    Application,
    RequestContext,
    ok,
    error,
    Config
}
import io.cayla.web.template {
    ...
}

import ceylon.json {
    JSonObject=Object
}

import ceylon.promises {
    Promise
}
import io.vertx.ceylon.http {
    HttpClientResponse,
    jsonBody
}

Template index(String joke) 
        => HTML {
    HEAD {
        TITLE { "Hello World" },
        LINK { 
            rel = "stylesheet"; 
            href=bootstrap; 
        }
    },
    BODY { 
        style = "padding-top: 32px";
        DIV { 
            className ="container";
            DIV { 
                className =  "hero-unit";
                BLOCKQUOTE {
                    P { joke },
                    SMALL { "Chuck Norris" }
                }
            }
        }
    }
};

String bootstrap = "//www.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap.min.css";

// Get a Chuck Norris quote with Vert.x client and return it
route("/*path")
class ProxyController(shared String path) 
        extends Handler() {
    shared actual default Promise<Response> invoke(RequestContext context) {
        value client = context.runtime.vertx.createHttpClient(80, "api.icndb.com");
        value request = client.get("/jokes/random/").end();
        Response transform(JSonObject body) {
            if (is JSonObject result = body["value"], 
                is String joke = result["joke"]) {
                return ok { index(joke); };
            }
            else {
                return error { "Could not retrieve joke"; };
            }
        }
        return request.response.
                then__((HttpClientResponse response) => response.parseBody(jsonBody)).
                then_(transform);
    }
}

shared void run() => Application(`package examples.cayla.chucknorris`, Config{port = 8080;}).run();
