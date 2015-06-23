import org.hibernate {
    Session,
    SessionFactory
}

import io.cayla.web {
    Handler,
    Response,
    RequestContext,
    requestContext
}
import ceylon.language.meta.declaration {
    Package
}
shared abstract class DbHandler() extends Handler(){
    shared late Session session;
    shared late RequestContext context;
    shared actual void before(RequestContext context){
        this.context = context;
        session = sessionFactory.openSession();
        session.transaction.begin();
        context.bind(`Session`, session);
    }
    shared actual void after(Throwable? thrown){
        if(exists thrown){
            session.transaction.rollback();
        }else{
            session.transaction.commit();
        }
        context.unbind(`Session`);
        session.close();
    }
    shared actual Response invoke(RequestContext context){
        try{
            return execute();
        }catch(Throwable t){
            t.printStackTrace();
            throw t;
        }
    }
    shared formal Response execute();
}

"The current session"
Session session => requestContext.get(`Session`);

variable late SessionFactory sessionFactory;

"Set up the Database to use in Cayla"
shared void setupDatabase(String url, String user, String pass, Package model){
    sessionFactory = createSessionFactory(url, user, pass, model);
}