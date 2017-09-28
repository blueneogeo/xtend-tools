package nl.kii.util

import org.slf4j.Logger
import org.eclipse.xtend.lib.annotations.Data
import org.slf4j.LoggerFactory

/**
 * Deferred logging for Xtend. Wraps a org.slf4j.Logger.
 * <p> 
 * This loggers lowers the performance penalty of logging a lot
 * of trace or debug statements.
 * <p>
 * <pre>
 * val logger = LoggerFactory.getLogger(this.class)
 * 
 * // this can become expensive:
 * logger.trace('my message ' + someValue + 'blabla' + calculate())
 * 
 * // so you would do this instead every time:
 * if(logger.traceEnabled) {
 * 	// string is only built if we have trace enabled
 * 	logger.trace('my message ' + someValue + 'blabla' + calculate())
 * }
 * 
 * // but now you can do this, which does the same:
 * val log = new Log(logger)
 * log.trace [ 'my message ' + someValue + 'blabla' + calculate() ]
 * </pre>
 * <p>
 * Usage:
 * <ul>
 * <li>Declaration: extension Log logger = Log.create(this, 'foo')
 * <li>Usage example: info ['''bulk shown «bulkShownUsers.size» out of the requested ''']
 * </ul>
 */
@Data class Log {
	
	/** Create a org.slf4j.Logger */
	static def create(Object instance) {
		create(instance, null)
	}

	/** Create a org.slf4j.Logger that logs under a given name. */
	static def create(Object instance, String name) {
		val logger = LoggerFactory.getLogger(instance.class)
		new Log(logger, name)
	}

	protected Logger logger
	protected String name
	
	// deferred logging functions
	
	def trace(=>String message) {
		if(logger.traceEnabled) logger.trace(message.entry)
	}
	
	def debug(=>String message) {
		if(logger.debugEnabled) logger.debug(message.entry)
	}

	def info(String message) {
		if(logger.infoEnabled) logger.info(message.entry)
	}

	def info(=>String message) {
		if(logger.infoEnabled) logger.info(message.entry)
	}

	def warn(String message) {
		if(logger.warnEnabled) logger.warn(message.entry)
	}

	def warn(=>String message) {
		if(logger.warnEnabled) logger.warn(message.entry)
	}
	
	def error(String message, Throwable t) {
		if(logger.errorEnabled) logger.error(message.entry, t) 
	}	
	
	// logging function functions
	
	def <T> (T)=>void trace() { [ logger.trace(toString) ] }
	
	def <T> (T)=>void debug() { [ logger.debug(toString) ] }

	def <T> (T)=>void info() { [ logger.info(toString) ] }
	
	def <T> (T)=>void warn() { [ logger.warn(toString) ] }
	
	def <T> (T)=>void error() { [ logger.error(toString) ] }

	// protected helper methods

	def protected getEntry(String message) {
		if(name !== null) '''«name»: «message»'''.toString
		else message
	}

	def protected getEntry(=>String message) {
		message.apply.entry
	}
	
}
