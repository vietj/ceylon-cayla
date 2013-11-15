import ceylon.language.meta { type }
import ceylon.language.meta.model { ClassModel, Class, MemberClass }
import ceylon.language.meta.declaration { ClassDeclaration }
import cayla { Handler }

shared class ControllerDescriptor(Object controller) {
	
	ClassModel<Object> classModel = type(controller);
	value memberDecls = classModel.declaration.memberDeclarations<ClassDeclaration>();	
//	shared Iterable<MemberClass<Object, Handler>> handlers => { for (memberDecl in memberDecls)
//		memberDecl.memberClassApply<Object, Handler>(classModel)
//	};

	shared Iterable<HandlerDescriptor> handlers = { for (memberDecl in memberDecls)
		if (exists x = memberDecl.extendedType, x.declaration.equals(`class Handler`))
			HandlerDescriptor(controller, memberDecl)		
	};
	// shared Map<ClassDeclaration, HandlerDescriptor> handlers = LazyMap(a);
	
}