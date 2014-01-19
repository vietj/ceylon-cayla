# Cayla 0.2.6 : a web framework for Ceylon

Provides a programming model for the Ceylon language and make good use of Ceylon.

Build on top of
* Vert.x
* Promises

Current deployed version 0.2.6, read the module [Documentation](https://modules.ceylon-lang.org/repo/1/io/cayla/web/0.2.6/module-doc/index.html).

# Building current master

    ceylon compile cayla

# Testing current master

    ceylon compile --source test-source test.cayla
    ceylon run test.cayla/0.2.6

# Example

    ceylon compile --source=examples-source examples.cayla

## Hello World

A simple page with a form.

run with

    ceylon run --run=examples.cayla.helloworld.run examples.cayla/1.0.0

## Chuck Norris

Display a Chuck Norris fact retrieved from a Rest service.

- Shows Promise API
- Uses Vert.x async non blocking Http Client

run with

    ceylon run --run=examples.cayla.chucknorris.run examples.cayla/1.0.0


## Parameters

Some examples showing http request routing with parameters.

run with


    ceylon run --run=examples.cayla.parameters.run examples.cayla/1.0.0
    
## Proxy

A simple web proxy.

- Shows Promise API
- Uses Vert.x async non blocking Http Client

run with

    ceylon run --run=examples.cayla.proxy.run examples.cayla/1.0.0
    
## Rythm Engine

Example of Rythm engine integration

run with

    ceylon run --run=examples.cayla.rythm.run examples.cayla/1.0.0
