import cayla { Response, route, Controller, Runtime, Application }
import vietj.promises { Promise }
import cayla.template { Template, SimpleTemplate }
"Run the module `examples.cayla.helloworld`."

Template main = SimpleTemplate(
    "<!DOCTYPE html>
      <html>
        <head>
          <title>Hello World</title>
          <link rel='stylesheet' href='//www.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap.min.css'>
        </head>
        <body style='padding-top: 32px'>
          <div class='container'>
          <div class='hero-unit'>
            <div class='center'><h1>Hello ${name}</h1></div>
          </div>
          <div class='offset4 span4'>                                                
          <form class='form-signin' action='${action}' method='get'>
             <div class='control-group'>
               <div class='controls'>
                 <input type='text' name='name' placeholder='Your Name'>
               </div>  
             </div>
             <div class='control-group'>
               <div class='controls'> 
                 <button type='submit' class='btn btn-default'>Say Hello</button>                                                         
               </div>                                                                                                                
             </div>                                                                                                                                                                                                                                                                                                                                            
          </form>
          </div>                                            
          </div>
        </body>
      </html>");

route("/")
class Index(shared String? name = null) extends Controller() {
	shared actual default Response handle() {
		String s;
		if (exists name) {
			s = name;
		} else {
			s = "World";
		}
        return main.ok({"action"->Index(),"name"->s}); 
    }
}

shared void run() {
    value application = Application(`package examples.cayla.helloworld`);
    Promise<Runtime> runtime = application.start();
    runtime.always((Runtime|Exception arg) => print(arg is Runtime then "started" else "failed: ``arg.string``"));
    process.readLine();
    runtime.then_((Runtime runtime) => runtime.stop()).then_((Anything anyting) => print("stopped"));
}