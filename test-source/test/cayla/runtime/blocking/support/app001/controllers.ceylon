import io.cayla.web { Handler, route, Response, ok, blocking, RequestContext }

shared object mycontroller {
  
  route("/")
	blocking
	shared class Index() extends Handler() {
		shared actual Response invoke(RequestContext context) => ok {
			body = "``context.runtime.vertx.eventLoop``";
		};
	}
}