"Annotate a controller to define its route"
shared annotation Route route(String path) => Route(path);

"A route configuration"
shared final annotation class Route("The route path" shared String path)
		satisfies OptionalAnnotation<Route, Annotated> {}
