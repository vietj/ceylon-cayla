import ceylon.language.meta { type }
import ceylon.language.meta.model { ClassModel }
import ceylon.language.meta.declaration { ClassDeclaration, Package, ValueDeclaration, NestableDeclaration }
import cayla { Handler }

shared HandlerDescriptor[] scanHandlersInPackage(Package pkg) {
	value memberDecls = pkg.members<NestableDeclaration>();
	HandlerDescriptor[] handlers1 = [*{
		for (memberDecl in memberDecls)
			if (is ValueDeclaration memberDecl, exists member = memberDecl.get())
				for (handler in scanHandlersInObject(member))
					handler
	}];
	HandlerDescriptor[] handlers2 = [*{
		for (memberDecl in memberDecls)
			if (is ClassDeclaration memberDecl, exists x = memberDecl.extendedType, x.declaration.equals(`class Handler`))
				HandlerDescriptor(factory(memberDecl), memberDecl)
	}];
	return concatenate(handlers1, handlers2);
}

Anything factory(ClassDeclaration classDecl)(Anything[] arguments) {
	return classDecl.instantiate {
		arguments = arguments;
	};
}
Anything memberFactory(ClassDeclaration classDecl, Object o)(Anything[] arguments) {
	return classDecl.memberInstantiate {
		container = o;
		arguments = arguments;
	};
}

shared HandlerDescriptor[] scanHandlersInObject(Object obj) {
	ClassModel<Object> classModel = type(obj);
	value memberDecls = classModel.declaration.memberDeclarations<ClassDeclaration>();	
	HandlerDescriptor[] handlers = [*{
		for (memberDecl in memberDecls)
			if (exists x = memberDecl.extendedType, x.declaration.equals(`class Handler`))
				HandlerDescriptor(memberFactory(memberDecl, obj), memberDecl)		
		}];
	return handlers;
}

