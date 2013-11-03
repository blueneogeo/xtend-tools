package nl.kii.rx

import java.util.concurrent.Future
import java.util.concurrent.TimeUnit
import org.eclipse.xtext.xbase.lib.Functions
import rx.Observable
import rx.Scheduler
import rx.subjects.AsyncSubject

import static extension nl.kii.rx.ObservableExtensions.*
import nl.kii.util.Some
import nl.kii.util.None
import nl.kii.util.Err
import nl.kii.util.Opt

/**
 * Promises are like futures, in that they have no value yet, but may be fulfilled later.
 * However, a Promise is also an Observable. Promises are implemented by AsyncSubject
 * and are Observable
 */
class PromiseExtensions {
	
	// CREATING A PROMISE /////////////////////////////////////////////////////
	
	def static <T> AsyncSubject<T> newPromise() {
		AsyncSubject.create
	}

	/** 
	 * Create a promise of a certain type. Usage:
	 * <pre>val p = Integer.promise</pre>
	 */
	def static <T> AsyncSubject<T> promise(Class<T> type) {
		AsyncSubject.create
	}
	
	/**
	 * Create a promise which is immediately fulfilled by an item
	 * <pre>val p = 12.promise</pre>
	 */
	def static <T> Observable<T> promise(T item) {
		Observable.from(item)
	}

	/**
	 * Take a promised item from a future and immediately feed it into an existing observer
	 * <pre>
	 * val futureUser = asyncLoadUser(2345)
	 * val promisedUser = futureUser.promise
	 * promisedUser.then [ showUser(it) ]
	 */
	def static <T> Observable<T> promise(Future<?> future, Class<T> type) {
		Observable.from(future as Future<T>)
	}

	/**
	 * Create a promise from a future and schedule executing it on a passed scheduler
	 */
	def static <T> Observable<T> promise(Future<? extends T> future, Scheduler scheduler) {
		Observable.from(future, scheduler)
	}

	/**
	 * Create a promise from a future and schedule executing it on a passed scheduler, within
	 * a given timeout period
	 */
	def static <T> Observable<T> promise(Future<? extends T> future, long timeout, TimeUnit timeUnit) {
		Observable.from(future, timeout, timeUnit)
	}	
	
	// SEND DATA TO A PROMISE /////////////////////////////////////////////////
	
	/**
	 * Fulfill a promise with a value
	 */
	def static<T> apply(AsyncSubject<T> promise, T value) {
		promise.onNext(value)
		promise.onCompleted
		promise
	}
	
	/**
	 * Send an option into a promise. 
	 */
	def static <T> apply(AsyncSubject<T> promise, Opt<T> opt) {
		switch(opt) {
			Some<T>: promise.apply(opt.value)
			None<T>: promise.onCompleted
			Err<T>: promise.onError(opt.exception)
		}
	}
	
	// REACT TO A PROMISE BEING FULFILLED /////////////////////////////////////
	
	/** 
	 * When the promise is fulfilled, call the handler
	 * <pre>
	 * val p = Integer.promise
	 * p.then [ println('got value ' + it) ]
	 * p.apply(4) // will print the message above
	 */
	def static <T> Observable<Opt<T>> then(Observable<T> promise, (T)=>void handler) {
		promise.options.onSome(handler)
	}

	/** 
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
	def static <T, R> Observable<R> then(Observable<T> promise, Class<R> outgoingFutureType, Functions.Function1<T, ? extends Future<R>> futureFn) {
		promise
			.map [ futureFn.apply(it).promise(outgoingFutureType) ]
			.flatMap[it]
	}		

	/** when the future is fulfilled, call the function which produces a new promise */
	def static <T, R> Observable<Opt<T>> then(Future<T> future, Class<T> incomingFutureType, (T)=>void eachFn) {
		future
			.promise(incomingFutureType)
			.each(eachFn)
	}

	/** when the future is fulfilled, call the function which produces a new promise */
	def static <T, R> Observable<R> then(Future<T> future, Class<T> incomingFutureType, Class<R> outgoingFutureType, (T)=>Future<R> futureFn) {
		future
			.promise(incomingFutureType)
			.map [ futureFn.apply(it).promise(outgoingFutureType) ]
			.flatMap[it]
	}
	
}