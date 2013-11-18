"""# The Cayla Web Framework
   
   Cayla makes easy creating web application with Ceylon.
   
   ## Creating a simple application in seconds
   
   ### Import the Cayla module
   
       module my.module "1.0.0" {
         import cayla "0.1.0"
       }
   
   ### Write the controller
   
       import cayla { ... }
   
       route("/")
       shared class Index() extends Controller() {
         shared actual default Response handle() => Response.ok().body("Hello World");
       }
   
       shared void run() {
         value application = Application(sample);
         runtime.always((Runtime|Exception arg) => print(arg is Runtime then "started" else "failed: ``arg.string``"));
         process.readLine();
       }
   
   ### Build and run!
   
       > ceylon compile my.module
       ...
       > ceylon run my.module/1.0
       started
   
   """
module cayla "0.1.0" {

	shared import java.base "7";
	shared import ceylon.net "1.0.0";
	shared import vietj.vertx "0.3.0";

} 
