import ceylon.collection { StringBuilder }

shared Node each(Iterable<Child> nodes) {
    object impl extends Node() {
        shared actual void render(StringBuilder buffer) {
            for (child in nodes) {
                dispatch(child, buffer);
            }
        }
    }
    return impl;
}

shared class WhenNode<Value>(Value() evaluation, variable [[Value,{Child*}]*] evals, variable {Child*} otherwiseChildren) extends Node() given Value satisfies Object {

    shared actual void render(StringBuilder to) {
        value v = evaluation();
        for (eval in evals) {
            if (eval[0].equals(v)) {
                for (child in eval[1]) {
                    dispatch(child, to);
                    return;
                }
            }
        }
        for (child in otherwiseChildren) {
            dispatch(child, to);
            return;
        }
    }
    
    shared WhenNode<Value> eval(Value to, {Child*} children) {
        evals = [[to,children], *evals];
        return this;
    }
    
    shared WhenNode<Value> otherwise({Child*} children) {
        this.otherwiseChildren = children;
        return this;
    }
    
    
}

shared WhenNode<Value> when<Value>(Value() val) given Value satisfies Object {
    return WhenNode<Value>(val, empty, {});
}
