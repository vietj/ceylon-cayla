import cayla.pattern { ... }
import ceylon.test { ... }

shared test void testSimple() {
	value pattern = Pattern("(.)(.)");
	Match[] matches = [*pattern.find("abcdefghi")];
	assertEquals(4, matches.size);
	assert (exists m0 = matches[0]);
	assertEquals("ab", m0[0]);
	assertEquals("a", m0[1]);
	assertEquals("b", m0[2]);
	assert (exists m1 = matches[1]);
	assertEquals("cd", m1[0]);
	assertEquals("c", m1[1]);
	assertEquals("d", m1[2]);
	assert (exists m2 = matches[2]);
	assertEquals("ef", m2[0]);
	assertEquals("e", m2[1]);
	assertEquals("f", m2[2]);
	assert (exists m3 = matches[3]);
	assertEquals("gh", m3[0]);
	assertEquals("g", m3[1]);
	assertEquals("h", m3[2]);
}