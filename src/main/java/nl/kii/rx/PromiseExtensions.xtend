package nl.kii.rx

import java.util.concurrent.Future
import java.util.concurrent.TimeUnit
import nl.kii.util.Err
import nl.kii.util.None
import nl.kii.util.Opt
import nl.kii.util.Some
import rx.Observable
import rx.Scheduler
import rx.subjects.ReplaySubject
import rx.subjects.Subject

import static extension nl.kii.rx.StreamExtensions.*
import static extension nl.kii.util.FunctionExtensions.*

/**
 * Promises are like futures, in that they have no value yet, but may be fulfilled later.
 * However, a Promise is also an Observable. Promises are implemented by AsyncSubject
 * and are Observable
 */
class PromiseExtensions {
	
	// CREATING A PROMISE /////////////////////////////////////////////////////
	
	def static <T> ReplaySubject<T> newPromise() {
		ReplaySubject.create
	}

	/** 
	 * Create a promise of a certain type. Usage:
	 * <pre>val p = Integer.promise</pre>
	 */
	def static <T> ReplaySubject<T> promise(Class<T> type) {
		ReplaySubject.create
	}
	
	/**
	 * Create a promise which is immediately fulfilled by an item
	 * <pre>val p = 12.promise</pre>
	 */
	def static <T> ReplaySubject<T> promise(T item) {
		Observable.from(item).replayable
	}

	/**
	 * Take a promised item from a future and immediately feed it into an existing observer
	 * <pre>
	 * val futureUser = asyncLoadUser(2345)
	 * val promisedUser = futureUser.promise
	 * promisedUser.then [ showUser(it) ]
	 */
	def static <T> ReplaySubject<T> promise(Future<T> future) {
		Observable.from(future).replayable
	}

	/**
	 * Create a promise from a future and schedule executing it on a passed scheduler
	 */
	def static <T> ReplaySubject<T> promise(Future<? extends T> future, Scheduler scheduler) {
		Observable.from(future, scheduler).replayable
	}

	/**
	 * Create a promise from a future and schedule executing it on a passed scheduler, within
	 * a given timeout period
	 */
	def static <T> ReplaySubject<T> promise(Future<? extends T> future, long timeout, TimeUnit timeUnit) {
		Observable.from(future, timeout, timeUnit).replayable
	}

	/** Normal observables do not replay. This streams a new stream to a replayable observable */	
	def static <T> ReplaySubject<T> replayable(Observable<T> observable) {
		val ReplaySubject<T> promise = newPromise
		observable.streamTo(promise)
		promise
	}
	
	// SEND DATA TO A PROMISE /////////////////////////////////////////////////
	
	/**
	 * Fulfill a promise with a value
	 */
	def static<T> apply(ReplaySubject<T> promise, T value) {
		promise.onNext(value)
		promise.onCompleted
		promise
	}
	
	/**
	 * Send an option into a promise. 
	 */
	def static <T> apply(ReplaySubject<T> promise, Opt<T> opt) {
		switch(opt) {
			Some<T>: promise.apply(opt.value)
			None<T>: promise.onCompleted
			Err<T>: promise.onError(opt.exception)
		}
	}
	
	// REACT TO A PROMISE BEING FULFILLED /////////////////////////////////////

	/** when the future is fulfilled, call the function which produces a new promise */
	def static <T, R> Observable<R> next(Future<T> future, (T)=>Observable<R> observableFn) {
		future.promise.next(observableFn)
	}

	/** 
	 * When the observable gives a value, call the onValue method with the found value.
	 * <p>
	 * Note: only use this method if you only expect a single value to be returned.
	 * It keeps an internal cache of all values being passed, so if you have a stream
	 * of values it will grow in memory usage. If you  are listening to a stream  of values, 
	 * use StreamExtensions.each instead.
	 */
	def static <T> then(Observable<T> promise, (T)=>void onValue) {
		val Subject<T, T> newPromise = newPromise
		promise.subscribe(
			[ newPromise << it; onValue << it ], 
			[ newPromise << it ], 
			[| newPromise << done ]
		)
		newPromise
	}

	/** When the future is fulfilled, call the handler. */
	def static <T> then(Future<T> future, (T)=>void handler) {
		future.promise.then(handler)
	}
	
	// OPERATOR OVERLOADING ///////////////////////////////////////////////////
	
	
	
}
