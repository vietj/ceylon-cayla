"""# The Cayla Web Framework
   
   Cayla makes easy creating web application with Ceylon.
   
   ## Creating a simple application in seconds
   
   ### Import the Cayla module
   
       module my.app "1.0.0" {
         import cayla "0.3.0";
       }
   
   ### Write the controller
   
       import cayla { ... }

       object controllers {
         route("/")
         shared class Index() extends Controller() {
           shared actual default Response handle() => ok().body("Hello World");
         }
       }
 
       shared void run() {
         value application = Application(controllers);
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
   
   Controllers must extend the [[Controller]] interface, they can declare parameters which shall declares the 
   `String` type, be shared and immutable. Such parameters are mapped to*query* or *path*  request parameters.
   
   ### Query parameters
   
       route("/greeter")
       shared clas Greeter(String name) extends Controller() {
         shared actual default Response handle() => ok().body("Hello ``name``");
       }
   
   ### Path parameters
   
       route("/greeter/:name")
       shared clas Greeter(String name) extends Controller() {
         shared actual default Response handle() => ok().body("Hello ``name``");
       }
   
   Path parameters can match 
   
   * a single path segment (i.e that does not contain any `/` chars) declared with the `:` prefix like `:name`
   * zero or more segments `*` prefix like `*name`
   * one or more segments `+` prefix like `+name`
   
   ### Controller URL
   
   Controllers can be addressed using the redefined [[Controller.string]] method. In a controller the expression
   `Greeter("Cayla")` will produce the *http://localhost:8080/greeter?name=Cayla* or the 
   *http://localhost:8080/greeter/Cayla* URL.
   
   ## Controller logic
   
   During an invocation Cayla dispatches the request to the [[Controller.handle]] method. This method should implement
   the controller behavior.
   
   It is also possible to override the [[Controller.invoke]] method instead that provides access to the [[RequestContext]]
   class that exposes Cayla objects.
   
   Both methods returns a [[Response]] object that is sent to the client via Vert.x
   
   ## Responses
   
   The [[Response]] class is the base response, the [[Status]] class extends the response class to define the http status
   and the [[Body]] class extends the [[Status]] with a response body.
   
   Creating responses is usually done via the fluent API and the top level functions such as [[ok]], [[notFound]] or
   [[error]].
   
       return notFound().body("Not found!!!!");
   
   ## Http methods
   
   By default a controller is bound to a route for all Http methods. This can be restricted by using annotations like
   [[get]], [[post]], [[head]], [[put]], etc...

       get route("/greeter")
       shared clas Greeter(String name) extends Controller() {
         shared actual default Response handle() => ok().body("Hello ``name``");
       }

  """
module cayla "0.3.0" {

	shared import java.base "7";
	shared import ceylon.net "1.0.0";
	shared import vietj.vertx "0.3.4";

} 
