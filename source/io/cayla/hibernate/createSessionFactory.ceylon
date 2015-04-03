import ceylon.interop.java {
    javaClass,
    javaClassFromInstance
}
import ceylon.language.meta.declaration {
    ClassDeclaration,
    Package
}
import org.hibernate {
    SessionFactory
}
import org.hibernate.cfg {
    Configuration
}
import io.cayla.hibernate.converters {
    IntConverter
}

shared SessionFactory createSessionFactory(String databaseUrl, String user, String password,
    Package modelPackage,
    String dialect = "org.hibernate.dialect.PostgreSQL9Dialect",
    String driverClass = "org.postgresql.Driver"){
    value cfg = Configuration()
            .setProperty("hibernate.dialect", dialect)
            .setProperty("hibernate.connection.driver_class", driverClass)
            .setProperty("hibernate.connection.url", databaseUrl)
            .setProperty("hibernate.connection.username", user)
            .setProperty("hibernate.connection.pool_size", "5")
            .setProperty("hibernate.hbm2ddl.auto", "update")
            .setProperty("hibernate.connection.password", password);
    cfg.addAttributeConverter(javaClass<IntConverter>());
    for (klass in modelPackage.members<ClassDeclaration>()) {
        print("Installing model class ``klass``");
        if(klass.abstract){
            continue;
        }
        // FIXME: until we can obtain the Java class from the metamodel, we have to instantiate it
        assert(is Object inst = klass.instantiate());
        cfg.addAnnotatedClass(javaClassFromInstance<Object>(inst));
    }
    return cfg.buildSessionFactory();
}