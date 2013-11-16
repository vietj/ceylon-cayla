import ceylon.language.meta.declaration { ClassDeclaration, FunctionOrValueDeclaration, ValueDeclaration, OpenType }

String? returnStringOrNull() { return nothing; }
OpenType stringOrNullType = `function returnStringOrNull`.openType;

shared class HandlerDescriptor(Object controller, ClassDeclaration classDecl) {
	shared Object instantiate(<String->String>* arguments) {
		Anything[] buildArguments(FunctionOrValueDeclaration[] parametersDecl) {
			value parameterDecl = parametersDecl.first;
			if (is ValueDeclaration parameterDecl) {
				Anything[] rest = buildArguments(parametersDecl.rest);
				value type = parameterDecl.openType;
				String name = parameterDecl.name;
				value argument = arguments.find((String->String elem) => elem.key.equals(name));
				if (type.equals(`class String`.openType)) {
					if (exists argument) {
						return [argument.item,*rest];
					} else {
						if (parameterDecl.defaulted) {
							throw Exception("Should obtain default argument somehow ``name``");
						} else {
							throw Exception("Missing argument ``name``");
						}
					}
				} else if (type.equals(stringOrNullType)) {
					if (exists argument) {
						return [argument.item,*rest];
					} else {
						if (parameterDecl.defaulted) {
							throw Exception("Should obtain default argument somehow ``name``");
						} else {
							return [null,*rest];
						}
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