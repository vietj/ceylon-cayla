
"Annotate a controller to define its route"
shared annotation Route route(String path, String* methods) => Route(path);

"A route configuration"
shared final annotation class Route("The route path" shared String path)
		satisfies OptionalAnnotation<Route, Annotated> {}

shared annotation Get get() => Get();

shared final annotation class Get()
		satisfies OptionalAnnotation<Get, Annotated> {}

shared annotation Put put() => Put();

shared final annotation class Put()
		satisfies OptionalAnnotation<Put, Annotated> {}

shared annotation Post post() => Post();

shared final annotation class Post()
		satisfies OptionalAnnotation<Post, Annotated> {}

shared annotation Trace trace() => Trace();

shared final annotation class Trace()
		satisfies OptionalAnnotation<Trace, Annotated> {}

shared annotation Head head() => Head();

shared final annotation class Head()
		satisfies OptionalAnnotation<Head, Annotated> {}

shared annotation Delete delete() => Delete();

shared final annotation class Delete()
		satisfies OptionalAnnotation<Delete, Annotated> {}

shared annotation Options options() => Options();

shared final annotation class Options()
		satisfies OptionalAnnotation<Options, Annotated> {}

shared annotation Connect connect() => Connect();

shared final annotation class Connect()
		satisfies OptionalAnnotation<Connect, Annotated> {}
