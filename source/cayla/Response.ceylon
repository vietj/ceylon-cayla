import vietj.vertx.http { HttpServerResponse }
import ceylon.file { current, File }

shared Status ok() {
	return Status(200);
}

shared Status notFound() {
	return Status(404);
}

shared Status error() {
	return Status(500);
}

"The response to a request."
shared abstract class Response() {
	
	"Send the response"
	shared formal void send(HttpServerResponse resp);
	
}

"A status response provides a simple http response with a status code and headers"
shared class Status(shared Integer code) extends Response() {

	"The response headers"
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

    shared Body template(String path, {<String->Object>*} values) {
        if (is File f = current.childPath(path).resource) {
            value sb = StringBuilder();
            value r = f.Reader();
            try {
                while (exists l = r.readLine()) {
                    sb.append(l);
                    sb.appendNewline();
                }
            } catch (Exception ex) {
                print("well, fuck.");
            } finally {
                r.destroy();
            }
            //Now replace the values
            variable value s = sb.string;
            for (k->v in values) {
                s = s.replace("${``k``}", v.string);
            }
            return Body(code, "text/html", s);
        }
        return Body(code, "text/plain", "TEMPLATE ``path`` NOT FOUND");
    }

}

"The body response extends the [[Status]] with a body"
shared class Body(Integer code, String mimeType, String data) extends Status(code) {
	
	shared actual default void send(HttpServerResponse resp) {
		super.send(resp);
		resp.contentType(mimeType);
		resp.end(data);
	}
}
