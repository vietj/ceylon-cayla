import ceylon.language.meta.declaration { ClassDeclaration, FunctionOrValueDeclaration, ValueDeclaration }
import cayla { Route, Controller, Get, Put, Post, Trace, Head, Delete, Options, Connect }
import ceylon.language.meta { annotations, type }
import ceylon.collection { HashMap }
import cayla.descriptor { unmarshallers }
import ceylon.net.http { Method, get, put, post, trace, head, delete, options, connect }

"""Describes a controller."""
shared class ControllerDescriptor(Anything(Anything[]) factory, shared ClassDeclaration classDecl) {
	
	// Checks
	for (parameterDecl in classDecl.parameterDeclarations) {
		// Must be shared
		if (!parameterDecl.shared) {
			throw Exception("Parameter ``parameterDecl.name`` of ``classDecl`` must be shared");
		}
		// Must be unshmarshallable
		if (!unmarshallers.find(parameterDecl.openType) exists) {
			throw Exception("Type ``parameterDecl.openType`` of parameter ``parameterDecl.name`` of ``classDecl`` is not yet supported");
		}
	}
	
	// Methods or empty (i.e all)
	{Method*} m0 = annotations(`Get`, classDecl) exists then {get} else {};
	{Method*} m1 = annotations(`Put`, classDecl) exists then {put,*m0} else {*m0};
	{Method*} m2 = annotations(`Post`, classDecl) exists then {post,*m1} else {*m1};
	{Method*} m3 = annotations(`Trace`, classDecl) exists then {trace,*m2} else {*m2};
	{Method*} m4 = annotations(`Head`, classDecl) exists then {head,*m3} else {*m3};
	{Method*} m5 = annotations(`Delete`, classDecl) exists then {delete,*m4} else {*m4};
	{Method*} m6 = annotations(`Options`, classDecl) exists then {options,*m5} else {*m5};
	{Method*} m7 = annotations(`Connect`, classDecl) exists then {connect,*m6} else {*m6};
	shared {Method*} methods = m7;
	
	// Determine default parameters using the minimal constructor we can find
	// and then reading the values
	value min = factory([
			for (parameterDecl in classDecl.parameterDeclarations)
				if (!parameterDecl.defaulted)
					"foo"]);
	assert(is Object min);
	Map<String, Object> defaultParameters = HashMap([
		for (parameterDecl in classDecl.parameterDeclarations)
			if (is ValueDeclaration parameterDecl, parameterDecl.defaulted)
				if (is Object aaa = parameterDecl.memberGet(min))
					parameterDecl.name->aaa
	]);
	
	// Methods
	
	
	"Instantiate a controller"
	throws(`class Exception`, "when the controller cannot be instantiated")
	shared Controller instantiate("The arguments" <String->String>* arguments) {
		Anything[] buildArguments(FunctionOrValueDeclaration[] parametersDecl) {
			value parameterDecl = parametersDecl.first;
			if (is ValueDeclaration parameterDecl) {
				Anything[] rest = buildArguments(parametersDecl.rest);
				value type = parameterDecl.openType;
				String name = parameterDecl.name;
				value argument = arguments.find((String->String elem) => elem.key.equals(name));
				Anything(String?)? unmarshaller = unmarshallers.find(type);
				if (exists unmarshaller) {
					String? item = argument?.item;
					if (!(item exists) && parameterDecl.defaulted) {
						value default = defaultParameters[parameterDecl.name];
						return [default,*rest];
					} else {
						Anything unmarshalled = unmarshaller(item);
						return [unmarshalled,*rest];
					}
				} else {
					throw Exception("Unsupported parameter type ``type``");
				}
			} else {
				return [];
			}
		}
		value instance = factory(buildArguments(classDecl.parameterDeclarations));
		assert(is Controller instance);
		return instance;
	}
	
	"Extract the request parameters of a controller"
	shared Map<String, String> parameters("The controller to examine" Controller controller) => 
		LazyMap({
			for (parameterDecl in classDecl.parameterDeclarations)
				if (is ValueDeclaration parameterDecl, exists t = parameterDecl.memberGet(controller))
					parameterDecl.name->t.string
		});
	
	"Returns the [[Route]] of this controller, it may be null"
	shared Route? route => annotations(`Route`, classDecl);
	
	"Test if the specified controller is described by this descriptor instance"
	shared Boolean isInstance("The controller to test" Controller controller) => type(controller).declaration.equals(classDecl);

}