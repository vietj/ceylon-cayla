import ceylon.language.meta.declaration { ClassDeclaration, FunctionOrValueDeclaration, OpenClassOrInterfaceType }
shared class HandlerDescriptor(Object controller, ClassDeclaration classDecl) {
	
	shared Object instantiate(<String->String>* arguments) {
		Anything[] buildArguments(FunctionOrValueDeclaration[] parametersDecl) {
			value parameterDecl = parametersDecl.first;
			if (exists parameterDecl) {
				Anything[] rest = buildArguments(parametersDecl.rest);
				value type = parameterDecl.openType;
				if (is OpenClassOrInterfaceType type) {
					String name = parameterDecl.name;
					value argument = arguments.find((String->String elem) => elem.key.equals(name));
					if (type.declaration.equals(`class String`)) {
						if (exists argument) {
							return [argument.item,*rest];
						} else {
							throw Exception("Missing argument ``name``");
						}
					} else {
						throw Exception("Unsupported parameter type ``type``");
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