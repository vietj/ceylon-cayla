"A pattern match"
shared class Match(String seq, Array<[Integer,Integer]> bounds) satisfies Correspondence<Integer, String> {
	
	"The group count"
	shared Integer size => bounds.size;
	
	"The lazy created string array"
	variable Array<String>? groups = null;
	
	shared actual String? get(Integer key) {
		Array<String> abc;
		if (exists tmp = groups) {
			abc = tmp;
		} else {
			{String*} a = { for (bound in bounds) seq[bound[0]..(bound[1] - 1)] };
			abc = Array(a);
			groups = abc;
		}
		return abc[key];
	}
	shared actual Boolean defines(Integer key) => get(key) exists;
	
}