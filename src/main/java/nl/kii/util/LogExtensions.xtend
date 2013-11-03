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
		list.each [ println(logEntry) ]
	}

	def static <T> trace(Iterable<T> list, String msg, Log log) { 
		if(msg.defined) log.logger.trace(msg)
		list.each [ log.logger.trace(logEntry) ]
	}
	
	def static <T> debug(Iterable<T> list, String msg, Log log) { 
		if(msg.defined) log.logger.debug(msg)
		list.each [ log.logger.debug(logEntry) ]
	}
	
	def static <T> info(Iterable<T> list, String msg, Log log) { 
		if(msg.defined) log.logger.info(msg)
		list.each [ log.logger.info(logEntry) ]
	}
	
	def static <T> warn(Iterable<T> list, String msg, Log log) { 
		if(msg.defined) log.logger.warn(msg)
		list.each [ log.logger.warn(logEntry) ]
	}
	
	def static <T> error(Iterable<T> list, String msg, Log log) { 
		if(msg.defined) log.logger.error(msg)
		list.each [ log.logger.error(logEntry) ]
	}
	
	def protected static getLogEntry(Object o) { ' - ' + o.toString }
	
	def static <T> printEach(Iterable<T> list) { printEach(list, null) }
	def static <T> trace(Iterable<T> list, Log log) { trace(list, null, log) }
	def static <T> debug(Iterable<T> list, Log log) { debug(list, null, log) }
	def static <T> info(Iterable<T> list, Log log) { info(list, null, log) }
	def static <T> warn(Iterable<T> list, Log log) { warn(list, null, log) }
	def static <T> error(Iterable<T> list, Log log) { error(list, null, log) }
	
}
