# Cayla : a web framework for Ceylon

Provides a programming model for the Ceylon language and make good use of Ceylon.

Build on top of
* Vert.x
* Promises

Current deployed version 0.2.1, read the module [Documentation](https://modules.ceylon-lang.org/repo/1/cayla/0.2.1).

# Application

A web application is created in a few steps:

    value application = Application(`package myapplication`);
    Promise<Runtime> runtime = application.start();
    runtime.always((Runtime|Exception arg) => print(arg is Runtime then "started" else "failed: ``arg.string``"));
    process.readLine();
    runtime.then_((Runtime runtime) => runtime.stop()).then_((Anything anyting) => print("stopped"));

# Controllers

Controllers are classes in your application that extends the Controller class. A controller handle a request with its `handle` method.

Controllers use the `route` annotation and are parameterized by `String` parameters, each parameter must be a shared parameter:

    route "/"
    shared class MyController(shared String color) extends Controller() { ... }

Controller urls can be easily constructed via the `string` method.

    value url = MyController("red").string;

Request handling is implemented via the `handle` method:

    shared class MyController() extends Controller() {
      shared actual default Response handle() => ok().body("<html><body>Hello World</body></html>");
    }

## Top level controllers

    route("/")
    shared class Index() {
      shared actual default Response handle() => ok().body("<html><body>Hello World</body></html>");
    }

## Nested controllers

    shared object controllers {
      route("/")
      shared class Index() {
        shared actual default Response handle() => ok().body("<html><body>Hello World</body></html>");
      }
    }
