import cayla { Body, Status }
"A template"
shared interface Template {
    
    "Render the template"
    shared formal void render(StringBuilder to);
    
    shared default Body ok() {
        return status(200);
    }
    
    "Create an 404 status response"
    shared default Status notFound() {
        return status(404);
    }
    
    "Create an 500 status response"
    shared default Status error() {
        return status(500);
    }

    shared default Body status(Integer code) {
        StringBuilder buffer = StringBuilder();
        render(buffer);
        return Body(code, "text/html", buffer.string);
    }
}