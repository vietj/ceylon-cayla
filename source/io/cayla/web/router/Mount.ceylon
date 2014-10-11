import ceylon.language { StringBuilder }

shared abstract class Mount() of Segment | Expression | Any | OneOrMore {
	shared formal {Integer*} match({String*} s);
	shared formal <String->String>? foo({String*} s);
}

shared class Segment(String val_) extends Mount() {
	shared String val => val_;
	shared actual String string => val_;
	shared actual {Integer*} match({String*} s) {
		if (exists t = s.first, t.equals(val_)) {
			return {1};
		} else {
			return {};
		}
	}
	shared actual Boolean equals(Object that) {
		if (is Segment that) {
			return val_.equals(that.val_);
		} else {
			return false;
		}
	}

	shared actual <String->String>? foo({String*} s) => null;
	
}

shared class Expression(String name_) extends Mount() {
	shared String name => name_;
	shared actual String string => ":" + name_.string;
	shared actual {Integer*} match({String*} s) {
		if (exists t = s.first) {
			return {1};
		} else {
			return {};
		}
	}
	shared actual Boolean equals(Object that) {
		if (is Expression that) {
			return name_.equals(that.name_);
		} else {
			return false;
		}
	}

	shared actual <String->String>? foo({String*} s) {
		assert(exists t = s.first);
		return name_->t;
	}
}

shared class Any(String name_) extends Mount() {
    shared String name => name_;
    shared actual String string => ":" + name_.string;
    shared actual {Integer*} match({String*} s) {
        return (0..s.size).reversed;
    }
    shared actual Boolean equals(Object that) {
        if (is Any that) {
            return name_.equals(that.name_);
        } else {
            return false;
        }
    }

    shared actual <String->String>? foo({String*} s) {
        switch (s.size)
        case (0) {
            return name_->"";
        }
        case (1) {
            if (exists first = s.first) {
                return name_->first;
            } else {
                return null;
            }
        }
        else {
            value buffer = StringBuilder();
            for (a in s.indexed) {
                if (a.key > 0) {
                    buffer.append("/");
                }
                buffer.append(a.item);
            }
            return name_->buffer.string;
        }
    }
}

shared class OneOrMore(String name_) extends Mount() {
    shared String name => name_;
    shared actual String string => ":" + name_.string;
    shared actual {Integer*} match({String*} s) {
        if (s.size > 0) {
            return (1..s.size).reversed;
        } else {
            return {};
        }
    }
    shared actual Boolean equals(Object that) {
        if (is OneOrMore that) {
            return name_.equals(that.name_);
        } else {
            return false;
        }
    }

    shared actual <String->String>? foo({String*} s) {
        switch (s.size)
        case (0) {
            return name_->"";
        }
        case (1) {
            if (exists first = s.first) {
                return name_->first;
            } else {
                return null;
            }
        }
        else {
            value buffer = StringBuilder();
            for (a in s.indexed) {
                if (a.key > 0) {
                    buffer.append("/");
                }
                buffer.append(a.item);
            }
            return name_->buffer.string;
        }
    }
}
