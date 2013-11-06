package nl.kii.rx

import nl.kii.util.Err
import nl.kii.util.None
import nl.kii.util.Opt
import nl.kii.util.Some
import org.eclipse.xtext.xbase.lib.Functions
import rx.Observable
import rx.Observer
import rx.subjects.PublishSubject
import rx.subjects.Subject

import static extension nl.kii.util.OptExtensions.*
import rx.subjects.ReplaySubject

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

	def static <T> apply(Subject<T, T> stream, Opt<T> opt) {
		switch(opt) {
			Some<T>: stream.apply(opt.value)
			None<T>: stream.finish
			Err<T>: stream.error(opt.exception)
		}
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

	def static<T> finish(Observer<T> subject) {
		subject.onCompleted
		subject
	}
	
	def static<T> error(Observer<T> subject, Throwable t) {
		subject.onError(t)
		subject
	}
	
	/** Connect the output of one stream to the input of another */
	def static <T> streamTo(Observable<T> stream, Observer<T> observer) {
		stream.subscribe(observer)
		stream
	}
	
	/** Create a new Observable from the passed Observable (stream). Internally it creates a 
	 * ConnectableObservable<T>, connects it, and returns it.
	 * <p>
	 * This allows you to split a stream into multiple streams:
	 * <pre>
	 * stream => [
	 * 		split.each [ println('1st stream got ' + it) ]
	 * 		split.each [ println('2nd stream also got ' + it) ]
	 * ]
	 * </pre> 
	 */
	def static <T> split(Observable<T> stream) {
		val connector = stream.publish
		connector.connect
		connector
		// alternative implementation: newStream => [ stream.each(it) ]
	}
	
	// OPTION STREAMS /////////////////////////////////////////////////////////
	
	/**
	 * Convert a normal stream into an option stream:
	 * <li>every value is converted into Some(value)
	 * <li>a complete is converted into a None
	 * <li>an error is converted into an Err
	 * This means a stream is converted into a list of a single type,
	 * and allows you to use a single handler of results.
	 */
	def static <T> Observable<Opt<T>> options(Observable<T> stream) {
		val ReplaySubject<Opt<T>> optStream = ReplaySubject.create
		stream.subscribe(
			[ optStream.onNext(some(it)) ],
			[ optStream.onNext(err(it)) ],
			[| optStream.onNext(none) ]
		)
		optStream
	}
	
	/**
	 * Convert a stream of Options (back) to a normal stream.
	 * <li>every some(value) becomes a normal value in the stream
	 * <li>every none completes the stream
	 * <li>an err(throwable) is converted in an error, stopping the stream
	 */
	def static <T> Observable<T> collapse(Observable<Opt<T>> optStream) {
		val ReplaySubject<T> stream = ReplaySubject.create
		optStream.each [
			switch it {
				Some<T>: stream << value
				None<T>: stream.finish
				Err<T>: stream.error(exception)
			}
		]
		stream
	}

	/**
	 * Convert a normal stream of T into Opt<T> using a filter function.
	 * <p>
	 * For every value that matches, a Some<T> is pushed onto the resulting
	 * stream of Opt<T>, and every value that does not matches results in
	 * a None<T> being pushed.
	 * <p>
	 * This allows you to filter the stream using filterEmpty, or provide an
	 * alternative using .or, like you can with Iterables.or .
	 */
	def static <T> Observable<Opt<T>> options(Observable<T> stream, (T)=>boolean someFilter) {
		stream.map [ if(someFilter.apply(it)) some(it) else none ]
	}

	/** 
	 * Filter empty results from a stream (None and Err), just giving you
	 * the normal values directly.
	 */	
	def static <T> Observable<T> filterEmpty(Observable<Opt<T>> optStream) {
		val PublishSubject<T> stream = newStream
		optStream.subscribe [ ifSome [ stream.apply(it) ] ]
		stream
	}
	
	/** 
	 * Collapses an Opt<T> stream into a T stream, using the alternativeFn to
	 * provide the value in case of a None. Errors are converted back into normal
	 * stream errors.
	 */
	def static <T> Observable<T> or(Observable<Opt<T>> optStream, (Object)=> T alternativeFn) {
		optStream.map [
			switch(it) {
				Some<T>: value
				None<T>: alternativeFn.apply(null)
				Err<T>: throw exception
			}
		]
	}
	
	/** Same as alternative Fn, but with a static value */
	def static <T> Observable<T> or(Observable<Opt<T>> optStream, T alternative) {
		optStream.or [ alternative ]
	}

	/**
	 * React to some value entering the stream
	 */
	def static <T> onSome(Observable<Opt<T>> optStream, (T)=>void handler) {
		optStream.subscribe [ ifSome [ handler.apply(it) ] ]
		optStream
	}
	
	/**
	 * React to a none entering the stream
	 */
	def static <T> onNone(Observable<Opt<T>> optStream, (T)=>void handler) {
		optStream.subscribe [ 
			ifNone [ handler.apply(null) ]
		]
		optStream
	}

	/**
	 * React to a none entering the stream
	 */
	def static <T> onErr(Observable<Opt<T>> optStream, (Throwable)=>void handler) {
		optStream.subscribe [ ifErr [ handler.apply(it) ] ]
		optStream
	}	

	// OPTSTREAM WRAPPING INTERFACE ///////////////////////////////////////////
	
	/**
	 * Create an optstream and handle onSome, return the optstream. Will call the handler for each value found.
	 * This allows for easier coding than using the options. Instead of:
	 * 
	 * <pre>
	 * Integer.stream.options
	 * 	.onSome [ println('got value' + it) ]
	 * 	.onNone [ println('completed stream') ]
	 * 	.onErr  [ println('an error occurred!') ]
	 * </pre>
	 * 
	 * You can then use a syntax that is more like the list interface:
	 * 
	 * <pre>
	 * Integer.stream
	 * 	.each [ println('got value' + it) ]
	 * 	.onFinish [ println('completed stream') ]
	 * 	.onError  [ println('an error occurred!') ]
	 * </pre>
	 * 
	 * Or using the operators:
	 * <pre>
	 * Integer.stream
	 * 	>>> [ println('got value' + it) ]
	 * 	.. [ println('completed stream') ]
	 * 	?: [ println('an error occurred!') ]
	 * </pre>
	 * 
	 */
	def static <T> Observable<Opt<T>> each(Observable<T> stream, (T)=>void handler) {
		stream.options.onSome(handler)
	}

	/** 
	 * Alias for onErr, called if a Err result, meaning there was an error inside the handling of the stream
	 */
	def static <T> onError(Observable<Opt<T>> stream, (Throwable)=>void handler) {
		stream.onErr(handler)
	}
	
	/**
	 * Alias for onNone, called if a None result, meaning the stream was completed
	 */
	def static <T> onFinish(Observable<Opt<T>> stream, (Object)=>void handler) {
		stream.onNone(handler)
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

    def static <T, R> operator_mappedTo(Observable<T> stream, (T)=>R fn) {
            stream.map(fn)
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
    
    def static <T> operator_doubleLessThan(Subject<T, T> stream, Opt<T> opt) {
            stream.apply(opt)
    }

    def static<T> operator_upTo(Observable<Opt<T>> stream, (Object)=>void handler) {
            stream.onFinish(handler)
    }
    
    def static <T> operator_elvis(Observable<Opt<T>> stream, (Throwable)=>void handler) {
            stream.onError(handler)
    }
    
}
