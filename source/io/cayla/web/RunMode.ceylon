"The application run mode"
shared abstract class RunMode() of dev | prod {}

shared object dev extends RunMode() {}
shared object prod extends RunMode() {}