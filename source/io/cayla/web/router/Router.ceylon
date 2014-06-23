import ceylon.collection { HashSet, HashMap }

shared alias Node => [Mount, Router];
shared alias Path => {String*}|String;

{String*} unwrap(Path path) {
    switch (path)
    case (is {String*}) { return path; }
    case (is String) { return path.split('/'.equals).filter((String elem) => !elem.empty); }
}

shared class Router(
    shared Node? parent = null,
    variable Node[] children = [], 
    variable Boolean terminator = false)
    satisfies Correspondence<Integer, Router> {
    
    "Mount a path to the router"
    shared Router mount(Path path) {
        Mount createMount(String s) {
            if (s.startsWith(":")) {
                return Expression(s.rest);
            } else if (s.startsWith("*")) {
                return Any(s.rest);
            } else if (s.startsWith("+")) {
                return OneOrMore(s.rest);
            } else {
                return Segment(s);
            }
        }
        {Mount*} mounts = unwrap(path).map(createMount);
        return add(mounts);
    }
    
    Router add({Mount*} mounts) {
        if (exists mount = mounts.first) {
            [Mount,Router]? previous = children.find(([Mount, Router] elem) => elem.first.equals(mount));
            Router child;
            if (exists previous) {
                child = previous.rest.first;
            } else {
                // Double creation
                child = Router([mount, this]);
                children = [[mount,child],*children];
            }
            return child.add(mounts.rest);
        } else {
            // Should set terminator to true
            terminator = true;
            return this;
        }
    }
    
    "Correspondence implementation"
    shared actual Router? get(Integer key) {
        if (exists child = children.get(children.size - key - 1)) {
            return child.rest.first;
        } else {
            return null;
        }
    }

    "Build the string representation"
    String buildString() {
        if (exists parent) {
            Router router = parent[1];
            variable String path = router.buildString();
            if (!path.endsWith("/")) {
                path += "/";
            }
            return path + parent[0].string;
        } else {
            return "/";
        }
    }
    
    "Return the path as a declaration"
    shared actual String string => buildString();
    
    "Resolve a possible match for a path"
    shared RouteMatch<Router>? match(Path path) {
        return matches(unwrap(path)).first;
    }
    
    "Resolve all possibles matches for a path"
    shared {RouteMatch<Router>*} matches(Path path) {
        return resolve(unwrap(path), {});
    }
    
    "A match when resolving a path"
    alias ResolveMatch => [Mount,{String*}];

    "Resolve the route matches recursively"
    {RouteMatch<Router>*} resolve({String*} path, {ResolveMatch*} resolved) {
        
        // Find all solutions for the children
        {RouteMatch<Router>*} resolutions = {
            for (child in children)
                for (match in child[0].match(path))
                    for (found in child[1].resolve(path.skip(match),{[child[0],path.take(match)],*resolved}))
                        found
        };
        
        // If this is a terminator then
        if (terminator && path.size == 0) {
            
            // We have a match
            // -> compute the parameter map (note this could be done lazily too)
            // -> compute the path
            {<String->String>*} matchParameters = {
                for (match in resolved)
                    if (exists matchParameter = match[0].foo(match[1])) 
                        matchParameter
            };
            
            // Compute path
            // need to spread and reverse...
            String[] matchPath = [
                for (match in [*resolved].reversed)
                    for (atom in match[1])
                        atom
            ];
            value match = RouteMatch(this, matchPath, HashMap{ entries = matchParameters; });
            
            // Return the previous solutions + this match
            return concatenate(resolutions, {match});
        } else {
            // Otherwise returns what we found above
            return resolutions;
        }
    }
    
    alias PathMatch => [{String*},{<String->String>*}];
    
    shared [{String*},{<String->String>*}]? path(Map<String, String>|{<String->String>*} parameters = {}) {
        PathMatch? ret;
        switch (parameters)
        case (is Map<String, String>) {
            ret = path_(parameters, emptySet);
        } else {
            ret = path_(HashMap{ entries = parameters; }, emptySet);
        }
        // this makes a bug
        // value first = ret.first;
        // [ceylon-run] ceylon.language.AssertionException "Assertion failed
        // [ceylon-run]    violated is Absent|Value first"
        // [ceylon-run]    at ceylon.language.first_.first(first.ceylon:12)
        // [ceylon-run]    at ceylon.language.Iterable$impl.getFirst(Iterable.ceylon:133)
        // [ceylon-run]    at com.redhat.ceylon.compiler.java.language.AbstractIterable.getFirst(AbstractIterable.java:110)
        // [ceylon-run]    at cayla.router2.Router.path$canonical$(Router.ceylon:143)
        // [ceylon-run]    at cayla.router2.Router.path(Router.ceylon)
        if (exists ret) {
            return [[*ret[0]].reversed, ret[1]];
        } else {
            return null;
        }
    }
    
    PathMatch? path_(Map<String, String> parameters, Set<String> pathParameters) {
        if (exists parent) {
            Set<String> nextPathParameters;
            {String*} segment;
            Mount mount = parent[0];
            switch (mount)
            case (is Segment) {
                segment = {mount.val};
                nextPathParameters = pathParameters;
            }
            case (is Expression) {
                if (exists val = parameters.get(mount.name)) {
                    segment = {val};
                    nextPathParameters = pathParameters.union(HashSet{mount.name});
                } else {
                    return null;
                }
            }
            case (is Any) {
                if (exists val = parameters.get(mount.name)) {
                    segment = unwrap(val);
                    nextPathParameters = pathParameters.union(HashSet{mount.name});
                } else {
                    return null;
                }
            }
            case (is OneOrMore) {
                if (exists val = parameters.get(mount.name), val.size > 0) {
                    segment = unwrap(val);
                    nextPathParameters = pathParameters.union(HashSet{mount.name});
                } else {
                    return null;
                }
            }
            if (exists parentMatch = parent[1].path_(parameters, nextPathParameters)) {
                value path = segment.fold(parentMatch[0], ({String*} partial, String elem) => {elem,*partial});
                return [path,parentMatch[1]];  
            } else {
                return null;
            }
        } else {
            value queryParameters = {
                for (parameter in parameters)
                    if (!pathParameters.contains(parameter.key))
                        parameter
            };
            return [{},queryParameters];
        }
    }
}