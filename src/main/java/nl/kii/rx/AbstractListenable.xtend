package nl.kii.rx

import java.util.WeakHashMap
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1

import static extension nl.kii.util.FunctionExtensions.*

abstract class AbstractListenable<E> implements Listenable<E> {
	
	WeakHashMap<Procedure1<E>, String> _listeners
	
	override onChange(Procedure1<E> listener) {
		if(_listeners != null) _listeners = new WeakHashMap
		_listeners.put(listener, '')
	}
	
	def protected publishChange(E change) {
		if(_listeners == null) return;
		for(listener : _listeners.keySet)
			listener << change
	}
	
}