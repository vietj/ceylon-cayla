import java.util.regex { Pattern_=Pattern { compile }, Matcher_=Matcher }
import cayla.pattern { Helper { cast } }
import java.lang { CharSequence }

"Wraps java.util.regex"
shared class Pattern(String regex) {

	"The delegated pattern"
	Pattern_ delegate = compile(regex);

	"Return a sequence of match for the specified string argument"
	shared {Match*} find(String s) {
		CharSequence charseq = cast(s);
		Matcher_ matcher = delegate.matcher(charseq);
		object matches satisfies Iterable<Match, Null> {
			shared actual Iterator<Match> iterator() {
				object iterator satisfies Iterator<Match> {
					shared actual Match|Finished next() {
						if (matcher.find()) {
							Integer length = matcher.groupCount();
							Array<[Integer, Integer]> bounds = Array({ for (i in 0..length) [matcher.start(i), matcher.end(i)] });
							Match match = Match(s, bounds);
							return match;
						} else {
							return finished;
						}
					}
				}
				return iterator;
			}
		}
		return matches;
	}
}