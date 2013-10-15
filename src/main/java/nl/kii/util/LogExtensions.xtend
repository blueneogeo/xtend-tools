package nl.kii.util

import org.slf4j.Logger
import static extension nl.kii.util.IterableExtensions.*
import static extension nl.kii.util.OptExtensions.*

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
	
	// PRINTING FUNCTION //////////////////////////////////////////////////////
	
	def static <T> (T)=>void printEach() {
		[ println(it) ]
	}
	
	def static <T> (T)=>void printEach(String msg) {
		[ println(msg + it) ]
	}

	// LOGGING LISTS //////////////////////////////////////////////////////////
	
	def static <T> printEach(Iterable<T> list, String msg) {
		if(msg.defined) println(msg)
		list >> [ println(it.toString) ]
	}

	def static <T> trace(Log log, Iterable<T> list, String msg) { 
		if(msg.defined) log.logger.trace(msg)
		list >> [ log.logger.trace(toString) ]
	}
	
	def static <T> debug(Log log, Iterable<T> list, String msg) { 
		if(msg.defined) log.logger.debug(msg)
		list >> [ log.logger.debug(toString) ]
	}
	
	def static <T> info(Log log, Iterable<T> list, String msg) { 
		if(msg.defined) log.logger.info(msg)
		list >> [ log.logger.info(toString) ]
	}
	
	def static <T> warn(Log log, Iterable<T> list, String msg) { 
		if(msg.defined) log.logger.warn(msg)
		list >> [ log.logger.warn(toString) ]
	}
	
	def static <T> error(Log log, Iterable<T> list, String msg) { 
		if(msg.defined) log.logger.error(msg)
		list >> [ log.logger.error(toString) ]
	}
	
	def static <T> printEach(Iterable<T> list) { printEach(list, null) }
	def static <T> trace(Log log, Iterable<T> list) { trace(log, list, null) }
	def static <T> debug(Log log, Iterable<T> list) { debug(log, list, null) }
	def static <T> info(Log log, Iterable<T> list) { info(log, list, null) }
	def static <T> warn(Log log, Iterable<T> list) { warn(log, list, null) }
	def static <T> error(Log log, Iterable<T> list) { error(log, list, null) }
	
}
