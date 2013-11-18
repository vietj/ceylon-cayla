import vietj.promises { Promise }
import cayla.descriptor { ApplicationDescriptor }
import ceylon.language.meta.declaration { Package }
import vietj.vertx { Vertx }
import vietj.vertx.http { HttpServer }

"""A Cayla application.
   
   # Creating a Cayla application
   
   An application is created by provided a container in which controllers are discoved.
   
   ## Object container
   
   Creates an application with a top level container object, the object is scanned for the nested controllers.
   
       object controllers {
         route("/")
         shared class Index() {
           shared actual default Response handle() => Response.ok().body("Hello World");
         }
       }
       void run() {
         value application = Application(controllers);
         application.start();
         process.readLine();
       }
   
   ## Package container
   
   Creates an application with a package container object, the package is scanned for the nested controllers.
   
       void run() {
         value application = Application(`package my.application`);
         application.start();
         process.readLine();
       }
   
   # Application life cycle
   
   The [[start]] method starts the application and returns a [[Runtime]] [[Promise]] which:
   - is resolved with the [[Runtime]] object when the application is fully started
   - is failed with the reason of the failure when the application cannot be started
   
   This [[Promise]] can be used to be aware of the application life cycle:
   
       Promise<Runtime> runtime = application.start(); 
       runtime.always((Runtime|Exception arg) => print(arg is Runtime then "started" else "failed: ``arg.string``"));
   """
shared class Application(Package|Object container) {

	"The application descriptor"
	shared ApplicationDescriptor descriptor = ApplicationDescriptor(container);
	
	"Start the application and returns a [[Runtime]] [[Promise]]"
	shared Promise<Runtime> start() {
		Vertx vertx = Vertx();
		HttpServer server = vertx.createHttpServer();
		Runtime runtime = Runtime(this, vertx);
		server.requestHandler(runtime.handle);
		Promise<HttpServer> promise = server.listen(8080);
		return promise.then_((HttpServer n) => runtime);
	}	
}