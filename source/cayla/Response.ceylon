import vietj.vertx.http { HttpServerResponse }

shared Status ok() {
	return Status(200);
}

shared Status notFound() {
	return Status(404);
}

shared Status error() {
	return Status(500);
}

doc "The response to a request."
shared abstract class Response() {
	
	doc "Send the response"
	shared formal void send(HttpServerResponse resp);
	
}

doc "A status response provides a simple http response with a status code and headers"
shared class Status(shared Integer code) extends Response() {

	@doc "The response headers"
	variable {<String->String>*} headers = {};

	shared Status header(String->String header) {
		headers = {header,*headers};
		return this;
	}

	shared Body body(String data) {
		return Body(code, "text/html", data);
	}
	
	shared actual default void send(HttpServerResponse resp) {
		resp.status(code);
		for (header in headers) {
			resp.headers(header);
		}
	}
}

doc "The body response extends the [[Status]] with a body"
shared class Body(Integer code, String mimeType, String data) extends Status(code) {
	
	shared actual default void send(HttpServerResponse resp) {
		super.send(resp);
		resp.contentType(mimeType);
		resp.end(data);
	}
}