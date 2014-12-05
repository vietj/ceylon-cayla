import io.cayla.web { Handler, Response, RequestContext, forbidden }
import ceylon.promise { Promise }
import io.vertx.ceylon.core.http { HttpServerResponse }

"A base handler for sending application assets"
shared class AssetHandler(String path, Boolean(String) pathValidation = pathValidator) extends Handler() {
  
  shared actual default Promise<Response>|Response invoke(RequestContext context) {
    value valid = pathValidation(path);
    if (!valid) {
      return forbidden {
        body = "Resource ``context.request.path`` is forbidden";
      };
    } else {
      object stream extends Response() {
        shared actual void send(HttpServerResponse resp) {
          resp.sendFile(path);
        }
      }
      return stream;
    }
  }
}