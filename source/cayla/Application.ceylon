import vietj.promises { Promise }

shared abstract class Application() {

	shared ApplicationDescriptor build() {
		return ApplicationDescriptor(this);
	}
	
	shared Promise<Runtime> start() => build().start();
	
}