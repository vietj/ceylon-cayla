import ceylon.promise { Promise }
import io.cayla.web.descriptor { ApplicationDescriptor }
import ceylon.language.meta.declaration { Package }
import io.vertx.ceylon.core { Vertx }
import io.vertx.ceylon.core.http { HttpServer }
import java.lang {
    Thread
}

"""A Cayla application.
   
   # Creating a Cayla application
   
   An application is created by provided a container in which controllers are discoved.
   
   ## Object container
   
   Creates an application with a top level container object, the object is scanned for the nested controllers.
   
       object controllers {
         route("/")
         shared class Index() {
           shared actual default Response handle() => ok {
             "Hello World";
           };
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
shared class Application(Package|Object container, shared Config config = Config(), Vertx vertx = Vertx()) {

	"The application descriptor"
	shared ApplicationDescriptor descriptor = ApplicationDescriptor(container);
	
	"Start the application and returns a [[Runtime]] [[Promise]]"
	shared Promise<Runtime> start() {
		HttpServer server = vertx.createHttpServer();
		Runtime runtime = Runtime(this, vertx, server);
		server.requestHandler(runtime.handle);
		Promise<HttpServer> promise = server.listen(config.port, config.hostName);
		return promise.compose((HttpServer n) => runtime);
	}

    "Run the application"
	shared void run("Current thread is blocked until the console reads a line" Boolean block = true) {
		Promise<Runtime> runtime = start();
		runtime.always((Runtime|Throwable arg) => print(arg is Runtime then "started on port ``config.port``" else "failed: ``arg.string``"));
		process.readLine();
		runtime.compose((Runtime runtime) => runtime.stop()).onComplete((Anything anyting) => print("stopped"));
	}

	"Run the application forever"
	shared void runBlocking() {
		Promise<Runtime> runtime = start();
		runtime.always((Runtime|Throwable arg) => print(arg is Runtime then "started on port ``config.port``" else "failed: ``arg.string``"));
		object daemon extends Thread(){
			shared actual void run(){
				print("Daemon thread running");
				join();
			}
		}
		daemon.daemon = true;
		daemon.start();
		// wait for it
		daemon.join();
	}
}