package nl.kii.util

import org.slf4j.Logger

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

	Logger logger
	String name
	
	def trace((Object)=>String message) {
		if(logger.traceEnabled) logger.trace(message.entry)
	}
	
	def debug((Object)=>String message) {
		if(logger.debugEnabled) logger.debug(message.entry)
	}

	def info((Object)=>String message) {
		if(logger.infoEnabled) logger.info(message.entry)
	}

	def warn((Object)=>String message) {
		if(logger.warnEnabled) logger.warn(message.entry)
	}
	
	def error((Object)=>String message) {
		if(logger.errorEnabled) logger.error(message.entry)
	}
	
	def protected getEntry((Object)=>String message) {
		if(name != null) '''«name»: «message.apply(null)»'''.toString
		else message.apply(null)
	}	

}
