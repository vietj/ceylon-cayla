shared class RouteMatch<T>(T _target, String[] _path, Map<String, String> _params) {
	
	shared actual String string => "RouteMatch";
	shared T target => _target;
	shared String[] path => _path;
	shared Map<String, String> params => _params;
	
	shared RouteMatch<O> as<O>(O other) {
		return RouteMatch<O>(other, _path, _params);
	}
}