import vietj.promises { Promise }
"""The base class for web controller handlers. An controller handler must extend this class, its attributes are mapped to
   the request parameters.
   
   Attributes of this class should:
   - declares the String type (later Boolean, Integer, etc...)
   - be shared
   - be immutable
   
   An handler serves two purposes:
   . to handle a request
   . to produce an URL that will provide an address for this controller
   
       route("/")
       shared class Index() extends Handler() {
         shared actual default Response handle() => Response.ok().body("Hello World");
       }
   
   Our *Index* handler:
   - extends the [[Handler]] interface
   - is mapped to the server root via the [route] annotation
   - overrides the [[handle]] method for serving the default page
   
   Mapping a request parameter to the handler can be achieved by declaring a corresponding attribute:
   
       route("/greeter")
       shared class Greeter(String name) extends Handler() {
         shared actual default Response handle() => Response.ok().body("Hello ``name``");
       }
   
   The *Greeter* handler is mapped to the */greeter* path and can be invoked with an URL like */greeter?name=Cayla*.
   
   The parameter can also be mapped to a path parameter by specifying it in the path:
   
       route("/greeter/:name")
       shared class Greeter(String name) extends Handler() {
         shared actual default Response handle() => ok {
           "Hello ``name``"
         };
       }
   
   The handler [[string]] produces an URL for invoking this handler, the URL is generated using:
   - the path declared by the [[route]] annotation
   - the controller attributes
   
   Let's redefine our *Index* controller:
   
       route("/")
       shared class Index() extends Handler() {
         shared actual default Response handle() => ok {
           "Say hello to <a href="``Greeter("Cayla")``">Cayla</a>"
         };
       }
   
   The response body will contain an URL that will look like *http://localhost:8080/greeter?name=Cayla*. The URL would be
   *http://localhost:8080/greeter/Cayla* when using path parameter mapping.
   
   The [[string]] method redefined by the base [[Handler]] class:
   
   - takes care of generating the correct URL, including the parameter encoding
   - provides a safe way for generating URL that is enforced by the Ceylon compiler and is refactorable in the Ceylon IDE
   
   When more context is required during the request, the [[invoke]] method can be overriden instead of the [[handle]] method.
   The [[RequestContext]] class provides access to the full content of the request.
   """
shared abstract class Handler() {
	
	"Invoke the handler with the specified request context"
	shared default Promise<Response>|Response invoke(RequestContext context) {
		return handle();
	}
	
	"Handle the request and return a response"
	shared default Promise<Response>|Response handle() {
		return ok();
	}

    "Generates an URL to address this controller"
	shared actual String string {
		if (exists context = current.get) {
			return context.url(this);
		} else {
			// Cannot generate anything
			return "";
		}
	}
} 