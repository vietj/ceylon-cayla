import io.cayla.web { Handler, route, Response, ok,
  RequestContext }
import ceylon.promise {
  Promise,
  Deferred}

route("/")
shared class Index() extends Handler() {
	shared actual Promise<Response> invoke(RequestContext context) {
		value deferred = context.deferred<String>();
		context.runtime.vertx.runOnContext(void () {
			deferred.resolve("whatever");
		});
		return deferred.promise.compose {
			Response onFulfilled(String s) {
				return ok {
					"``Index()``";
				};
			}
		};
	}
}
