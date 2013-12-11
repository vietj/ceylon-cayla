import cayla {
    route,
    Handler,
    Application,
    ok
}

import org.rythmengine {
    Rythm
}

route("/")
class Index(shared String? name = null) 
        extends Handler() {
    handle()
        => ok {
            Rythm.render(
                """@args String action
                   @args String name
                   <!DOCTYPE html>
                   <html>
                     <head>
                       <title>Hello World</title>
                       <link rel='stylesheet'
                            href='//www.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap.min.css'>
                     </head>
                     <body style='padding-top: 32px'>
                       <div class='container'>
                         <div class='hero-unit'>
                           <div class='center'><h1>Hello @name</h1></div>
                         </div>
                         <div class='offset4 span4'>
                           <form class='form-signin' action='@action' method='get'>
                             <div class='control-group'>
                               <div class='controls'>
                                 <input type='text' name='name' placeholder='Your Name'>
                               </div>  
                             </div>
                             <div class='control-group'>
                               <div class='controls'> 
                                 <button type='submit' class='btn btn-default'>
                                   Say Hello
                                 </button>
                               </div>
                             </div>
                           </form>
                         </div>
                       </div>
                     </body>
                   </html>""", 
            Index(), 
            name else "World"); 
        };
}

shared void run() {
    Application(`package examples.cayla.rythm`).run();
}