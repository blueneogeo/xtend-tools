package nl.kii.util

class ThrowableExtensions {
	
	def static toString(Throwable it, (Throwable)=>String descriptionFn) '''
		«IF descriptionFn != null»Error: «descriptionFn.apply(it)»«ENDIF»
		Thrown: «class.name» - «message»:
			«FOR trace : stackTrace.map[toString]»
			- «trace»
			«ENDFOR»
		Caused by: «cause.class.name» - «cause.message»
			«FOR trace : cause.stackTrace.map[toString]»
			- «trace»
			«ENDFOR»
	'''		
	
}