package nl.kii.util

class ThrowableExtensions {
	
	def static format(Throwable it) {
		it.format(null)
	}
	
	def static String format(Throwable it, String message) '''
		«IF message != null»Thrown: «message»«ENDIF»
		Thrown «class.simpleName» - «message»:
			«it.message»
			«FOR trace : stackTrace.map[toString]»
			- «trace»
			«ENDFOR»
		«IF cause != null»
			Caused by «cause.class.simpleName»:
				«cause.message»
				«FOR trace : cause.stackTrace.map[toString]»
				- «trace»
				«ENDFOR»
		«ENDIF»
	'''		

	/** returns true if the error is of the type or the cause of the error is of the type. */	
	def static matches(Throwable err, Class<? extends Throwable> type) {
		type.isAssignableFrom(err.class) || (if(err.cause != null) type.isAssignableFrom(err.cause?.class) else false)
	}
	
}