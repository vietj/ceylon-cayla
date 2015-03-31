"""# The Cayla Web Framework
   
   Cayla makes easy creating web application with Ceylon.
   
   ## Creating a simple application in seconds
   
   ### Import the Cayla module
   
       module my.app "1.0.0" {
         import io.cayla.web "0.3.0";
       }
   
   ### Write the controller
   
       import io.cayla.web { ... }

       object controller {
         route("/")
         shared class Index() extends Handler() {
           Response handle() => ok {
             "Hello World";
           };
         }
       }
 
       shared void run() {
         value application = Application(controller);
         application.run();
       }
   
   ### Build and run!
   
       > ceylon compile my.app
       ...
       > ceylon run my.app/1.0
       started
   
   ## Application
   
   Applications are create via the [[Application]] objects that takes as argument a Ceylon declaration or an object that
   is scanned to discover the controllers:
   
   ### Package applications
   
       Application(`package my.controllers`)
   
   ### Object applications

       Application(controllers)
   
   ### Application life cycle
   
   Application can be started with [[Application.run]] or [[Application.start]]:
   
   - `run` run the application and blocks until the current process reads a line (like enter keystroke).
   - `start` starts the application asynchronously and returns a `Promise<Runtime>` providing a fine grained control over
     the application life cycle.
   
   ### Application configuration
   
   Configuration is handled by the [[Config]] class. By default the appliation is bound on the 8080 port
   and on all available interfaces. Explicit config can be provided when the application is created:
   
       Application(`package my.controllers`, Config{port = 80;});

   ## Controllers 
   
   A controller is a set of handlers, each handler extends the [[Handler]] interface, they can declare parameters which shall declares the 
   `String` type, be shared and immutable. Such parameters are mapped to*query* or *path*  request parameters.
   
   ### Query parameters
   
       route("/greeter")
       shared class Greeter(shared String name) extends Handler() {
         Response handle() => ok {
           "Hello ``name``";
         };
       }
   
   ### Path parameters
   
       route("/greeter/:name")
       shared class Greeter(shared String name) extends Handler() {
         Response handle() => ok {
           "Hello ``name``";
         };
       }
   
   Path parameters can match 
   
   * a single path segment (i.e that does not contain any `/` chars) declared with the `:` prefix like `:name`
   * zero or more segments `*` prefix like `*name`
   * one or more segments `+` prefix like `+name`
   
   ### Controller handlers URL
   
   Controller handlers can be addressed using the redefined [[Handler.string]] method. In an handler the expression
   `Greeter("Cayla")` will produce the *http://localhost:8080/greeter?name=Cayla* or the 
   *http://localhost:8080/greeter/Cayla* URL.
   
   ### Routing
   
   Routing is declared with the [[route]] annotation. Valid handlers must have this annotation.
   
       route("/")
       shared class Index() extends Controller() { ... }
   
   Objects wrapping handlers can optionally be annotated with the [[route]] annotation:
   
       route("/product")
       object productController {
         route("/")
         shared class Index() extends Controller() { ... }
         route("/cars")
         shared class Cars() extends Controller() { ... }
       }
   
   ## Controller handler logic
   
   During an invocation Cayla dispatches the request to the [[Handler.handle]] method. This method should implement
   the controller handler behavior.
   
   It is also possible to override the [[Handler.invoke]] method instead that provides access to the [[RequestContext]]
   class that exposes Cayla objects.
   
   Both methods returns a [[Response]] object that is sent to the client via Vert.x
   
   ## Responses
   
   The [[Response]] class is the base response, the [[Status]] class extends the response class to define the http status
   and the [[Body]] class extends the [[Status]] with a response body.
   
   Creating responses is usually done via the fluent API and the top level functions such as [[ok]], [[notFound]] or
   [[error]].
   
       return notFound().body("Not found!!!!");
   
   ## Http methods
   
   By default an handler is bound to a route for all Http methods. This can be restricted by using annotations like
   [[get]], [[post]], [[head]], [[put]], etc...

       get route("/greeter")
       shared class Greeter(shared String name) extends Handler() {
         Response handle() => ok().body("Hello ``name``");
       }
   
   ## Templating
   
   Cayla provides an extensible template engine build on top of Ceylon language constructs.
   
       HTML {
         BODY {
           H1 { "Hello World" }
         }
       }

   ### Elements
   
   The engine provides a set of out of the box elements such as HTML, BODY, DIV, etc... Elements can have
   attributes and content.
   
       A { href="http://localhost:8080/home"; "Home" }

   String can also be produced with `String()` arguments (function) that provides a _lazy_ evaluation of the 
   value:
   
       A { href= ()=>url; ()=>name }
   
   The `()=>url` and `()=>name` constructs are used to defer the evaluation until the template is rendered.
   
   ### Aliases
   
   The template engine defines two important alias
   - `shared alias Child => String|String()|Node`
   - `shared alias Attr => String|String()`
   
   Those aliases are used by the engine declarations and it is best to keep them in mind when using the 
   engine.
      
   ### Tags
   
   The engine provides a set of useful tags for creating dynamic templates
   
   #### Each tag
   
   The each tag provides iteration over Ceylon iterables, design for working with Ceylon comprehensions.
   
       UL {
         each({for (i in 0..3) LI { "The item ``i`` } })
       }
   
   #### When tag
   
   The when tag provides conditional dispatch:
   
       DIV {
         when(() => x).
         eval { to = 0; "zero" }.
         eval { to = 1; "one" }.
         otherwise { "too large" }.
       }
   
   ### Usage patterns
   
   Since the engine is based on Ceylon syntax, there are a few useful constructs naturally possible for using
   the engine in a web application.
   
   #### Parameterized template
   
       Template index(String title) =>
           HTML {
             HEAD {
               TITLE { title }  
             }
           };
   
       class Controller1(shared String param) extends Controller() {
         Response handle() => ok {
           index(param);
         };
       }
   
   #### Encapsulate and reuse
   
   Template fragment can be encapsulated
   
       DIV controlGroup(Child* children) =>
           DIV { className = "control-group";
             DIV { className= "controls"; children = children; }
           };
   
   and can then be reused easily
   
       value form = FORM { className = "form-signin"; action = "http://localhost:8080/";
                      controlGroup(INPUT { type = "text"; name = "name"; }),
                      controlGroup(BUTTON { className = "btn btn-default"; type = "submit"; "Say Hello" })
                    }
   
   #### Mix with controller handler URLs
   
   Handlers can be used for creating safe urls (i.e generated by Cayla), such syntax can be used with
   lazy evaluation:
   
       A { href= ()=>Product("cars"); "Cars" }
   
   #### Extensible
   
   The engine is extensible, you can easily extends the engine with your own elements and tags.
  """
module io.cayla.web "0.3.0.stef" {

	shared import java.base "7";
	shared import ceylon.net "1.1.0";
	shared import io.vertx.ceylon.core "1.0.0.stef";

} 
