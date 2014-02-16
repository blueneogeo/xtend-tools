package nl.kii.listen

import java.util.Map
import java.util.WeakHashMap
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1

import static extension nl.kii.util.FunctionExtensions.*
import java.util.HashMap

class Publisher<E> implements Listenable<E> {
	
	val public boolean usesWeakReferences
	
	new() {	this(false) }
	new(boolean usesWeakReferences) { this.usesWeakReferences = usesWeakReferences }
	
	@Property boolean isPublishing = true
	
	Map<Procedure1<E>, String> _listeners
	
	override onChange(Procedure1<E> listener) {
		// FIX: use weak references or we get a memory problem...
		// however, currently it seems to let go too soon!
		if(_listeners == null) 
			_listeners = if(usesWeakReferences) 
				new WeakHashMap 
				else new HashMap
		_listeners.put(listener, '')
	}
	
	def publish(E change) {
		if(_listeners == null || !isPublishing) return;
		for(listener : _listeners.keySet)
			listener << change
	}
	
}
