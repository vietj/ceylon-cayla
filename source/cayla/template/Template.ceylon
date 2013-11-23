import cayla { Body, Status }
"A template"
shared interface Template {
    
    "Render the template"
    shared formal void render(StringBuilder to, {<String->Object>*} values);
    
    shared default Body ok({<String->Object>*} values) {
        return status(200, values);
    }
    
    "Create an 404 status response"
    shared default Status notFound({<String->Object>*} values) {
        return status(404, values);
    }
    
    "Create an 500 status response"
    shared default Status error({<String->Object>*} values) {
        return status(500, values);
    }

    shared default Body status(Integer code, {<String->Object>*} values) {
        StringBuilder buffer = StringBuilder();
        render(buffer, values);
        return Body(code, "text/html", buffer.string);
    }
}