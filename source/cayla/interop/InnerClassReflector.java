package cayla.interop;

import java.lang.reflect.Method;
import java.lang.reflect.Constructor;
import java.util.Arrays;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.List;

import com.redhat.ceylon.compiler.java.metadata.Annotations;
import com.redhat.ceylon.compiler.java.metadata.Annotation;
import com.redhat.ceylon.compiler.java.metadata.Name;

public class InnerClassReflector<C, T> {
	
	private final C container;
	private final Class<? extends T> type;
	private final ArrayList<Factory> factories;
	private final HashMap<String, String[]> annotationMap;
	private final String[] names;
	
	public InnerClassReflector(C container, Class<? extends T> type) {
		
		//
		HashMap<String, String[]> annotationMap = new HashMap<String, String[]>();
		Annotations annotations = type.getAnnotation(Annotations.class);
		for (Annotation annotation : annotations.value()) {
			annotationMap.put(annotation.value(), annotation.arguments());
		}
		
		// Find parameter names
		String[] names = null;
		for (Constructor<?> ctor : type.getDeclaredConstructors()) {
			java.lang.annotation.Annotation[][] parametersAnnotations = ctor.getParameterAnnotations();
			int length = parametersAnnotations.length;
			if (names != null) {
				throw new AssertionError("Class has more than one constructor");
			} else {
				ArrayList<String> tmp = new ArrayList<String>();
				for (int i = 0;i < length;i++) {
					for (java.lang.annotation.Annotation parameterAnnotation : parametersAnnotations[i]) {
						if (parameterAnnotation instanceof Name) {
							Name nameAnnotation = (Name)parameterAnnotation;
							String name = nameAnnotation.value();
							if (name != null) {
								tmp.add(name);
							}
						}
					}
				}
				names = tmp.toArray(new String[tmp.size()]);
			}
		}
		if (names == null) {
			throw new AssertionError("Could not retrieve parameter names");
		}
		
		// Find all container factories
		ArrayList<Factory> ctorRefs = new ArrayList<Factory>();
		for (Method method : container.getClass().getDeclaredMethods()) {
			if (method.getReturnType().equals(type) && method.getName().equals(type.getSimpleName() + "$new")) {
				List<Class<?>> parameterTypes = Arrays.asList(method.getParameterTypes());
				for (Class<?> parameterType : parameterTypes) {
					if (parameterType.equals(String.class) || parameterType.equals(ceylon.language.String.class)) {
						// Ok
					} else {
						throw new IllegalArgumentException("Can only handle parameters of type string and not " + parameterType.getName());
					}
				}
				method.setAccessible(true);
				ctorRefs.add(new Factory(
						method, 
						parameterTypes.toArray(new Class[parameterTypes.size()]), 
						Arrays.copyOf(names, parameterTypes.size())));
			}
		}
		
		//
		this.container = container;
		this.type = type;
		this.names = names;
		this.factories = ctorRefs;
		this.annotationMap = annotationMap;
	}
	
	public String getAnnotation(String annotationName) {
		String[] annotationValue = annotationMap.get(annotationName);
		if (annotationValue != null && annotationValue.length > 0) {
			return annotationValue[0];
		} else {
			return null;
		}
	}
	
	public boolean isInstance(Object o) {
		return type.isInstance(o);
	}
	
	public HashMap<String, String> getParameters(T o) {
		HashMap<String, String> parameters = new HashMap<>();
		for (String name : names) {
			try {
				Method getter = type.getMethod("get" + Character.toUpperCase(name.charAt(0)) + name.substring(1));
				Object value = (Object)getter.invoke(o);
				if (value instanceof String) {
					parameters.put(name,  (String)value);
				} else if (value instanceof ceylon.language.String) {
					parameters.put(name,  ((ceylon.language.String)value).value);
				}
			} catch (Exception e) {
				e.printStackTrace();
				// ?
			}
		}
		return parameters;
	}
	
	public T create(String[] names, String[] values) {
		
		// Build a map for working
		HashMap<String, String> params = new HashMap<String, String>();
		for (int i = 0;i < names.length;i++) {
			params.put(names[i], values[i]);
		}
		
		// Find a constructor
		Factory current = null;
		out:
		for (Factory factory : factories) {
			for (int i = 0;i < factory.names.length;i++) {
				String name = factory.names[i];
				if (!params.containsKey(name) && factory.types[i].equals(String.class)) {
					 continue out;
				}
			}
			if (current == null) {
				current = factory;
			} else if (factory.names.length > current.names.length) {
				current = factory;
			}
		}
		
		//
		if (current != null) {
			Object[] args = new Object[current.names.length];
			for (int i = 0;i < current.names.length;i++) {
				Class<?> type = current.types[i];
				String v = params.get(current.names[i]);
				if (type.isAssignableFrom(String.class)) {
					if (v == null) {
						throw new UnsupportedOperationException("Not yet handled");
					}
					args[i] = v;
				} else if (type.isAssignableFrom(ceylon.language.String.class)) {
					args[i] = ceylon.language.String.instance(v);
				}
			}
			try {
				Object instance = current.method.invoke(container, args);
				// System.out.println("Created controller with " + params);
				return type.cast(instance);
			} catch (Exception e) {
				System.out.println("Could not instantiate controller with " + params);
				e.printStackTrace();
			}
		} else {
			// System.out.println("No controller found for " + params);
		}
		return null;
	}
	
	public String toString() {
		return "InnerClassReflector[type=" + type.getName() + ",factories=" + factories + "]"; 
	}
	
	private class Factory {
		
		private final Method method;
		private final Class<?>[] types;
		private final String[] names;
		
		public Factory(Method ctor, Class<?>[] types, String[] names) {
			this.method = ctor;
			this.types = types;
			this.names = names;
		}
		
		public String toString() {
			StringBuilder sb = new StringBuilder();
			sb.append("Factory[");
			sb.append("method=").append(method);
			sb.append(",names=").append(Arrays.asList(names));
			sb.append("]");
			return sb.toString(); 
		}
	}
	
	public static <C, T> InnerClassReflector<C, T>[] findControllers(C container) {
		Class<T> controllerType;
		try {
			// Really nasty cast but this makes it much easier from Ceylon side
			@SuppressWarnings("unchecked")
			Class<T> tmp = controllerType = (Class<T>)container.getClass().getClassLoader().loadClass("cayla.Controller");
			controllerType = tmp;
		} catch (Exception e) {
			throw new AssertionError("Could not find controller super type", e);
		}
		return find(container, controllerType);
	}

	/**
	 * Find the inner class of the specified container that extends the given super class.
	 * 
	 * @param container the outer instance container
	 * @param superClassMatch the super class match
	 * @return
	 */
	public static <C, T> InnerClassReflector<C, T>[] find(C container, Class<T> superClassMatch) {
		@SuppressWarnings("unchecked")
		Class<C> type = (Class<C>)container.getClass();
		return _find(container, type, superClassMatch);
	}
	
	private static <C, T> InnerClassReflector<C, T>[] _find(C container, Class<C> containerType, Class<T> superClassMatch) {
		ArrayList<InnerClassReflector<C, T>> reflectors = new ArrayList<InnerClassReflector<C, T>>();
		for (Class<?> declaredClass : containerType.getDeclaredClasses()) {
			if (superClassMatch.isAssignableFrom(declaredClass)) {
				Class<? extends T> subclass = declaredClass.asSubclass(superClassMatch);
				InnerClassReflector<C, T> reflector = new InnerClassReflector<C, T>(container, subclass);
				reflectors.add(reflector);
			}
		}
		reflectors.toArray();
		InnerClassReflector<C, T>[] tmp = new InnerClassReflector[reflectors.size()];
		reflectors.toArray(tmp);
		return tmp;
	}
}
