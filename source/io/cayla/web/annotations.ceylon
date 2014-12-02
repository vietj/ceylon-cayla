
"Annotate a controller to define its route"
shared annotation Route route(String path, String* methods) => Route(path);

"A route configuration"
shared final annotation class Route("The route path" shared String path)
		satisfies OptionalAnnotation<Route, Annotated> {
    shared actual String string => "Route(``path``)";
}

"An annotation to declare a blocking behavior"
shared annotation Blocking blocking() => Blocking();

"The blocking annotation class"
shared final annotation class Blocking()
    satisfies OptionalAnnotation<Blocking, Annotated> {
}

"Declares a binding to the GET http method"
shared annotation Get get() => Get();

"Http GET"
shared final annotation class Get()
		satisfies OptionalAnnotation<Get, Annotated> {
}

"Declares a binding to the PUT http method"
shared annotation Put put() => Put();

"Http PUT"
shared final annotation class Put()
		satisfies OptionalAnnotation<Put, Annotated> {}

"Declares a binding to the POST http method"
shared annotation Post post() => Post();

"Http POST"
shared final annotation class Post()
		satisfies OptionalAnnotation<Post, Annotated> {}

"Declares a binding to the TRACE http method"
shared annotation Trace trace() => Trace();

"Http TRACE"
shared final annotation class Trace()
		satisfies OptionalAnnotation<Trace, Annotated> {}

"Declares a binding to the HEAD http method"
shared annotation Head head() => Head();

"Http HEAD"
shared final annotation class Head()
		satisfies OptionalAnnotation<Head, Annotated> {}

"Declares a binding to the DELETE http method"
shared annotation Delete delete() => Delete();

"Http DELETE"
shared final annotation class Delete()
		satisfies OptionalAnnotation<Delete, Annotated> {}

"Declares a binding to the OPTIONS http method"
shared annotation Options options() => Options();

"Http OPTIONS"
shared final annotation class Options()
		satisfies OptionalAnnotation<Options, Annotated> {}

"Declares a binding to the CONNECT http method"
shared annotation Connect connect() => Connect();

"Http CONNECT"
shared final annotation class Connect()
		satisfies OptionalAnnotation<Connect, Annotated> {}
