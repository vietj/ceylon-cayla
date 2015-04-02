"""Application configuration, for now quite simple : [[hostName]] and [[port]].
   """
shared class Config(
    "The http server host name, null means all available interfaces"
    shared String? hostName = null,
    "The http server port"
    shared Integer port = 8080,
    "If your application is reacheable via a host name that differs from where we listen for HTTP, 
     if you have a proxy or load-balancer for example, then this will be used to generate absolute URIs"
    shared String? externalHostName = null,
    "If your application is reacheable via a port number that differs from where we listen for HTTP, 
     if you have a proxy or load-balancer for example, then this will be used to generate absolute URIs"
    shared Integer? externalPort = null) {
    
}