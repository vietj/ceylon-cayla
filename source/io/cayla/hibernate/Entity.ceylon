import javax.persistence {
    mappedSuperclass,
    generatedValue,
    id
}

mappedSuperclass
shared class Entity(){
    id generatedValue
    shared variable Integer id = 0;

    shared void save(){
        session.saveOrUpdate(this);
    }
    
    shared void delete(){
        session.delete(this);
    }
}