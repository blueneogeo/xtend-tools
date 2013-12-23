package nl.kii.rx

import nl.kii.util.Err
import nl.kii.util.None
import nl.kii.util.Opt
import nl.kii.util.Some
import rx.Observable
import rx.subjects.PublishSubject
import rx.subjects.ReplaySubject

import static extension nl.kii.rx.StreamExtensions.*
import static extension nl.kii.util.OptExtensions.*
import rx.subjects.Subject

class OptStreamExtensions {
	
	// CREATING AN OPTIONS STREAM OR PROMISE //////////////////////////////////
	
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
				None<T>: stream.complete
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
	
	// SEND DATA TO AN OPTSTREAM //////////////////////////////////////////////

	def static <T> apply(Subject<T, T> stream, Opt<T> opt) {
		switch(opt) {
			Some<T>: stream.apply(opt.value)
			None<T>: stream.complete
			Err<T>: stream.error(opt.exception)
		}
		stream
	}	

	// FILTERING //////////////////////////////////////////////////////////////

	/** 
	 * Filter empty results from a stream (None and Err), just giving you
	 * the normal values directly.
	 */	
	def static <T> Observable<T> filterEmpty(Observable<Opt<T>> optStream) {
		val PublishSubject<T> stream = newStream
		optStream.subscribe [ ifSome [ return stream.apply(it) ] ]
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
	
	// OPTIONAL MAPPING ///////////////////////////////////////////////////////

	/**
	 * Apply a mapping on only the defined options, and not on the empty options. Lets
	 * you perform mappings on option streams like you do with normal streams
	 */	
	def static <T, R> Observable<Opt<R>> mapOpt(Observable<Opt<T>> optStream, (T)=>R mapping) {
		optStream.map [
			if(it.hasSome) mapping.apply(it.value).option
			else none
		]
	}

	// REACTING TO INCOMING OPTIONS ///////////////////////////////////////////

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

	// OPERATOR OVERLOADING ///////////////////////////////////////////////////
	
    
    def static <T> operator_doubleLessThan(Subject<T, T> stream, Opt<T> opt) {
            stream.apply(opt)
    }
    
}