package nl.kii.rx

import java.util.Collection
import java.util.List
import org.eclipse.xtext.xbase.lib.Functions
import rx.Observable
import rx.Observer
import rx.observables.ConnectableObservable
import rx.subjects.PublishSubject
import rx.subjects.Subject

import static extension nl.kii.util.FunctionExtensions.*

enum StreamCommand { finish }

class StreamExtensions {
	
	// CREATE A STREAM ////////////////////////////////////////////////////////
	
	/**
	 * Used for making a stream of any type by using Xtend type inference.
	 * 
	 * This is necessary when using generics. For example:
	 * <pre>
	 * val s = AsyncResult.stream // misses out on genertic type info
	 * // use inference instead:
	 * val Observable<AsyncResult<Map<Int, String>>> s = newStream
	 * </pre>
	 */
	def static <T> PublishSubject<T> newStream() {
		PublishSubject.create
	}

	/**
	 * Create a stream of type T
	 * 
	 * <pre>
	 * val ints = Integer.stream
	 * ints >> [ println(it) ]
	 * ints << 4 << 9 // prints 4 and 9
	 * </pre>
	 */
	def static <T> PublishSubject<T> stream(Class<T> type) {
		PublishSubject.create
	}

	/** 
	 * Transform an iterable into a stream
	 * 
	 * <pre>
	 * val s = #[4, 9].stream
	 * s >> [ println(it) ] // prints 4 and 9
	 * </pre>
	 */
	def static <T> Observable<T> stream(Iterable<? extends T> iterable) {
		Observable.from(iterable)
	}
	
	/** 
	 * Push a collection of values into a stream
	 */
	def static <T> Iterable<? extends T> streamTo(Iterable<? extends T> iterable, Observer<T> observer) {
		iterable.forEach [ observer.onNext(it) ]
		iterable
	}
	
	/** Transform a Listenable into a stream */
	def static <T> stream(Listenable<T> listenable) {
		val Subject<T, T> stream = newStream
		listenable.onChange [ stream << it ]
		stream
	}	
	
	// SEND DATA TO A STREAM //////////////////////////////////////////////////

	/**
	 * Apply a value on a stream, which pushes it onto the stream to be processed.
	 * You can also pass an exception, which will throw an error on the stream,
	 * or you can pass StreamCommand.finish (use finish() to create it easily) to
	 * finish the stream.
	 */
	def static<T> apply(Subject<T, T> stream, T value) {
		switch value {
			StreamCommand: switch value {
				case StreamCommand.finish: stream.complete
			}
			Exception: stream.error(value)
			default: stream.onNext(value)
		}
		stream
	}

	/**
	 * Send an error to a stream, same as stream.error(e).
	 */
	def static<T> apply(Subject<T, T> stream, Throwable e) {
		stream.error(e)
		stream
	}

	/**
	 * Quick way to create a finish stream command, to use for applying:
	 * <pre>
	 * stream << 3 << 9 << 12 << finish
	 */	
	def static done() { StreamCommand.finish	}

	/**
	 * Send a command to the stream (usually to finish it)
	 */
	def static<T> apply(Subject<T, T> stream, StreamCommand cmd) {
		switch cmd {
			case StreamCommand.finish: stream.complete
		}
		stream
	}

	/** Inform a stream that it finished */
	def static<T> complete(Subject<T, T> subject) {
		subject.onCompleted
		subject
	}
	
	/** Inform a stream that an error occurred */
	def static<T> error(Subject<T, T> subject, Throwable t) {
		subject.onError(t)
		subject
	}	

	/** Inform a stream that an error occurred */
	def static<T> error(Subject<T, T> subject, String errorMessage) {
		subject.onError(new Exception(errorMessage))
		subject
	}	

	// MAPPING ////////////////////////////////////////////////////////////////

	/**
	 * Flattens an observable of a list of items into one stream of just the items
	 */
	def static <T> Observable<T> flattenList(Observable<List<T>> stream) {
		stream.flatMap [ it.stream ]
	}

	/**
	 * Flattens an observable of an observable into a single observable
	 */	
	def static <T> Observable<T> flatten(Observable<Observable<T>> stream) {
		stream.flatMap [ it ]
	}
	
	/** 
	 * Take a stream of values, and for each, map them into new values using an asynchronous process
	 * described by a passed function which produces an observable. The resulting stream is put in
	 * order of incoming values.
	 * <p>
	 * This lets you chain asynchronous operations together and avoid callback hell.
	 * The function you pass should return a stream/Observable to be listened to for the result.
	 * <pre>
	 * // given the following interface
	 * def Observable<User> loadUserAsync(int userId)
	 * def Observable<Profile> loadUserProfileAsync(User user)
	 * def void displayUserProfile(Profile profile) 
	 * 
	 * // we can now do this:
	 * #[4534, 3432, 67] // some user id's
	 *    .stream
	 *    .mapAsync [ userId | userAPI.loadUserAsync(userId) ]
	 *    .mapAsync [ user | profileAPI.loadUserProfileAsync(user) ]
	 *    .each [ profile | displayUserProfile(profile) ]
	 *    .onErr [ println('got error ' + it) ]
	 * </pre>
	 */
	def static <T, R> Observable<R> mapAsync(Observable<T> stream, Functions.Function1<T, ? extends Observable<R>> observableFn) {
		stream
			.map [ observableFn.apply(it) ]
			.flatten
	}

	/**
	 * Keep streaming while the condition is valid
	 * <pre>
	 * val stream = Integer.stream
	 * stream.while[ it <= 10 ].toList >> [ println(join(', ')) ]
	 * stream << 4 << 8 << 10 << 11 << 5 << finish
	 * // outputs: 4, 8, 10
	 */	
	def static <T> while_(Observable<T> stream, (T)=>boolean untilFn) {
		val Subject<T, T> newStream = newStream
		stream.subscribe(
			[ if(!untilFn.apply(it)) newStream.complete else newStream << it ],
			[ newStream.error(it) ],
			[| newStream.complete ]
		)
		newStream
	}

	/**
	 * Keep streaming until the condition has been reached.
	 * <pre>
	 * val stream = Integer.stream
	 * stream.until[ it > 10 ].toList >> [ println(join(', ')) ]
	 * stream << 4 << 8 << 10 << 11 << 5 << finish
	 * // outputs: 4, 8, 10
	 */	
	def static <T> until(Observable<T> stream, (T)=>boolean untilFn) {
		val Subject<T, T> newStream = newStream
		stream.subscribe(
			[ if(untilFn.apply(it)) newStream.complete else newStream << it ],
			[ newStream.error(it) ],
			[| newStream.complete ]
		)
		newStream
	}

	// VALIDATION /////////////////////////////////////////////////////////////
	
	def static <T> assertTrue(Observable<T> stream, String errorMessage, (T)=>boolean assertFn) {
		stream.map [
			if(!assertFn.apply(it)) throw new AssertionError(errorMessage)
			it
		]
	}

	def static <T> assertFalse(Observable<T> stream, String errorMessage, (T)=>boolean assertFn) {
		stream.map [
			if(assertFn.apply(it)) throw new AssertionError(errorMessage)
			it
		]
	}

	// RESPOND TO THE STREAM //////////////////////////////////////////////////
	
	/**
	 * Create a subscriber, which lets this library piece together a subscription
	 * call function by function. You create the actual subscription by calling
	 * start() on the created Subscriber.
	 * 
	 * <pre>
	 * val subscription = Integer.stream
	 *     .subscribe
	 *     .each [ ... ]
	 *     .onError [ ... ]
	 *     .start
	 */
	def static <T> subscribe(Observable<T> stream) {
		new Subscriber<T>(stream)
	}

	/** 
	 * Connect the output of one stream to the input of another.
	 * This will also start the stream, so before you make this call,
	 * make sure that the observer stream is already wired up to react to
	 * incoming T's.
	 * 
	 * @return the subscription that was created. allows you to unsubscribe from the stream.
	 */
	def static <T> streamTo(Observable<T> stream, Observer<T> observer) {
		stream.subscribe(observer)
	}
	
	// SUBSCRIBE //////////////////////////////////////////////////////////////
	
	/** 
	 * Respond to each incoming value by calling the passed onValue function. Eg:
	 * <pre>
	 * val longs = Long.stream
	 * 
	 * longs.each [ println('got ' + it) ].start
	 * 
	 * longs.apply(4L).apply(6L)
	 * </pre>
	 * <p>
	 * It automatically creates a subscriber by calling stream.subscribe
	 * <pre>
	 * val longs = Long.stream
	 * 
	 * longs
	 *     .each [ println('got ' + it) ]
	 *     .onError [ println('got an error: ' + it) ]
	 *     .onFinish [ println('we are done!') ]
	 * 
	 * longs.apply(4L).apply(6L)
	 * </pre>
	 * 
	 * 
	 * If you need to subscribe and have more control, use
	 * the .subscribe method instead, which will also not autoconnect and provide you
	 * with the subscription:
	 * <pre>
	 * val longs = Long.stream
	 * 
	 * val subscription = longs.subscribe(
	 *     [ println('got ' + it) ],
	 *     [ println('got an error: ' + it) ],
	 *     [ println('we are done!') ]
	 * )
	 * 
	 * longs.apply(4L).apply(6L)
	 * </pre>
	 */
	def static <T> each(Observable<T> stream, (T)=>void onValue) {
		val Subject<T, T> newStream = newStream
		stream.subscribe(
			[ newStream << it; onValue << it ], 
			[ newStream << it ], 
			[| newStream << done ]
		)
		newStream
	}


	/** Handle an error occurring on the stream */
	def static <T> onError(Observable<T> stream, (Throwable)=> void onError) {
		val Subject<T, T> newStream = newStream
		stream.subscribe(
			[ newStream << it ], 
			[ newStream << it; onError << it ], 
			[| newStream << done ]
		)
		newStream
	}

	/** Handle the stream completing */
	def static <T> onComplete(Observable<T> stream, (Object)=>void onComplete) {
		val Subject<T, T> newStream = newStream
		stream.subscribe(
			[ newStream << it ], 
			[ newStream << it ], 
			[| newStream << done; onComplete << null ]
		)
		newStream
	}

	/** Handle the stream finishing with either an error or completion */
	def static <T> onFinish(Observable<T> stream, (Object)=>void onFinish) {
		val Subject<T, T> newStream = newStream
		stream.subscribe(
			[ newStream << it ], 
			[ newStream << it; onFinish << null ], 
			[| newStream << done; onFinish << null ]
		)
		newStream
	}
	
	/** Collect the results in an observed value bucket */
	def static <T> Collector<T> collect(Observable<T> stream) {
		val collector = new Collector
		stream.streamTo(collector)
		collector
	}
	
	/** At most collect maxSize elements in the bucket, to protect against memory overflow */
	def static <T> Collector<T> collect(Observable<T> stream, int maxSize) {
		val collector = new Collector(maxSize)
		stream.streamTo(collector)
		collector
	}

	/** At most collect maxSize elements in the bucket, to protect against memory overflow */
	def static <T> Collector<T> collect(Observable<T> stream, int maxSize, (Collection<T>)=>void onFinish) {
		val collector = new Collector(onFinish, maxSize)
		stream.streamTo(collector)
		collector
	}

	/** At most collect maxSize elements in the bucket, to protect against memory overflow */
	def static <T> Collector<T> collect(Observable<T> stream, (Collection<T>)=>void onFinish) {
		val collector = new Collector(onFinish)
		stream.streamTo(collector)
		collector
	}
	
	// OPERATOR OVERLOADING ///////////////////////////////////////////////////
    
    /**
     * Convert a list into a stream
     * 
     * <pre>
     * val s = Integer.stream
     * s.each [ println(it) ]
     * #[4, 9] >> s // prints 4 and 9
     * </pre>
     */
    def static <T> Iterable<? extends T> operator_doubleGreaterThan(Iterable<? extends T> iterable, Observer<T> stream) {
            iterable.streamTo(stream)
    }        

	/**
	 * Shortcut for stream.then
	 * 
	 * <pre>
	 * val s = String.stream
	 * s.apply('Hello')
	 * s.apply('World')
	 * s >> [ println(it) ] // prints 'Hello' and 'World'
	 */
    def static <T> operator_doubleGreaterThan(Observable<T> stream, (T)=>void handler) {
            stream.each(handler)
    }

	/** 
	 * Stream the results from one stream to another
	 * 
	 * <pre>
	 * val s1 = String.stream
	 * val s2 = String.stream
	 * s2.each [ println(it) ]
	 * 
	 * s1 >> s2
	 * s.apply('Hello') // prints 'Hello'
	 * s.apply('World') // prints 'World'
	 */
    def static <T> operator_doubleGreaterThan(Observable<T> stream, Observer<T> observer) {
            stream.streamTo(observer)
    }

	/**
	 * Calls the handler when the stream finishes/completes
	 * 
	 * <pre>
	 * val s = String.stream
	 * s >> [ println(it) ] .. [ println('done!') ]
	 * 
	 * s.apply('test') // prints 'test'
	 * s.finish // prints 'done'
	 */
    def static<T> operator_upTo(ConnectableObservable<T> stream, (Object)=>void handler) {
            stream.onComplete(handler)
    }
    
    /**
     * Calls the handler when the stream had an error
     * 
     * <pre>
     * val s = Integer.stream
     * s >> [ it / 0 ] ?: [ println('error found') ]
     * 
     * s.apply(1) // prints 'error found' (because dividing by 0)
     */
    def static <T> operator_elvis(ConnectableObservable<T> stream, (Throwable)=>void handler) {
            stream.onError(handler)
    }

	/**
	 * Shortcut operator for stream.map
	 * 
	 * <pre>
	 * val s = Integer.stream
	 * s -> [ it * 2 ] >> [ println(it) ]
	 * s << 4 << 5 // prints 8 and 10
	 */	
    def static <T, R> operator_mappedTo(Observable<T> stream, (T)=>R fn) {
            stream.map(fn)
    }

	/**
	 * Shortcut for mapAsync/then. Lets you chain methods that produce observables. In other words,
	 * it lets you produce a chain of async operations, such as, do A$, then when A$ finishes, do B$, etc.
	 * <p>
	 * Note: the $ at the end of a method/function name is a convention for a method that returns an observable
	 * 
	 * <pre>
	 * // given definition
	 * def Observable<FileData> loadFile$(String path)
	 * def Observable<String> processResult$(FileData data)
	 * def void printResults(String s)
	 * 
	 * // the following
	 * loadFile$('test.txt')
	 *     .then [ processResult$(it) ]
	 *     .each [ printResults(it.data) ]
	 * 
	 * // can also be written as
	 * loadFile$('test.txt') >= [ processResult$(it) ] >> [ printResults(data) ]
	 */
    def static <T, R> Observable<R> operator_greaterEqualsThan(Observable<T> stream, Functions.Function1<T, ? extends Observable<R>> observableFn) {
            stream.mapAsync(observableFn)
    }

	/**
	 * Perform positive filtering, returning a stream that only contains the values that match the filter.
	 * 
	 * <pre>
	 * val s = Integer.stream
	 * s << 3 << 4 << 5 << 6
	 * s +[ it > 4 ] >> [ println(it) ] // prints 5 and 6
	 */    
    def static <T> operator_plus(Observable<T> stream, (T)=>boolean fn) {
            stream.filter(fn)
    }

	/**
	 * Perform negative filtering, returning a stream that only contains the values do NOT match the filter.
	 * 
	 * <pre>
	 * val s = Integer.stream
	 * s << 3 << 4 << 5 << 6
	 * s -[ it > 4 ] >> [ println(it) ] // prints 3 and 4
	 */    
    def static <T> operator_minus(Observable<T> stream, Functions.Function1<? super T, Boolean> predicate) {
            stream.filter [ !predicate.apply(it) ] // cannot use !predicate, due to bug in Xtend
    }

	/**
	 * Alias for stream.apply(value)
	 */
    def static <T> operator_doubleLessThan(Subject<T, T> stream, T value) {
            stream.apply(value)
    }

	/**
	 * Alias for stream.apply(throwable)
	 */
    def static <T> operator_doubleLessThan(Subject<T, T> stream, Throwable value) {
            stream.apply(value)
    }

	/**
	 * Alias for stream.apply(streamcommand)
	 */
    def static <T> operator_doubleLessThan(Subject<T, T> stream, StreamCommand value) {
            stream.apply(value)
    }

}
