import ceylon.language.meta.declaration { OpenType }

String? returnStringOrNull() { return nothing; }
OpenType stringOrNullType = `function returnStringOrNull`.openType;
object unmarshallers {
	shared Anything(String?)? find(OpenType type) {
		if (type.equals(stringOrNullType)) {
			return (String? s) => s;
		} else if (type.equals(`class String`.openType)) {
			String f(String? s) {
				if (exists s) {
					return s;
				} else {
					throw Exception();
				}
			}
			return f;
		} else {
			return null;
		}
	}	
}