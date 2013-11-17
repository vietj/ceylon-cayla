import ceylon.language.meta { type }
import ceylon.language.meta.model { ClassModel }
import ceylon.language.meta.declaration { ClassDeclaration, Package, FunctionOrValueDeclaration, ValueDeclaration }
import cayla { Handler }

shared HandlerDescriptor[] scanHandlersInPackage(Package pkg) {
	value memberDecls = pkg.members<FunctionOrValueDeclaration>();
	HandlerDescriptor[] handlers = [*{
		for (memberDecl in memberDecls)
			if (is ValueDeclaration memberDecl, exists member = memberDecl.get())
				for (handler in scanHandlersInObject(member))
					handler
	}];
	return handlers;
}

shared HandlerDescriptor[] scanHandlersInObject(Object obj) {
	ClassModel<Object> classModel = type(obj);
	value memberDecls = classModel.declaration.memberDeclarations<ClassDeclaration>();	
	HandlerDescriptor[] handlers = [*{
		for (memberDecl in memberDecls)
			if (exists x = memberDecl.extendedType, x.declaration.equals(`class Handler`))
				HandlerDescriptor(obj, memberDecl)		
		}];
	return handlers;
}
