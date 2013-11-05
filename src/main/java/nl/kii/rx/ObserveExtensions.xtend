package nl.kii.rx

import nl.kii.util.Opt
import rx.Observable

import static nl.kii.util.OptExtensions.*

import static extension nl.kii.rx.StreamExtensions.*

class ObserveExtensions {
	
	// CREATING AN OBSERVED ///////////////////////////////////////////////////
	
	/**
	 * Create a variable that acts like an AtomicReference, but that is also a
	 * Subject. It allows you to have a threadsafe variable that can be observed
	 * for changes.
	 * <pre>
	 * 	val x = 10.observe // create the observable value
	 *  x <<< 20 // change the value to 20
	 *  println(x.apply) // prints the new value, 20
	 *  x >>> [ println('x was changed to ' + it) ] // tells you changed to 20
	 * </pre>
	 */
	def static <T> ObservedValue<T> observe(T value) {
		ObservedValue.createWithDefaultValue(value)
	}
	
	/**
	 * Transform a stream into a valuesubject, with the start value
	 */
	def static <T> ObservedValue<T> observe(Observable<T> stream, T startValue) {
		startValue.observe => [
			stream.streamTo(it)
		]
	}

	/**
	 * Transform a stream into a valuesubject<Opt<T>>, with a startvalue of none
	 */
	def static <T> ObservedValue<Opt<T>> observe(Observable<Opt<T>> observable) {
		val Opt<T> nothing = none
		nothing.observe => [
			observable.streamTo(it)
		]
	}	
	
	// CREATING A COMPUTED OBSERVE VALUE //////////////////////////////////////
	
	/**
	 * Lets you listen to observables, and if any has an update, execute the passed function.
	 * <pre>
	 * val x = 'hello'.observe
	 * val y = 'world'.observe
	 * val z = [ x.apply + ' ' + y.apply ].observe(x, y)
	 * println(z.apply) // prints 'hello world'
	 * y <<< 'John' // prints 'hello John'
	 * </pre>
	 */
	def static <T> ObservedValue<T> observe(=>T fn, Observable<?> ... observables) {
		// initial value is made from executing the function
		val ObservedValue<T> observed = fn.apply.observe
		// every change in any of the observables causes an update on o
		val (Object)=>void handler = [ observed.apply(fn.apply) ]
		observables.forEach [ it >> handler ]
		observed
	}

	// OPERATOR OVERLOADING ///////////////////////////////////////////////////
	
	def static <T> operator_not(ObservedValue<T> value) {
		value.get
	}

}