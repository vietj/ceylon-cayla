import vietj.vertx.http { HttpServerResponse }
import ceylon.file { current, File }

"Create an 200 status response"
shared Status ok() {
	return Status(200);
}

"Create an 404 status response"
shared Status notFound() {
	return Status(404);
}

"Create an 500 status response"
shared Status error() {
	return Status(500);
}

"The response to a request."
shared abstract class Response() {
	
	"Send the response"
	shared formal void send(HttpServerResponse resp);
	
}

"A status response provides a simple http response with a status code and headers."
shared class Status(shared Integer code) extends Response() {

	"The response headers"
	variable {<String->String>*} _headers = {};

	"Add an http header to this status object"
	shared default Status header(String->String header) {
		_headers = {header,*_headers};
		return this;
	}

	"Add an http header to this status object"
	shared default Status headers({<String->String>*} _headers) {
		this._headers = _headers;
		return this;
	}

	"Create a new [[Body]] response that extends this [[Status]] response"
	shared Body body(String data) {
		Body body = Body(code, "text/html", data);
		value ret = body.headers(_headers); // IDE does not seem to like this...
		assert(is Body ret);
		return ret;
	}
	
	"Send the response to the client via the Vert.x response"
	shared actual default void send(HttpServerResponse resp) {
		resp.status(code);
		for (header in _headers) {
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
    
    shared actual default String string => "Status[``code``]";

}

"The body response extends the [[Status]] with a body"
shared class Body(Integer code, String mimeType, String data) extends Status(code) {
	
	"Add an http header to this status object"
	shared actual default Body header(String->String header) {
		super.header(header);
		return this;
	}
	
	"Add an http header to this status object"
	shared actual default Body headers({<String->String>*} _headers) {
		super.headers(_headers);
		return this;
	}

	shared actual default void send(HttpServerResponse resp) {
		super.send(resp);
		resp.contentType(mimeType);
		resp.end(data);
	}

	shared actual default String string => "Body[code=``code``,mimeType=``mimeType``]";
}
