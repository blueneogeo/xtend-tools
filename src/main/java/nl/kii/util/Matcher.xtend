package nl.kii.util
import static extension nl.kii.util.OptExtensions.*

interface Matcher<I, T> {
	
	def Opt<T> match(I instance)
	
}

class InstanceMatcher<T> implements Matcher<Object, T> {
	
	Class<? extends T>[] types
	
	new(Class<? extends T>... types) {
		this.types = types
	}
	
	override match(Object instance) {
		for(type : types) {
			if(type.isAssignableFrom(type)) 
				return some(instance as T)
		}
		none
	}
	
}
