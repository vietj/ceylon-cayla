# Cayla : a web framework for Ceylon

Provides a programming model for the Ceylon language and make good use of Ceylon.

Build on top of
* Vert.x
* Promises

Current deployed version 0.2.2, read the module [Documentation](https://modules.ceylon-lang.org/repo/1/cayla/0.2.2).

# Building

    ceylon compile cayla

# Testing

    ceylon compile --source test-source test.cayla
    ceylon run test.cayla/0.2.2

# Example

    ceylon compile --source=examples-source examples.cayla

## Hello World

    ceylon run --run=examples.cayla.helloworld.run examples.cayla/1.0.0

## Parameters

    ceylon run --run=examples.cayla.parameters.run examples.cayla/1.0.0
    
## Proxy

    ceylon run --run=examples.cayla.proxy.run examples.cayla/1.0.0
    
## Rythm Engine

    ceylon run --run=examples.cayla.rythm.run examples.cayla/1.0.0
