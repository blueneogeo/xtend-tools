package nl.kii.util

import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date

import static java.util.Calendar.*
import static extension java.lang.Math.*
import static extension java.util.TimeZone.*

class DateExtensions {

	val static standardDateFormat = "yyyy-MM-dd'T'HH:mm:ss"

	/** The current date */
	def static now() { new Date }

	/** Create a date for a specific calendar moment */
	def static moment(int year, int month, int day) {
		moment(year, month, day, 0, 0, 0, 0)
	}

	/** Create a date for a specific calendar moment */
	def static moment(int year, int month, int day, int hour, int min, int sec) {
		moment(year, month, day, hour, min, sec, 0)
	}
	
	/** Create a date for a specific calendar moment */
	def static moment(int year, int month, int day, int hour, int min, int sec, int ms) {
		new Date().withCalendar [
			set(YEAR, year)
			set(MONTH, month)
			set(DAY_OF_MONTH, day)
			set(HOUR_OF_DAY, hour)
			set(MINUTE, min)
			set(SECOND, sec)
			set(MILLISECOND, ms)
		]
	}

	// DATE CONVERSIONS ///////////////////////////////////////////////////
	
	/** Convert a date to UTC timezone */
	def static toUTC(Date date) {
		val cal = date.toCalendar
		date - new Period(cal.get(DST_OFFSET) + cal.get(ZONE_OFFSET) - cal.get(DST_OFFSET))
	}

	/** Convert a date to a specific timezone */
	def static toTimeZone(Date date, String zone) {
		date.toUTC + new Period(zone.timeZone.rawOffset)
	}

	/** Convert a date to a calendar instance */
	def static toCalendar(Date date) {
		Calendar.instance => [ time = date ]
	}
	
	// DATE GETTERS ///////////////////////////////////////////////////////

	@Deprecated
	def static getCurrentMinute(Date date) { date.mins }
	@Deprecated
	def static getCurrentSecond(Date date) { date.secs }
	@Deprecated
	def static getHourOfDay(Date date) { date.hours24 }

	def static int getMs(Date date) { date.toCalendar.get(MILLISECOND) }
	def static int getSecs(Date date) { date.toCalendar.get(SECOND) }
	def static int getMins(Date date) { date.toCalendar.get(MINUTE) }
	def static int getHours24(Date date) { date.toCalendar.get(HOUR_OF_DAY) }
	def static int getDays(Date date) { date.toCalendar.get(DAY_OF_MONTH) }
	def static int getMonths(Date date) { date.toCalendar.get(MONTH) }
	def static int getYearAD(Date date) { date.toCalendar.get(YEAR) }

	// DATE MANIPULATION ///////////////////////////////////////////////////

	/** Update a date using a calendar object. See the moment(...) methods for example usage. */	
	def static Date withCalendar(Date date, (Calendar)=>void updateFn) {
		val calendar = date.toCalendar
		updateFn.apply(calendar)
		return calendar.time
	}

	// DATE FORMATTING ////////////////////////////////////////////////////
	
	/** quickly format a date to the standard "yyyy-MM-dd'T'HH:mm:ss" format. */
	def static format(Date date) { date.format(standardDateFormat) }
	
	/** 
	 * quickly format a date to a specified format. see all formatting options at 
	 * http://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html
	 */
	def static format(Date date, String format) { new SimpleDateFormat(format).format(date) } 

	// DATE COMPARISONS ///////////////////////////////////////////////////
	
	/** Return the most recent date */
	def static newest(Date... dates) { dates.filter[it!=null].sortBy[time].reverse.head }

	/** Return the oldest date */
	def static oldest(Date... dates) { dates.filter[it!=null].sortBy[time].head }

	/** Return the date nearest to the specified {@code target}, or {@code null} if the iterable is empty. */
	def static nearest(Iterable<? extends Date> dates, Date target) { 
		dates.filterNull.reduce [ leading, contestant | 
			if (interval(target, contestant) < interval(target, leading)) contestant 
			else leading
		]
	}
	
	/** the date is more than [period] old */	
	def static > (Date date, Period period) { now - date > period }
	
	/** the date is more or equals than [period] old */	
	def static >= (Date date, Period period) { now - date >= period }
	
	/** the date is less than [period] old */	
	def static < (Date date, Period period) { now - date < period }
	
	/** the date is less or equals than [period] old */	
	def static <= (Date date, Period period) { now - date <= period }

	/** Difference between dates, largest first */
	def static - (Date d1, Date d2) { new Period(d1.time - d2.time) }
	
	/** Absolute difference between two dates. */
	def static interval(Date d1, Date d2) { new Period((d1.time - d2.time).abs) }

	// PERIOD CREATION ////////////////////////////////////////////////////
	
	def static ms(long value) { new MilliSeconds(value) }
	def static sec(long value) { new Seconds(value) }
	def static secs(long value) { new Seconds(value) }
	def static min(long value) { new Minutes(value) }
	def static mins(long value) { new Minutes(value) }
	def static hour(long value) { new Hours(value) }
	def static hours(long value) { new Hours(value) }
	def static day(long value) { new Days(value) }
	def static days(long value) { new Days(value) }
	def static year(long value) { new Years(value) }
	def static years(long value) { new Years(value) }

	// PERIOD MANIPULATION ////////////////////////////////////////////////

	def static + (Period p1, Period p2) { new Period(p1.time + p2.time) }
	def static - (Period p1, Period p2) { new Period(p1.time - p2.time) }
	def static / (Period p1, Period p2) { p1.time.doubleValue / p2.time.doubleValue }
	def static / (Period p1, int n) { new Period(p1.time / n) }
	def static * (int n, Period p1) { new Period(n * p1.time) }
	def static * (Period p1, int n) { n * p1 }
	def static abs(Period p) { new Period(p.time.abs) }

	// PERIOD COMPARISON //////////////////////////////////////////////////

	def static > (Period p1, Period p2) { p1.time > p2.time }
	def static >= (Period p1, Period p2) { p1.time >= p2.time }
	def static < (Period p1, Period p2) { p1.time < p2.time }
	def static <= (Period p1, Period p2) { p1.time <= p2.time }
	def static min(Period p1, Period p2) { new Period(min(p1.time, p2.time)) }
	def static max(Period p1, Period p2) { new Period(max(p1.time, p2.time)) }

	// DATE CHANGING USING PERIODS ////////////////////////////////////////
	
	def static add(Date date, Period p) { new Date(date.time + p.time) }
	def static subtract(Date date, Period p) { new Date(date.time - p.time) }
	def static + (Date date, Period p) { add(date, p) }
	def static - (Date date, Period p) { subtract(date, p) }

}

// PERIOD CLASSES //////////////////////////////////////////////////////////

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
