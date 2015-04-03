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
    shared actual Response invoke(RequestContext context){
        this.context = context;
        session = sessionFactory.openSession();
        session.transaction.begin();
        context.bind(`Session`, session);
        try{
            Response ret = execute();
            // FIXME: this will not work with actions in templates which are eval'ed later
            session.transaction.commit();
            return ret;
        }catch(Throwable t){
            session.transaction.rollback();
            t.printStackTrace();
            throw t;
        }finally{
            context.unbind(`Session`);
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