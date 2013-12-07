import cayla { Response, route, Controller, Application, RequestContext, ok, error, Config }
import vietj.promises { Promise }
import vietj.vertx.http { HttpClientResponse, jsonBody }
import ceylon.json { JSonObject=Object }
import cayla.template { ... }
"Run the module `examples.cayla.proxy`."

Template index(String joke) =>
    HTML {
      HEAD {
        TITLE { "Hello World" },
        LINK { rel = "stylesheet"; href="//www.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap.min.css"; }
      },
      BODY { style = "padding-top: 32px";
        DIV { className ="container";
          DIV { className =  "hero-unit";
            BLOCKQUOTE {
              P { joke },
              SMALL { "Chuck Norris" }
            }
          }
        }
      }
    };

// Get a Chuck Norris quote with Vert.x client and return it
route("/*path")
class ProxyController(shared String path) extends Controller() {
    shared actual default Promise<Response> invoke(RequestContext context) {
        value client = context.runtime.vertx.createHttpClient(80, "api.icndb.com");
        value request = client.request("GET", "/jokes/random/").end();
        Response transform(JSonObject body) {
            if (is JSonObject result = body["value"], is String joke = result["joke"]) {
                return ok { index(joke); };
            } else {
                return error { "Could not retrieve joke"; };
            }
        }
        return request.response.
                then__((HttpClientResponse response) => response.parseBody(jsonBody)).
                then_(transform);
    }
}

shared void run() {
    Application(`package examples.cayla.chucknorris`, Config{port = 8080;}).run();
}