import ceylon.language.meta.declaration { ClassDeclaration, FunctionOrValueDeclaration, ValueDeclaration }
import cayla { Route, Handler }
import ceylon.language.meta { annotations, type }
import ceylon.collection { HashMap }
import cayla.descriptor { unmarshallers }

shared class HandlerDescriptor(Anything(Anything[]) factory, shared ClassDeclaration classDecl) {
	
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
	
	shared Handler instantiate(<String->String>* arguments) {
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
		assert(is Handler instance);
		return instance;
	}
	
	shared Map<String, String> parameters(Object handler) => 
		LazyMap({
			for (parameterDecl in classDecl.parameterDeclarations)
				if (is ValueDeclaration parameterDecl, exists t = parameterDecl.memberGet(handler))
					parameterDecl.name->t.string
		});
	
	shared Route? route => annotations(`Route`, classDecl);
	
	shared Boolean isInstance(Handler handler) => type(handler).declaration.equals(classDecl);
	
}