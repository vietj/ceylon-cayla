abstract class Unmarshaller<out Value>() {
    
    shared formal Value unmarshall(String? s);
    
    shared formal Value default;
    
}