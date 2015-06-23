import ceylon.language.meta.declaration { OpenType }

object stringOrNullUnmarshaller extends Unmarshaller<String?>() {
    shared actual String? unmarshall(String? s) {
        return s;
    }

    shared actual String? default = null;
    
}

object integerOrNullUnmarshaller extends Unmarshaller<Integer?>() {
    shared actual Integer? unmarshall(String? s) {
        if (exists s) {
            if (exists i = parseInteger(s)) {
                return i;
            } else {
                throw Exception("String value ``s`` cannot be parsed to Integer");
            }
        } else {
            return null;
        }
    }
    
    shared actual Integer? default = null;
    
}

object stringUnmarshaller extends Unmarshaller<String>() {
    shared actual String unmarshall(String? s) {
        if (exists s) {
            return s;
        } else {
            throw Exception("String value cannot be null");
        }
    }

    shared actual String default = "";
    
}

object integerUnmarshaller extends Unmarshaller<Integer>() {
    shared actual Integer unmarshall(String? s) {
        if (exists s) {
            if (exists i = parseInteger(s)) {
                return i;
            } else {
                throw Exception("String value ``s`` cannot be parsed to Integer");
            }
        } else {
            throw Exception("String value null cannot be parsed to Integer");
        }
    }

    shared actual Integer default = 0;
    
}

object booleanUnmarshaller extends Unmarshaller<Boolean>() {
    shared actual Boolean unmarshall(String? s) {
        if (exists s) {
            if (exists b = parseBoolean(s)) {
                return b;
            } else {
                throw Exception("String value ``s`` cannot be parsed to Boolean");
            }
        } else {
            throw Exception("String value null cannot be parsed to Boolean");
        }
    }

    shared actual Boolean default = false;
    
}

String? returnStringOrNull() { return "foo"; }
OpenType stringOrNullType = `function returnStringOrNull`.openType;
Integer? returnIntegerOrNull() { return null; }
OpenType integerOrNullType = `function returnIntegerOrNull`.openType;

object unmarshallers {
	shared Unmarshaller<Anything>? find(OpenType type) {
		if (type.equals(stringOrNullType)) {
			return stringOrNullUnmarshaller;
		} else if (type.equals(integerOrNullType)) {
			return integerOrNullUnmarshaller;
		} else if (type.equals(`class String`.openType)) {
			return stringUnmarshaller;
		} else if (type.equals(`class Integer`.openType)) {
			return integerUnmarshaller;
		} else if (type.equals(`class Boolean`.openType)) {
			return booleanUnmarshaller;
		} else {
			return null;
		}
	}	
}