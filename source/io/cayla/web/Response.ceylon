import io.vertx.ceylon.core.http { HttpServerResponse }
import io.cayla.web.template { Template }
import ceylon.collection { StringBuilder }

shared Status status(Integer status = 200, <String|Template>? body = null, String mimeType = "text/html", {<String->String>*} headers = {}) {
    if (exists body) {
        return Body(status, mimeType, body, headers);
    } else {
        return Status(status);
    }
}

"Create an 200 status response"
shared Status ok(<String|Template>? body = null, String mimeType = "text/html", {<String->String>*} headers = {}) =>
        status(200, body, mimeType, headers);

"Create an 404 status response"
shared Status notFound(<String|Template>? body = null, String mimeType = "text/html", {<String->String>*} headers = {}) =>
        status(404, body, mimeType, headers);

"Create an 500 status response"
shared Status error(<String|Template>? body = null, String mimeType = "text/html", {<String->String>*} headers = {}) =>
        status(500, body, mimeType, headers);

"The response to a request."
shared abstract class Response() {
	
	"Send the response"
	shared formal void send(HttpServerResponse resp);
	
}

"A status response provides a simple http response with a status code and headers."
shared class Status(shared Integer code, {<String->String>*} headers = {}) extends Response() {

	"Send the response to the client via the Vert.x response"
	shared actual default void send(HttpServerResponse resp) {
		resp.status(code);
		resp.headers(headers);
	}

    shared actual default String string => "Status[``code``]";

}

"The body response extends the [[Status]] with a body"
shared class Body(Integer code, String mimeType, <String|Template> data, {<String->String>*} headers = {}) extends Status(code) {
	
	shared actual default void send(HttpServerResponse resp) {
		try {
			super.send(resp);
			String s;
			switch (data) 
			case (is Template) {
				StringBuilder buffer = StringBuilder();
				data.render(buffer);
				s = buffer.string;
			}
			case (is String) {
				s = data;
			}
			resp.contentType(mimeType);
			resp.end(s);
		} finally {
			resp.close();
		}
	}

	shared actual default String string => "Body[code=``code``,mimeType=``mimeType``]";
}
