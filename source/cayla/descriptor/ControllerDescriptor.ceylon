import ceylon.language.meta.declaration { ClassDeclaration, FunctionOrValueDeclaration, ValueDeclaration }
import cayla { Route, Controller }
import ceylon.language.meta { annotations, type }
import ceylon.collection { HashMap }
import cayla.descriptor { unmarshallers }

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
						if (exists default) {
							return [default,*rest];
						} else {
							throw Exception("Should obtain default argument somehow ``name``");
						}
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