import ceylon.net.uri { Path, Query, Parameter, PathSegment, parse }
import ceylon.collection { HashMap }

"A router"
shared class Router(shared [Router,Mount]? rel = null)
	satisfies Correspondence<Integer, Router> & Iterable<Router, Nothing> {
	
	{String*} segmentsOf({String*}|String path) {
		switch (path)
		case (is {String*}) { return path; }
		case (is String) { return path.split('/'.equals).filter((String elem) => !elem.empty); }
	}

	shared {String*} segmentsOf2(Path|String path) {
		switch (path)
		case (is Path) { return path.segments.map((PathSegment elem) => elem.name).filter((String elem) => !elem.empty); }
		case (is String) { return segmentsOf2(parse(path).path); }
	}

	variable [Mount,Router][] children = [];
	variable Boolean terminator = false;
	
	shared Router addRoute({String*}|String path) {
		{String*} a = segmentsOf(path);
		{Mount*} m = a.map((String elem) => elem.startsWith(":") then Expression(elem.rest) else Segment(elem));
		return _addRoute(m);
	}

	Router _addRoute({Mount*} path) {
		if (exists segment = path.first) {
			[Mount,Router]? previous = children.find(([Mount, Router] elem) => elem.first.equals(segment));
			Router child;
			if (exists previous) {
				child = previous.rest.first;
			} else {
				// Double creation
				child = Router([this,segment]);
				children = [[segment,child],*children];
			}
			return child._addRoute(path.rest);
		} else {
			// Should set terminator to true
			terminator = true;
			return this;
		}
	}
	
	shared actual Router? get(Integer key) {
		if (exists child = children.get(children.size - key - 1)) {
			return child.rest.first;
		} else {
			return null;
		}
	}
	
	shared Router? parent {
		if (exists rel) {
			return rel.first;
		} else {
			return null;
		}
	}
	
	shared Router? sibling {
		Integer? index = getIndex();
		if (exists index, exists rel) {
			return rel.first.get(index + 1);
		} else {
			return null;
		}
	}
	
	"Render the path with the specified parameters, if a parameter is missing rendering cannot occur and null is returned"
	shared [Path,Query]? path({<String->String>*} parameters) {
		value parameterMap = HashMap<String, String>(parameters);
		if (exists path = path_(parameterMap)) {
			Query query = Query();
			for (parameter in parameterMap) {
				query.add(Parameter(parameter.key, parameter.item));
			}
			return [path,query];
		} else {
			return null;
		}
	}

	Path? path_(HashMap<String, String> parameters) {
		if (exists rel) {
			if (exists path = rel[0].path_(parameters)) {
				Mount mount = rel[1];
				switch (mount)
				case (is Segment) {
					path.add(mount.val);
				}
				case (is Expression) {
					if (exists val = parameters.remove(mount.name)) {
						path.add(val);
					} else {
						return null;
					}
				}
				return path;
			} else {
				return null;
			}
		} else {
			return Path(true);
		}
	}
	
	String foo() {
		if (exists rel) {
			Router parent = rel.first;
			variable String path = parent.foo();
			if (!path.endsWith("/")) {
				path += "/";
			}
			return path + rel.rest.first.string;
		} else {
			return "/";
		}
	}

	"Return the path as a declaration"
	shared actual String string => foo();

	class RouterIterator(Router router) satisfies Iterator<Router> {
		variable Router|Finished current = router;
		shared actual Router|Finished next() {
			Router|Finished foo = current;
			if (is Router foo) {
				[Router,Mount]? abc = foo.rel;
				if (exists abc) {
					current = abc[0];
				} else {
					current = finished;
				}
			}
			return foo;
		}
	}

	shared actual Iterator<Router> iterator() => RouterIterator(this); 

	shared Integer? getIndex() {
		if (exists rel) {
			Router match = this;
			Router parent = rel.first;
			<Integer->[Mount, Router]>? found = parent.children.indexed.find(
				(Integer->[Mount, Router] elem) => elem.item.rest.first == match);
			if (exists found) {
				return parent.children.size - found.key - 1;
			} else {
				throw Exception("Should not be possible for ``foo()``");
			}
		} else {
			return null;
		}
	}
	
	shared RouteMatch<Router>? resolve(<String|Path> path) {
		return _match(segmentsOf2(path), []);
	}

	shared RouteMatch<Router>? _match({String*} path, [Mount,String][] matches) {
		if (exists segment = path.first) {
			for (entry in children.reversed) {
				Mount mount = entry.first;
				if (mount.match(segment)) {
					Router child = entry.rest.first;
					if (exists tmp = child._match(path.rest, [[mount,segment],*matches])) {
						return tmp;
					}
				}
			}
		} else if (terminator) {
			{<String->String>*} foo({<String->String>*} partial, [Mount, String] elem) {
				Mount mount = elem.first;
				if (is Expression mount) {
					return {mount.name->elem.rest.first,*partial};
				} else {
					return partial;
				}
			}
			LazyMap<String, String> params = LazyMap(matches.fold({}, foo));
			String[] p = matches.fold([], (String[] partial, [Mount, String] elem) => [elem.rest.first,*partial]);
			return RouteMatch(this, p, params);
		}
		return null;
	}
	
	
}