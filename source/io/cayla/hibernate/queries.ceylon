import ceylon.collection {
    ArrayList
}
import ceylon.interop.java {
    CeylonIterable
}
import ceylon.language.meta.model {
    Class
}

import org.hibernate {
    Query
}

Query createQuery(String hql, {<String->Object>*} params = {}){
    value q = session.createQuery(hql);
    for(param in params){
        if(is Integer item = param.item){
            q.setLong(param.key, item);
        }else{
            q.setParameter(param.key, param.item);
        }
    }
    return q;
}

"Run an HQL query with the given parameters and return a list of results"
shared List<T> query<T>(String hql, {<String->Object>*} params = {}){
    value q = createQuery(hql, params);
    value list = q.list();
    value ret = ArrayList<T>(list.size());
    for(elem in CeylonIterable(list)){
        assert(is T elem);
        ret.add(elem);
    }
    return ret;
}

"Find zero or one entity with an HQL query"
shared T? find<T>(String hql, {<String->Object>*} params = {}){
    value q = createQuery(hql, params);
    assert(is T? ret = q.uniqueResult());
    return ret;
}

"List all entities of the type `T`, with an optional query"
shared List<T> list<T>(String query = "", {<String->Object>*} params = {}){
    assert(is Class<T,[]> model = `T`);
    return package.query<T>("FROM ``model.declaration.name`` ``query``", params);
}

"Delte all entities of the type `T`, with an optional query or entity ID"
shared void delete<T>(Integer|String idOrQuery = "", {<String->Object>*} params = {}){
    assert(is Class<T,[]> model = `T`);
    switch(idOrQuery)
    case(is String){
        createQuery("DELETE FROM ``model.declaration.name`` ``idOrQuery``", params).executeUpdate();
    }
    case(is Integer){
        createQuery("DELETE FROM ``model.declaration.name`` WHERE id = :id", {"id" -> idOrQuery}).executeUpdate();
    }
}

"Update all entities of the type `T`, with an optional query"
shared void update<T>(String hql, {<String->Object>*} params = {}){
    assert(is Class<T,[]> model = `T`);
    createQuery("UPDATE ``model.declaration.name`` ``hql``", params).executeUpdate();
}

"Find an entity of the type `T`, by ID"
shared T? findById<T>(Integer id){
    assert(is Class<T,[]> model = `T`);
    return find<T>("FROM ``model.declaration.name`` WHERE id = :id", {"id"->id});
}


