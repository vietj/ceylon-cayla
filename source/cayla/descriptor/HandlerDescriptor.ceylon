import ceylon.language.meta.declaration { ClassDeclaration, FunctionOrValueDeclaration, ValueDeclaration, OpenType }

shared class HandlerDescriptor(Object controller, ClassDeclaration classDecl) {
	shared Object instantiate(<String->String>* arguments) {
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
		assert(exists instance);
		return instance;
	}	
}