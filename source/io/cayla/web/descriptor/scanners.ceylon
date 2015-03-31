import ceylon.language.meta { type, annotations }
import ceylon.language.meta.model { ClassModel }
import ceylon.language.meta.declaration { ClassDeclaration, Package, ValueDeclaration, NestableDeclaration, OpenClassOrInterfaceType }
import io.cayla.web { Handler, Route }

shared HandlerDescriptor[] scanHandlersInPackage(Package pkg) {
	value memberDecls = pkg.members<NestableDeclaration>();
	HandlerDescriptor[] handlers1 = [*{
		for (memberDecl in memberDecls)
			if (is ValueDeclaration memberDecl, exists member = memberDecl.get())
				for (handler in scanHandlersInValueDeclaration({}, memberDecl, member))
					handler
	}];
	HandlerDescriptor[] handlers2 = [*{
		for (memberDecl in memberDecls)
			if (is ClassDeclaration memberDecl,
			     memberDecl.typeParameterDeclarations.empty,
			     memberDecl.apply<Object>().subtypeOf(`Handler`))
				HandlerDescriptor(factory(memberDecl), memberDecl, routeOf({}, memberDecl))
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
    return scanHandlersInValueDeclaration({}, null, obj);
}

{Route+}? routeOf({Route*} routes, ClassDeclaration decl) {
    value route = annotations(`Route`, decl);
    if (exists route) {
        return {route,*routes};
    }
    return null;
}

HandlerDescriptor[] scanHandlersInValueDeclaration({Route*} routes, ValueDeclaration? vs, Object obj) {
	ClassModel<Object> classModel = type(obj);
	
	//
	{Route*} objRoutes;
	if (exists vs, exists objRoute = annotations(`Route`, vs)) {
		objRoutes = {objRoute,*routes};
	} else {
		objRoutes = {};
	}

    // Handlers in this object
	value classDecls = classModel.declaration.memberDeclarations<ClassDeclaration>();	
	HandlerDescriptor[] handlers = [*{
		for (classDecl in classDecls)
			if (exists x = classDecl.extendedType, x.declaration.equals(`class Handler`))
				HandlerDescriptor(memberFactory(classDecl, obj), classDecl, routeOf(objRoutes, classDecl))		
		}];
		
    // Then recurse on anonymous nested values
	value valueDecls = classModel.declaration.memberDeclarations<ValueDeclaration>();
	HandlerDescriptor[] handlers2 = [*{
		for (valueDecl in valueDecls)
		  if (is OpenClassOrInterfaceType valueTypeDeclType = valueDecl.openType,
			is ClassDeclaration valueTypeDecl = valueTypeDeclType.declaration,
			valueTypeDecl.anonymous,
			exists objectDecl = valueDecl.memberGet(obj))
    		  for (controllerDesc in scanHandlersInValueDeclaration(objRoutes, valueDecl, objectDecl)) 
    		      controllerDesc
	}];

    //
	return concatenate(handlers, handlers2);
}
