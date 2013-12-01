import cayla { Response, route, Controller, Application, ok }
import cayla.template { ... }

"Run the module `examples.cayla.helloworld`."

route("/")
class Index(shared String? name = null) extends Controller() {

    DIV controlGroup(Child* children) =>
    DIV { className = "control-group";
     DIV { className= "controls"; children = children; } };

    Template index(String name) =>
    HTML {
      HEAD {
        TITLE { "Hello World" },
        LINK { rel = "stylesheet"; href="//www.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap.min.css"; }
      },
      BODY { style = "padding-top: 32px";
        DIV { className ="container";
          DIV { className =  "hero-unit";
            DIV { className="center";
              H1 { () => "Hello ``name``" }
            }
          },
          DIV { className = "offset4 span4";
            FORM { className = "form-signin"; action = Index().string; method = "GET";
              controlGroup(INPUT { type = "text"; name = "name"; }),
              controlGroup(BUTTON { className = "btn btn-default"; type = "submit";
                    "Say Hello" })
            }
          }
        }
      }
    };

	shared actual default Response handle() {
		String s;
		if (exists name) {
			s = name;
		} else {
			s = "World";
		}
        return index(s).ok(); 
    }
}

shared void run() {
    Application(`package examples.cayla.helloworld`).run();
}