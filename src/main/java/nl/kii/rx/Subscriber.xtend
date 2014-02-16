package nl.kii.rx

import java.util.List
import org.eclipse.xtext.xbase.lib.Procedures
import rx.Observable
import rx.Scheduler
import rx.Subscription
import rx.util.functions.Action0
import rx.util.functions.Action1

import static extension nl.kii.util.IterableExtensions.*
import static extension nl.kii.util.OptExtensions.*

/**
 * Helper class that helps build subscriptions. Lets you specify .each , .onFinish and .onError
 * handlers to respond to what happens on the stream. After you have assigned the handlers,
 * you need to create the subscription by calling .start(). If you do not do so, nothing will
 * get handled.
 * <p>
 * You can call the .each, .onFinish and .onError methods multiple times to assign multiple
 * handlers. The Subscriber keeps an internal list of handlers and assigns them all at once
 * when you start it.
 * <p>
 * In order not hog memory, the streams use PublishSubject. When you add a subscription to a 
 * PublishSubject, it will start streaming its contents. This means that adding a subscription
 * needs to be an atomic action. Subscriber lets you add handlers and then call .start() to
 * create a subscription and start the stream in that one step.
 * <p>
 * Subscriber also lets you set a scheduler using .scheduleOn(scheduler), so you can have the
 * processing of the stream run on a seperate asynchronous thread. 
 */
class Subscriber<T> {

	val Observable<T> stream
	
	val List<Procedures.Procedure1<T>> eachHandlers = newLinkedList
	val List<Procedures.Procedure1<Throwable>> errorHandlers = newLinkedList
	val List<Procedures.Procedure1<T>> finishHandlers = newLinkedList

	var Scheduler scheduler
	
	new(Observable<T> stream) {
		this.stream = stream
	}
	
	/** Set this handler to respond to new items being pushed onto the stream */
	def each((T)=>void onEach) {
		eachHandlers << onEach
		this
	}
	
	/** Set this handler if you want to be informed when the stream finishes/closes/completes */
	def onFinish((Object)=>void onFinish) {
		finishHandlers << onFinish
		this
	}
	
	/** Set this handler if you want to be informed when an error occurs */
	def onError((Throwable)=>void onError) {
		errorHandlers << onError
		this
	}
	
	/** Set this if you wish to schedule the subscription on a new thread */
	def scheduleOn(Scheduler scheduler) {
		this.scheduler = scheduler
		this
	}

	/** 
	 * Start subscribing
	 * 
	 * @return the subscription that was created. allows you to unsubscribe from the stream.
	 */
	def Subscription start() {
		// create the handlers
		val Action1<T> onEach = [ value | eachHandlers.each [ apply(value) ] ]
		val Action1<Throwable> onError = [ error | errorHandlers.each [ apply(error) ]]
		val Action0 onFinish = [| finishHandlers.each [ apply(null) ] ]
		// perform the subscription, based on if we have a scheduler
		if(scheduler.defined) stream.subscribe(onEach, onError, onFinish, scheduler)
		else stream.subscribe(onEach, onError, onFinish)
	}
	
}
