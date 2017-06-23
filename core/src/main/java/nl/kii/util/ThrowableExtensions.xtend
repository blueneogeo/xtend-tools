package nl.kii.util

import static extension nl.kii.util.IterableExtensions.*
import com.google.common.base.Throwables

class ThrowableExtensions {

	def static getRootCause(Throwable t) {
		Throwables.getRootCause(t)
	}

	/** 
	 * Removes stacktrace elements from a stacktrace. 
	 * Only tracktrace elements that do not match the filtered regexps pass.
	 */
	def static Iterable<StackTraceElement> clean(StackTraceElement[] stacktrace, String... filtered) {
		if(filtered === null) return stacktrace
		// allow only those traces whose classname match none of the filtered items 
		stacktrace.filter [ trace |
			none( filtered.map[trace.className.matches(it)])
		]
	}

	/** 
	 * Removes stacktrace elements from any Throwable and its cause tree. 
	 * Only tracktrace elements that do not match the filtered regexps pass.
	 * Modifies the existing throwable, and also returns it for chaining.
	 */
	def static Throwable clean(Throwable t, String... filtered) {
		t.stackTrace = t.stackTrace.clean(filtered)
		if(t.cause !== null) t.cause.clean(filtered)
		t
	}

	/** Formats a throwable into a nicely formatted string */
	def static String format(Throwable it, String message) '''
		«message»
		«format(it)»
	'''

	/** Formats a throwable into a nicely formatted string, with an optional message. */
	def static String format(Throwable it) '''
		«class.simpleName» «it.message»:
			«it.message»
			«FOR trace : stackTrace»
				at «trace»
			«ENDFOR»
			«val root = rootCause»
			«IF root != it»
				Caused by: «root.format»
			«ENDIF»
	'''

	/** returns true if the error is of the type or the cause of the error is of the type. */
	def static matches(Throwable err, Class<? extends Throwable> type) {
		type.isAssignableFrom(err.class) || (if(err.cause !== null) type.isAssignableFrom(err.cause?.class) else false)
	}

}