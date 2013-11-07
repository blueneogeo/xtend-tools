package nl.kii.rx

import org.eclipse.xtext.xbase.lib.Functions
import rx.Observable
import rx.Observer
import rx.observables.ConnectableObservable
import rx.subjects.PublishSubject
import rx.subjects.Subject

class StreamExtensions {
	
	// CREATE A STREAM ////////////////////////////////////////////////////////
	
	def static <T> PublishSubject<T> newStream() {
		PublishSubject.create
	}

	def static <T> PublishSubject<T> stream(Class<T> type) {
		PublishSubject.create
	}

	/** Transform an iterable into a stream */
	def static <T> Observable<T> stream(Iterable<? extends T> iterable) {
		Observable.from(iterable)
	}
	
	/** Push a collection of values into a stream */
	def static <T> Iterable<? extends T> streamTo(Iterable<? extends T> iterable, Observer<T> observer) {
		iterable.forEach [ observer.onNext(it) ]
		iterable
	}
	
	// SEND DATA TO A STREAM //////////////////////////////////////////////////

	def static<T> apply(Subject<T, T> stream, T value) {
		stream.onNext(value)
		stream
	}

	// ASYNC MAPPING //////////////////////////////////////////////////////////
	
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
			.flatMap[it]
			.synchronize
	}	

	// RESPOND TO THE STREAM //////////////////////////////////////////////////

	/** Inform a stream that it finished */
	def static<T> finish(Observer<T> subject) {
		subject.onCompleted
		subject
	}
	
	/** Inform a stream that an error occurred */
	def static<T> error(Observer<T> subject, Throwable t) {
		subject.onError(t)
		subject
	}
	
	/** Connect the output of one stream to the input of another */
	def static <T> streamTo(Observable<T> stream, Observer<T> observer) {
		stream.subscribe(observer)
		stream
	}
	
	/** 
	 * Respond to each incoming value by calling the passed onValue function. Eg:
	 * <pre>
	 * val longs = Long.stream
	 * 
	 * longs.each [ println('got ' + it) ]
	 * 
	 * longs.apply(4L).apply(6L)
	 * </pre>
	 * <p>
	 * It will automatically connect if the stream is a ConnectableObservable!
	 * It will return an unconnected ConnectableObservable of the passed stream.
	 * The reason for this is that this is how we are able to chain .each, .onError
	 * and .onFinish together for a nice clean and chainable syntax:
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
		switch stream {	ConnectableObservable<T>: stream.connect }
		val cstream = stream.publish
		stream.subscribe(onValue, [])
		cstream
	}

	/** Handle an error occurring on the stream */
	def static <T> onError(Observable<T> stream, (Throwable)=> void onError) {
		switch stream {	ConnectableObservable<T>: stream.connect }
		val cstream = stream.publish
		stream.subscribe([], onError)
		cstream
	}
	
	/** Handle the stream completing */
	def static <T> onFinish(Observable<T> stream, (Object)=>void onFinish) {
		switch stream {	ConnectableObservable<T>: stream.connect }
		val cstream = stream.publish
		stream.subscribe([], [], [| onFinish.apply(null) ])
		cstream
	}
	
	/** Collect the results in an observed value bucket */
	def static <T> collect(Observable<T> stream) {
		val collector = new Collector
		stream.streamTo(collector)
		collector
	}
	
	/** At most collect maxSize elements in the bucket, to protect against memory overflow */
	def static <T> collect(Observable<T> stream, int maxSize) {
		val collector = new Collector(maxSize)
		stream.streamTo(collector)
		collector
	}

	// OPERATOR OVERLOADING ///////////////////////////////////////////////////
    
    def static <T> Iterable<? extends T> operator_doubleGreaterThan(Iterable<? extends T> iterable, Observer<T> stream) {
            iterable.streamTo(stream)
    }        

    def static <T> operator_doubleGreaterThan(Observable<T> stream, (T)=>void handler) {
            stream.each(handler)
    }

    def static <T> operator_doubleGreaterThan(Observable<T> stream, Observer<T> observer) {
            stream.streamTo(observer)
    }

    def static<T> operator_upTo(ConnectableObservable<T> stream, (Object)=>void handler) {
            stream.onFinish(handler)
    }
    
    def static <T> operator_elvis(ConnectableObservable<T> stream, (Throwable)=>void handler) {
            stream.onError(handler)
    }
	
    def static <T, R> operator_mappedTo(Observable<T> stream, (T)=>R fn) {
            stream.map(fn)
    }

    def static <T, R> Observable<R> operator_greaterThan(Observable<T> stream, Functions.Function1<T, ? extends Observable<R>> observableFn) {
            stream.mapAsync(observableFn)
    }
    
    def static <T> operator_plus(Observable<T> stream, (T)=>boolean fn) {
            stream.filter(fn)
    }

    def static <T> operator_minus(Observable<T> stream, Functions.Function1<? super T, Boolean> predicate) {
            stream.filter [ !predicate.apply(it) ] // cannot use !predicate, due to bug in Xtend
    }

    def static <T> operator_doubleLessThan(Subject<T, T> stream, T value) {
            stream.apply(value)
    }

}
