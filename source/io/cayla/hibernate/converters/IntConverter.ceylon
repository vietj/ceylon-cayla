import java.lang {
    JLong=Long
}
import javax.persistence {
    converter,
    AttributeConverter
}

converter(true)
shared class IntConverter() satisfies AttributeConverter<Integer, JLong> {
    shared actual JLong? convertToDatabaseColumn(Integer? x) {
        if(exists x){
            return JLong(x);
        }else{
            return null;
        }
    }
    
    shared actual Integer? convertToEntityAttribute(JLong? y) {
        if(exists y){
            return y.longValue();
        }else{
            return null;
        }
    }
    
}