import cayla { ... }

shared class MyController() {
	
	shared class Index() extends Handler() {
	}
	
	shared Index create() {
		return Index();
	}
}