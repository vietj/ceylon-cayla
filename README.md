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

## Hello World

    ceylon compile --source=examples-sources examples.cayla.helloworld
    ceylon run examples.cayla.helloworld/1.0.0

## Parameters

    ceylon compile --source=examples-sources examples.cayla.parameters
    ceylon run examples.cayla.parameters/1.0.0
    
## Proxy

    ceylon compile --source=examples-sources examples.cayla.proxy
    ceylon run examples.cayla.proxy/1.0.0
    
## Rythm Engine

    ceylon compile --source=examples-sources examples.cayla.rythm
    ceylon run examples.cayla.rythm/1.0.0
