package nl.kii.util

class ObjectExtensions { 
	
	/** Chainable version of the 'with'-operator ({@code object => [ ] }) */
	def static <T> with(T object, (T)=>void block) {
		object => block
	}

}
