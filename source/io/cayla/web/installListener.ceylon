import ceylon.promise {
  addGlobalExecutionListener
}
object installListener {
  addGlobalExecutionListener {
    Anything(Anything()) onChild() {
      RequestContext? previousCtx = current.get;
      return void(Anything() callback) {
        RequestContext? currentCtx = current.get;
        if (exists currentCtx) {
          callback();
        } else {
          current.set(previousCtx);
          try {
            callback();
          } finally {
            current.set(null);
          }
        }
      };
    }
  };
  
}