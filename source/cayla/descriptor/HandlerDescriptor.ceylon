import ceylon.language.meta.declaration { ClassDeclaration, FunctionOrValueDeclaration, ValueDeclaration, OpenType }
import ceylon.language.meta.model { MemberClass }
import cayla { Route, Handler }
import ceylon.language.meta { annotations, type }

shared class HandlerDescriptor(Object controller, ClassDeclaration classDecl) {
	
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
						throw Exception("Should obtain default argument somehow ``name``");
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
		value instance = classDecl.memberInstantiate {
			container = controller;
			arguments = buildArguments(classDecl.parameterDeclarations);
		};
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
	
	shared Boolean isInstance(Object obj) => type(obj).declaration.equals(classDecl);
	
}