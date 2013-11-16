import cayla { ... }

shared class MyController() {
	
	shared class Index(shared String? s) extends Handler() {
	}
	
	shared Index create(String? s) {
		return Index(s);
	}	
}