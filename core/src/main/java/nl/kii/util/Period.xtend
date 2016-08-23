package nl.kii.util

class Period implements Comparable<Period> {
	val long time
	
	new(long time) { this.time = time } 
	
	def long time() { time }
	
	def getMs() { time }
	def getSecs() { time / 1000 }
	def getMins() { time / 1000 / 60 }
	def getHours() { time / 1000 / 60 / 60 }
	def getDays() { time / 1000 / 60 / 60 / 24 }
	def getYears() { time / 1000 / 60 / 60 / 24 / 356 }
	
	override toString() {
		val t = switch time {
			case years > 1: new Years(years)
			case days > 1: new Days(days)
			case hours > 1: new Hours(hours)
			case mins > 1: new Minutes(mins)
			case secs > 1: new Seconds(secs)
			default: new MilliSeconds(ms)
		}
		val remainingMs = ms - t.ms
		'''«t»«IF remainingMs > 0», «new Period(remainingMs)»«ENDIF»'''
	}
	
	override equals(Object obj) {
		if(obj instanceof Period) obj.time == time else false
	}

	override hashCode() { new Long(time).hashCode }
	
	override compareTo(Period o) { this.time.compareTo(o.time) }
}

class MilliSeconds extends Period { 
	new(long ms) { super(ms) }
	override toString() '''«ms» milliseconds'''
}

class Seconds extends Period { 
	new(long secs) { super(secs * 1000) }
	override toString() '''«secs» seconds'''
}

class Minutes extends Period { 
	new(long mins) { super(mins * 1000 * 60) }
	override toString() '''«mins» minutes'''
}

class Hours extends Period { 
	new(long hrs) { super(hrs * 1000 * 60 * 60) }
	override toString() '''«hours» hours'''
}

class Days extends Period { 
	new(long days) { super(days * 1000 * 60 * 60 * 24) }
	override toString() '''«days» days'''
}

class Years extends Period { 
	new(long years) { super(years * 1000 * 60 * 60 * 24 * 365) }
	override toString() '''«years» years'''
}
