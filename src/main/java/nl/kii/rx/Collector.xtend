package nl.kii.rx

import java.util.Collection
import java.util.concurrent.ConcurrentLinkedDeque
import org.eclipse.xtext.xbase.lib.Functions
import rx.Observer
import rx.subjects.PublishSubject

import static extension nl.kii.rx.StreamExtensions.*

/**
 * Collects a list of values and gives you a signal when it's done.
 * <p>
 * Much of its functionality can also be done by a .toList method call. However,
 * this acts as an ObservedValue as well, giving you get the intermediary
 * result in progress by calling the get() or apply() method.
 * <p>
 * This feature makes it practical for cases where you want to monitor
 * a stream in progress.
 * <p>
 * You can listen to the collector by calling getStream. This stream will give
 * you a list of collected values when onCompleted gets called.
 * <p>
 * To prevent the collector obsorbing too many items, you can set a max capacity.
 * When an item comes in and it would cause the collector to go over capacity,
 * it will throw an exception onto its stream.
 */
class Collector<T> implements Observer<T>, Functions.Function0<Collection<T>> {

	val int maxSize
	val Collection<T> list = new ConcurrentLinkedDeque
	val PublishSubject<Collection<T>> stream 
	val (Collection<T>)=>void onFinish

	new() { this(null, -1) }

	new(int maxSize) { this(null, maxSize) }

	new((Collection<T>)=>void onFinish) { 
		this(onFinish, -1)
	}
	
	new((Collection<T>)=>void onFinish, int maxSize) { 
		this.maxSize = maxSize
		this.onFinish = onFinish
		stream = newStream
	}
	
	override onCompleted() {
		stream.apply(list)
		if(onFinish != null) onFinish.apply(list)
	}
	
	override onError(Throwable e) {
		stream.error(e)
	}
	
	override onNext(T value) {
		if(maxSize == -1 || list.size < maxSize) list.add(value)
		else stream.error(new Exception('''Collector could not collect «value», at size limit of «maxSize».'''))
	}
	
	override apply() {
		list
	}
	
	def get() {
		list
	}
	
	def getStream() {
		stream
	}
	
	def clear() {
		list.clear
	}

	def isEmpty() {
		list.empty
	}
	
}
