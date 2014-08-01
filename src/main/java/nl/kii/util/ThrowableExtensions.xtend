package nl.kii.util

class ThrowableExtensions {
	
	def static print(Throwable it) {
		it.print(null)
	}
	
	def static String print(Throwable it, String message) '''
		«IF message != null»Thrown: «message»«ENDIF»
		Thrown «class.simpleName» - «message»:
			«it.message»
			«FOR trace : stackTrace.map[toString]»
			- «trace»
			«ENDFOR»
		Caused by «cause.class.simpleName»:
			«cause.message»
			«FOR trace : cause.stackTrace.map[toString]»
			- «trace»
			«ENDFOR»
	'''		
	
}