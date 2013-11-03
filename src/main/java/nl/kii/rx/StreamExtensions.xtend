package nl.kii.rx

import rx.subjects.PublishSubject
import rx.subjects.Subject
import rx.Observable
import nl.kii.util.Some
import nl.kii.util.None
import nl.kii.util.Err
import nl.kii.util.Opt
import rx.Observer

class StreamExtensions {
	
	// CREATE A STREAMS ///////////////////////////////////////////////////////
	
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
	def static <T> Iterable<? extends T> each(Iterable<? extends T> iterable, Observer<T> observer) {
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
			None<T>: stream.onCompleted
			Err<T>: stream.onError(opt.exception)
		}
		stream
	}

	// RESPOND TO THE STREAM //////////////////////////////////////////////////

	def static<T> finish(PublishSubject<T> subject) {
		subject.onCompleted
		subject
	}
	
	def static<T> error(PublishSubject<T> subject, Throwable t) {
		subject.onError(t)
		subject
	}

	
}
