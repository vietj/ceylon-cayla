import io.cayla.web {
    route,
    Handler,
    Application,
    ok
}
import io.cayla.web.template {
    ...
}

route("/")
class Index(shared String? name = null) 
        extends Handler() {
    
    handle() => ok { index(name else "World"); };
    
    function controlGroup({Child*} children)
            => DIV { 
        className = "control-group";
        DIV { 
            className= "controls"; 
            children = children; 
        } 
    };
    
    Template index(String name) 
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
                className = "container";
                DIV { 
                    className = "hero-unit";
                    DIV { 
                        className="center";
                        H1 { () => "Hello ``name``" }
                    }
                },
                DIV { 
                    className = "offset4 span4";
                    FORM { 
                        className = "form-signin"; 
                        action = Index().string; 
                        method = "GET";
                        controlGroup { 
                            INPUT { type = "text"; name = "name"; } 
                        },
                        controlGroup {
                            BUTTON { 
                                className = "btn btn-default"; 
                                type = "submit"; 
                            },
                            "Say Hello" 
                        }
                    }
                }
            }
        }
    };
    
    String bootstrap => "//www.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap.min.css";
    
}

shared void run() => Application(`package examples.cayla.helloworld`).run();