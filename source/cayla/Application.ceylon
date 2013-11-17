import vietj.promises { Promise }
import cayla.descriptor { ApplicationDescriptor }
import ceylon.language.meta.declaration { Package }
import vietj.vertx { Vertx }
import vietj.vertx.http { HttpServer }

shared class Application(Package pkg) {

	shared ApplicationDescriptor descriptor = ApplicationDescriptor(pkg);
	
	shared Promise<Runtime> start() {
		Vertx vertx = Vertx();
		HttpServer server = vertx.createHttpServer();
		Runtime runtime = Runtime(this, vertx);
		server.requestHandler(runtime.handle);
		Promise<HttpServer> promise = server.listen(8080);
		return promise.then_((HttpServer n) => runtime);
	}	
}