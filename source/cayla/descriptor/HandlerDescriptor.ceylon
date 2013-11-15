import ceylon.language.meta.declaration { ClassDeclaration }
shared class HandlerDescriptor(Object controller, ClassDeclaration classDecl) {
	
	shared Object instantiate() {
		value instance = classDecl.memberInstantiate(controller);
		assert(exists instance);
		return instance;
	}	
}