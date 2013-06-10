import ceylon.test { ... }

doc "Run the module `test.cayla`."
void run() {
    
  suite("cayla", "Pattern" -> patternTests);
  suite("cayla", "Controller descriptor" -> controllerDescriptorTests);
  suite("cayla", "Router" -> routerTests);
  suite("cayla", "Controller descriptor route" -> controllerDescriptorRouteTests);

}