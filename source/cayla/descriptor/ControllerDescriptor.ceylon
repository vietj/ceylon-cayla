import ceylon.language.meta { type }
import ceylon.language.meta.model { ClassModel }
import ceylon.language.meta.declaration { ClassDeclaration }
import cayla { Handler }

shared ControllerDescriptor? controller(Object obj) {
	
	ClassModel<Object> classModel = type(obj);
	value memberDecls = classModel.declaration.memberDeclarations<ClassDeclaration>();	
	HandlerDescriptor[] handlers = [*{
		for (memberDecl in memberDecls)
			if (exists x = memberDecl.extendedType, x.declaration.equals(`class Handler`))
				HandlerDescriptor(obj, memberDecl)		
		}];
	if (nonempty handlers) {
		return ControllerDescriptor(obj, handlers);
	} else {
		return null;
	}
}

shared class ControllerDescriptor(shared Object controller, shared HandlerDescriptor[] handlers) {
}