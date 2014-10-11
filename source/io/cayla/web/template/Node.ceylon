import ceylon.language { StringBuilder }

shared abstract class Node() satisfies Template {
    
    shared actual String string {
        value buffer = StringBuilder();
        render(buffer);
        return buffer.string;
    }
}