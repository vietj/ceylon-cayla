import io.cayla.web { Response, route, Handler, Application, ok, Config }
import io.cayla.web.asset { AssetHandler }

route("/")
class ProxyController() 
        extends Handler() {
    shared actual Response handle() =>
       ok {
        body = "<!DOCTYPE html>
                <html>
                <body>
                Content of the document......
                </body>
                <img src='``Asset("pic.png")``' alt=''/>
                </html>";
      };
}

route("/assets/*path")
class Asset(shared String path) extends AssetHandler("examples-source/examples/cayla/assets/``path``") {
}

shared void run() => Application(`package examples.cayla.assets`, Config{port = 8080;}).run();
