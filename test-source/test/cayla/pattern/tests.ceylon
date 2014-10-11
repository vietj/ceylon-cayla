import io.cayla.web.pattern { ... }
import ceylon.test { ... }

shared test void testSimple() {
	value pattern = Pattern("(.)(.)");
	Match[] matches = [*pattern.find("abcdefghi")];
	assertEquals(4, matches.size);
	assert (exists m0 = matches[0]);
	assertEquals(m0[0], "ab");
	assertEquals(m0[1], "a");
	assertEquals(m0[2], "b");
	assert (exists m1 = matches[1]);
	assertEquals(m1[0], "cd");
	assertEquals(m1[1], "c");
	assertEquals(m1[2], "d");
	assert (exists m2 = matches[2]);
	assertEquals(m2[0], "ef");
	assertEquals(m2[1], "e");
	assertEquals(m2[2], "f");
	assert (exists m3 = matches[3]);
	assertEquals(m3[0], "gh");
	assertEquals(m3[1], "g");
	assertEquals(m3[2], "h");
}