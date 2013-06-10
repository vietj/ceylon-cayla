import cayla.interop { InnerClassReflector }
import ceylon.collection { HashMap }
import java.lang { arrays, String_=String }

shared class ControllerDescriptor<A = Application, C = Controller>(InnerClassReflector<A, C> reflector)
	given A satisfies Application
	given C satisfies Controller {

	shared C? create({<String->String>*} params = {}) {
	    [{String*},{String*}] tmp = params.fold([{},{}], ([{String*},{String*}] partial, String->String elem) =>
	    	[{elem.key,*partial.first},{elem.item,*partial.rest.first}]);
		C? controller = reflector.create(arrays.toJavaStringArray(tmp.first), arrays.toJavaStringArray(tmp.rest.first));
		return controller;
	}
	
	shared String? route {
		return reflector.getAnnotation("route");
	}
	
	shared Boolean isInstance(Controller controller) {
		return reflector.isInstance(controller);
	}

	shared Map<String, String> getParameters(C controller) {
		value parameters_ = reflector.getParameters(controller);
		value iterator_ = parameters_.keySet().iterator();
		HashMap<String, String> parameters = HashMap<String, String>();
		while (iterator_.hasNext()) {
			String_ name = iterator_.next();
			value val = parameters_.get(name);
			parameters.put(name.string, val.string);
		}
		return parameters;
	}
}