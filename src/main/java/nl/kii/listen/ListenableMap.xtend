package nl.kii.listen

import java.util.HashMap
import java.util.Map
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1
import rx.Observable
import rx.subjects.Subject

import static nl.kii.listen.ChangeType.*

import static extension nl.kii.rx.StreamExtensions.*

class ListenableMap<K, V> extends HashMap<K, V> implements Listenable<Change<K, V>> {
	
	// MAKE THE LIST LISTENABLE

	val publisher = new Publisher<Change<K, V>>

	override onChange(Procedure1<Change<K, V>> listener) {
		publisher.onChange(listener)
	}
	
	def private of(ChangeType type, V value, K key) {
		publisher.publishChange(new Change<K, V>(type, value, key, this.size))
	}
	
	def Observable<Change<K, V>> stream() {
		val Subject<Change<K, V>, Change<K, V>> stream = newStream
		onChange [ stream << it ]
		stream
	}
	
	// WRAP ALL METHODS THAT MODIFY THE LIST TO FIRE A CHANGE EVENT
	
	override V put(K key, V value) {
		val known = this.containsKey(key)
		super.put(key, value) => [ 
			if(known) UPDATE.of(value, key)
			else ADD.of(value, key)
		]
	}
	
	override V remove(Object key) {
		val value = this.get(key)
		super.remove(key) => [ if(value != null) REMOVE.of(value, null)]
	}
	
	override putAll(Map<? extends K, ? extends V> m) {
		m.keySet.forEach [ if(this.containsKey(it)) ADD.of(this.get(it), it) ]
		super.putAll(m)
	}
	
	override clear() {
		super.clear
		CLEAR.of(null, null)
	}
	
}
