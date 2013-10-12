package nl.kii.util

import org.slf4j.Logger

class LogExtensions {
	
	// WRAPPER ////////////////////////////////////////////////////////////////

	// create a logging wrapper
	// example: extension Log logger = class.logger.wrapper
	def static wrapper(Logger logger) {
		new Log(logger, null)
	}

	// create a logging wrapper
	// example: extension Log logger = class.logger.wrapper
	def static wrapper(Logger logger, String name) {
		new Log(logger, name)
	}
	
	// PRINTING ///////////////////////////////////////////////////////////////
	
	// print something. example: o.print
	def static print(CharSequence s) {
		println(s)
	}

	// print a list in seperate lines
	def static print(CharSequence ...s) {
		s.forEach[ println(it) ]
	}
	
	// print the result of a function
	// example: print [| new User() ]
	def static <T> print(=>T s) {
		println(s.apply)
	}
	
	// loses the | requirement in the function
	// example: print [ new User() ]
	def static <T> print((Object)=>T o) {
		print(o.apply(null))
	}
	
}
