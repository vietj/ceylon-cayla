"""Application configuration, for now quite simple : [[hostName]] and [[port]].
   """
shared class Config(
    "The http server host name, null means all available interfaces"
    shared String? hostName = null,
    "The http server port"
    shared Integer port = 8080,
    "The application run mode"
    shared RunMode runMode = prod) {
    
}