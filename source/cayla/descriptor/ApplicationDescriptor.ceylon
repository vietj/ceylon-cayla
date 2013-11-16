import ceylon.language.meta.declaration { Package, NestableDeclaration, ValueDeclaration }

shared class ApplicationDescriptor(Package pkg) {
	
	// Get top level values
	{Anything*} values = {
		for (decl in pkg.members<NestableDeclaration>())
		if (is ValueDeclaration decl)
			decl.get()
	};
	
	// Now filter those that contain at least an handler
	shared ControllerDescriptor[] controllers = [*{
		for (val in values)
			if (is Object val, exists c = controller(val))
				c
	}];	
}