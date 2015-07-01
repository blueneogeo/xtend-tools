package nl.kii.util

import org.slf4j.Logger
import org.eclipse.xtend.lib.annotations.Data

/**
 * Better logging for Xtend. Usage:
 * <ul>
 * <li>import static extension nl.kii.tools.XtendTools.*
 * <li>import static extension org.slf4j.LoggerFactory.*
 * <li>Declaration: extension Log logger = class.logger.wrapper
 * <li>Usage example: info ['''bulk shown «bulkShownUsers.size» out of the requested ''']
 * </ul>
 */
@Data class Log {

	protected Logger logger
	protected String name
	
	// deferred logging functions
	
	def trace((Object)=>String message) {
		if(logger.traceEnabled) logger.trace(message.entry)
	}
	
	def debug((Object)=>String message) {
		if(logger.debugEnabled) logger.debug(message.entry)
	}

	def info(String message) {
		if(logger.infoEnabled) logger.info(message.entry)
	}

	def info((Object)=>String message) {
		if(logger.infoEnabled) logger.info(message.entry)
	}

	def warn(String message) {
		if(logger.warnEnabled) logger.warn(message.entry)
	}

	def warn((Object)=>String message) {
		if(logger.warnEnabled) logger.warn(message.entry)
	}
	
	def error(String message, Throwable t) {
		if(logger.errorEnabled) logger.error([message].entry, t) 
	}	
	
	// logging function functions
	
	def <T> (T)=>void trace() { [ logger.trace(toString) ] }
	
	def <T> (T)=>void debug() { [ logger.debug(toString) ] }

	def <T> (T)=>void info() { [ logger.info(toString) ] }
	
	def <T> (T)=>void warn() { [ logger.warn(toString) ] }
	
	def <T> (T)=>void error() { [ logger.error(toString) ] }

	// protected helper methods

	def protected getEntry(String message) {
		if(name != null) '''«name»: «message»'''.toString
		else message
	}

	def protected getEntry((Object)=>String message) {
		message.apply(null).entry
	}
	
}
