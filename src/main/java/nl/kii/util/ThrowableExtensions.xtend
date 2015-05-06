package nl.kii.util

import static extension nl.kii.util.IterableExtensions.*

class ThrowableExtensions {
	
	/** 
	 * Removes stacktrace elements from a stacktrace. 
	 * Only tracktrace elements that do not match the filtered regexps pass.
	 */
	def static Iterable<StackTraceElement> clean(StackTraceElement[] stacktrace, String... filtered) {
		if(filtered == null) return stacktrace
		stacktrace.filter [ trace | none( filtered.map [
			trace.className.matches(it)
		] ) ]
	}
	
	
	/** 
	 * Removes stacktrace elements from any Throwable and its cause tree. 
	 * Only tracktrace elements that do not match the filtered regexps pass.
	 * Modifies the existing throwable, and also returns it for chaining.
	 */
	def static Throwable clean(Throwable t, String... filtered) {
		t.stackTrace = t.stackTrace.clean(filtered)
		// recursively keep cleaning causes
		if(t.cause != null) t.cause.clean(filtered)
		t
	}

	/** Formats a throwable into a nicely formatted string */
	def static format(Throwable it) {
		it.format(null)
	}
	
	/** Formats a throwable into a nicely formatted string, with an optional message. */
	def static String format(Throwable it, String message) '''
		«IF message != null»Thrown: «message»«ENDIF»
		Thrown «class.simpleName» - «message»:
			«it.message»
			«FOR trace : stackTrace»
			- «trace»
			«ENDFOR»
		«IF cause != null»
			Caused by «cause.class.simpleName»:
				«cause.message»
				«FOR trace : cause.stackTrace»
				- «trace»
				«ENDFOR»
		«ENDIF»
	'''

	/** returns true if the error is of the type or the cause of the error is of the type. */	
	def static matches(Throwable err, Class<? extends Throwable> type) {
		type.isAssignableFrom(err.class) || (if(err.cause != null) type.isAssignableFrom(err.cause?.class) else false)
	}
	
}