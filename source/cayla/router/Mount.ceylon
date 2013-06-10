shared abstract class Mount() of Segment | Expression {
	shared formal Boolean match(String s);
}

shared class Segment(String val_) extends Mount() {
	shared String val => val_;
	shared actual String string => val_;
	shared actual Boolean match(String s) => val_.equals(s);
	shared actual Boolean equals(Object that) {
		if (is Segment that) {
			return val_.equals(that.val_);
		} else {
			return false;
		}
	}
}

shared class Expression(String name_) extends Mount() {
	shared String name => name_;
	shared actual String string => ":" + name_.string;
	shared actual Boolean match(String s) => true;
	shared actual Boolean equals(Object that) {
		if (is Expression that) {
			return name_.equals(that.name_);
		} else {
			return false;
		}
	}
}
