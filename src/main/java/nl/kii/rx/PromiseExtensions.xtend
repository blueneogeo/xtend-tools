package nl.kii.rx

import java.util.concurrent.Future
import java.util.concurrent.TimeUnit
import nl.kii.util.Err
import nl.kii.util.None
import nl.kii.util.Opt
import nl.kii.util.Some
import org.eclipse.xtext.xbase.lib.Functions
import rx.Observable
import rx.Scheduler
import rx.subjects.ReplaySubject

import static extension nl.kii.rx.StreamExtensions.*
import static extension nl.kii.util.FunctionExtensions.*
import rx.subjects.Subject

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

	/**
	 * Alias for StreamExtensions.mapAsync.
	 * <p>
	 * When the promise is fulfilled, call the function which produces a new promise. 
	 * This allows you to chain promises without having callback hell.
	 * <p>
	 * Instead of this:
	 * <pre>
	 * 
	 * def loadUserAsync(int userId, (User)=>void closure)
	 * def loadWebpageAsync(String url, (String)=>void closure)
	 * 
	 * loadUserAsync(12) [
	 *    // user loaded, load webpage
	 *    loadWebpageAsync('index.html') [
	 *       // webpage loaded, show page
	 *       showWebPage(it)
	 *    ]
	 * ]
	 * </pre>
	 * You can now do it like this. Notice how callbacks are no longer used,
	 * and instead it becomes a normal chain of commands:
	 * <pre>
	 * def Promise<User> def loadUserAsync(int userId)
	 * def Promise<String> def loadWebpageAsync(String url)
	 * 
	 * loadUserAsync(12)
	 *    .then [ loadWebpageAsync(it) ]
	 *    .then [ showWebPage(it) ]
	 * </pre>
	 * 
	 */
	def static <T, R> Observable<R> then(Observable<T> promise, Functions.Function1<T, ? extends Observable<R>> observableFn) {
		promise.mapAsync(observableFn)
	}

	/** when the future is fulfilled, call the function which produces a new promise */
	def static <T, R> Observable<R> then(Future<T> future, Functions.Function1<T, ? extends Observable<R>> observableFn) {
		future.promise.mapAsync(observableFn)
	}

	/** 
	 * When the promise is fulfilled, call the handler. Alias for StreamExtensions.each(..).start.
	 * If you need error handling, use .each instead, so you can chain it with .onError and .onFinish.
	 * <pre>
	 * val p = Integer.promise
	 * p.then [ println('got value ' + it) ]
	 * p.apply(4) // will print 'got value 4'
	 */
	def static <T> then(Observable<T> promise, (T)=>void onValue) {
		val Subject<T, T> newPromise = newPromise
		promise.subscribe(
			[ newPromise << it; onValue << it ], 
			[ newPromise << it ], 
			[| newPromise << finish ]
		)
		newPromise
	}

	/** 
	 * When the promise is fulfilled, call the handler.
	 * <pre>
	 * val p = Integer.promise
	 * p.then [ println('got value ' + it) ]
	 * p.apply(4) // will print the message above
	 */
	def static <T> then(Future<T> future, (T)=>void handler) {
		future.promise.then(handler)
	}
	
	// OPERATOR OVERLOADING ///////////////////////////////////////////////////
	
	
	
}
