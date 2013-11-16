shared annotation Route route(String path) => Route(path);

shared final annotation class Route(shared String path)
		satisfies OptionalAnnotation<Route, Annotated> {}
