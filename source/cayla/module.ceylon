"""A web framework for Ceylon.
   
   # Application
   
   A web application extends the [[Application]] class:
   
       shared class MyApplication() extends Application() {
       }
   
   # Controllers
   
   Controllers are nested class of your application class and must extends the [[Controller]] class. A controller handle a request
   with its `handle` method.
   
   Controllers use the `route` annotation and are parameterized by `String` parameters, each parameter must be a shared parameter:
   
       route "/"
       shared class MyController(shared String color) extends Controller() { ... }
   
   Controller urls can be easily constructed via the `string` method.
   
       value url = MyController("red").string;
   
   Request handling is implemented via the `handle` method:
   
       shared class MyController() extends Controller() {
         shared actual default Response handle() => ok().body("<html><body>Hello World</body></html>");
       }
   
"""
module cayla '0.1.0' {

	import java.base '7';
	shared import vietj.vertx '0.1.2';
	shared import vietj.promises '0.3.3';
	import ceylon.collection '0.5';
	shared import ceylon.net '0.5';

} 
