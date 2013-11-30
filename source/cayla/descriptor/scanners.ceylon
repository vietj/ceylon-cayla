import ceylon.language.meta { type, annotations }
import ceylon.language.meta.model { ClassModel }
import ceylon.language.meta.declaration { ClassDeclaration, Package, ValueDeclaration, NestableDeclaration }
import cayla { Controller, Route }

shared ControllerDescriptor[] scanControllersInPackage(Package pkg) {
	value memberDecls = pkg.members<NestableDeclaration>();
	ControllerDescriptor[] controllers1 = [*{
		for (memberDecl in memberDecls)
			if (is ValueDeclaration memberDecl, exists member = memberDecl.get())
				for (controller in scanControllersInValueDeclaration({}, memberDecl, member))
					controller
	}];
	ControllerDescriptor[] controllers2 = [*{
		for (memberDecl in memberDecls)
			if (is ClassDeclaration memberDecl, exists x = memberDecl.extendedType, x.declaration.equals(`class Controller`))
				ControllerDescriptor(factory(memberDecl), memberDecl, routeOf({}, memberDecl))
	}];
	return concatenate(controllers1, controllers2);
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

shared ControllerDescriptor[] scanControllersInObject(Object obj) {
    return scanControllersInValueDeclaration({}, null, obj);
}

{Route+}? routeOf({Route*} routes, ClassDeclaration decl) {
    value route = annotations(`Route`, decl);
    if (exists route) {
        return {route,*routes};
    }
    return null;
}

ControllerDescriptor[] scanControllersInValueDeclaration({Route*} routes, ValueDeclaration? vs, Object obj) {
	ClassModel<Object> classModel = type(obj);
	
	//
	{Route*} objRoutes;
	if (exists vs, exists objRoute = annotations(`Route`, vs)) {
		objRoutes = {objRoute,*routes};
	} else {
		objRoutes = {};
	}

    // Controllers in this object
	value classDecls = classModel.declaration.memberDeclarations<ClassDeclaration>();	
	ControllerDescriptor[] controllers = [*{
		for (classDecl in classDecls)
			if (exists x = classDecl.extendedType, x.declaration.equals(`class Controller`))
				ControllerDescriptor(memberFactory(classDecl, obj), classDecl, routeOf(objRoutes, classDecl))		
		}];
		
    // Then recurse on anonymous nested values
	value valueDecls = classModel.declaration.memberDeclarations<ValueDeclaration>();
	ControllerDescriptor[] controllers2 = [*{
		for (valueDecl in valueDecls)
		  if (exists objectDecl = valueDecl.memberGet(obj), type(objectDecl).declaration.anonymous)
    		  for (controllerDesc in scanControllersInValueDeclaration(objRoutes, valueDecl, objectDecl)) 
    		      controllerDesc
	}];

    //
	return concatenate(controllers, controllers2);
}
