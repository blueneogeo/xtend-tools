package nl.kii.util

import java.util.Date

class DateExtensions {

	/** The current date */
	def static now() { new Date }

	/** Return the most recent date */
	def static newest(Date... dates) { dates.filter[it!=null].sortBy[time].reverse.head }

	/** Return the oldest date */
	def static oldest(Date... dates) { dates.filter[it!=null].sortBy[time].head }

	/** See if a date is older than a given period (since right now) */
	def static isOlderThan(Date date, Period period) { now - date > period }
	/** the date is more than [period] old */	
	def static operator_greaterThan(Date date, Period period) { now - date > period }
	/** the date is more or equals than [period] old */	
	def static operator_greaterEqualsThan(Date date, Period period) { now - date >= period }
	/** the date is less than [period] old */	
	def static operator_lessThan(Date date, Period period) { now - date < period }
	/** the date is less or equals than [period] old */	
	def static operator_lessEqualsThan(Date date, Period period) { now - date <= period }

	/** Difference between dates, largest first */
	def static diff(Date d1, Date d2) { new Period(d1.time - d2.time) }
	def static operator_minus(Date d1, Date d2) { diff(d1, d2) }

	def static add(Period p1, Period p2) {	new Period(p1.time + p2.time) }
	def static subtract(Period p1, Period p2) { new Period(p1.time - p2.time) }
	def static operator_plus(Period p1, Period p2) { add(p1, p2) }
	def static operator_minus(Period p1, Period p2) { subtract(p1, p2) }
	
	def static add(Date date, Period p) { new Date(date.time + p.time) }
	def static subtract(Date date, Period p) { new Date(date.time - p.time) }
	def static operator_plus(Date date, Period p) { add(date, p) }
	def static operator_minus(Date date, Period p) { subtract(date, p) }

	def static operator_greaterThan(Period p1, Period p2) { p1.time > p2.time }
	def static operator_greaterEqualsThan(Period p1, Period p2) { p1.time >= p2.time }
	def static operator_lessThan(Period p1, Period p2) { p1.time < p2.time }
	def static operator_lessEqualsThan(Period p1, Period p2) { p1.time <= p2.time }

	def static secs(long value) { new Seconds(value) }
	def static mins(long value) { new Minutes(value) }
	def static hours(long value) { new Hours(value) }
	def static days(long value) { new Days(value) }
	def static years(long value) { new Years(value) }

}

class Period {
	val long time
	
	new(long time) { this.time = time	} 
	
	def long time() { time }
	
	def secs() { time / 1000 }
	def mins() { time / 1000 / 60 }
	def hours() { time / 1000 / 60 / 60 }
	def days() { time / 1000 / 60 / 60 / 24 }
	def years() { time / 1000 / 60 / 60 / 24 / 356 }
	
	override equals(Object obj) {
		if(obj instanceof Period) obj.time == time else false
	}

	override hashCode() { new Long(time).hashCode }
}

class MilliSeconds extends Period { 
	new(long ms) { super(ms) }
}

class Seconds extends Period { 
	new(long secs) { super(secs * 1000) }
}

class Minutes extends Period { 
	new(long mins) { super(mins * 1000 * 60) }
}

class Hours extends Period { 
	new(long hrs) { super(hrs * 1000 * 60 * 60) }
}

class Days extends Period { 
	new(long days) { super(days * 1000 * 60 * 60 * 24) }
}

class Years extends Period { 
	new(long years) { super(years * 1000 * 60 * 60 * 24 * 365) }
}

