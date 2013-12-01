package nl.kii.listen

import java.util.ArrayList
import java.util.Collection
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1
import rx.Observable
import rx.subjects.Subject

import static nl.kii.listen.ChangeType.*

import static extension nl.kii.rx.StreamExtensions.*

class ListenableList<E> extends ArrayList<E> implements Listenable<Change<Integer, E>> {

	// MAKE THE LIST LISTENABLE

	val publisher = new Publisher<Change<Integer, E>>

	override onChange(Procedure1<Change<Integer, E>> listener) {
		publisher.onChange(listener)
	}
	
	def private of(ChangeType type, E value, int position) {
		publisher.publishChange(new Change<Integer, E>(type, value, position, this.size))
	}
	
	def Observable<Change<Integer, E>> stream() {
		val Subject<Change<Integer, E>, Change<Integer, E>> stream = newStream
		onChange [ stream << it ]
		stream
	}
	
	// WRAP ALL METHODS THAT MODIFY THE LIST TO FIRE A CHANGE EVENT
		

	override E set(int index, E element) {
		super.set(index, element) => [ UPDATE.of(element, index) ]
	}
	
	override boolean add(E e) {
		super.add(e) => [ if(it) ADD.of(e, this.size - 1) ]
	}
	
	override void add(int index, E element) {
		super.add(index, element)
		ADD.of(element, index)
	}
	
	override E remove(int index) {
		super.remove(index) => [ REMOVE.of(it, index) ]
	}
	
	override boolean remove(Object o) {
		val i = indexOf(o)
		super.remove(o) => [ if(it) REMOVE.of(o as E, i) ]
	}
	
	override void clear() {
		super.clear
		CLEAR.of(null, 0)
	}
	
	override boolean addAll(Collection<? extends E> c) {
		super.addAll(c) => [ if(it) c.forEach [ ADD.of(it, -1) ] ]
	}
	
	@Deprecated
	override boolean addAll(int index, Collection<? extends E> c) {
		// FIX: position incorrect
		super.addAll(index, c) => [ if(it) c.forEach [ ADD.of(it, -1) ]]
	}
	
	@Deprecated
	override void removeRange(int fromIndex, int toIndex) {
		super.removeRange(fromIndex, toIndex)
	}
	
	@Deprecated
	override boolean removeAll(Collection<?> c) {
		super.removeAll(c)
	}
	
	@Deprecated
	override boolean retainAll(Collection<?> c) {
		super.removeAll(c)
	}
	
}
