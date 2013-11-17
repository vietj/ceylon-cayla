import cayla { ... }

shared class Controllers() {
	
	shared class Index(shared String s) extends Controller() {
	}
	
	shared Index create(String s) {
		return Index(s);
	}
}