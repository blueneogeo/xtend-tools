package nl.kii.util

import java.time.Duration
import java.time.Instant
import java.time.format.DateTimeFormatter
import java.time.temporal.TemporalAmount

import static extension nl.kii.util.IterableExtensions.*

class TemporalExtensions {

	val static standardDateFormat = "yyyy-MM-dd'T'HH:mm:ss"

	/** The current date */
	def static now() { Instant.now }

//	def static toLegacyDate(Instant instant) {
//		Date.from(instant)
//	}
	
//	/** Create a date for a specific calendar moment */
//	def static moment(int year, int month, int day) {
//		moment(year, month, day, 0, 0, 0, 0)
//	}

//	/** Create a date for a specific calendar moment */
//	def static moment(int year, int month, int day, int hour, int min, int sec) {
//		moment(year, month, day, hour, min, sec, 0)
//	}
//	
//	/** Create a date for a specific calendar moment */
//	def static moment(int year, int month, int day, int hour, int min, int sec, int ms) {
//		new Date().withCalendar [
//			set(YEAR, year)
//			set(MONTH, month)
//			set(DAY_OF_MONTH, day)
//			set(HOUR_OF_DAY, hour)
//			set(MINUTE, min)
//			set(SECOND, sec)
//			set(MILLISECOND, ms)
//		]
//	}

	// DATE CONVERSIONS ///////////////////////////////////////////////////
	
//	/** Convert a date to UTC timezone */
//	def static toUTC(Instant date) {
//		val cal = date.toCalendar
//		date - new Duration(cal.get(DST_OFFSET) + cal.get(ZONE_OFFSET) - cal.get(DST_OFFSET))
//	}

//	/** Convert a date to a specific timezone */
//	def static toTimeZone(Date date, String zone) {
//		date.toUTC + new Duration(zone.timeZone.rawOffset)
//	}
//
//	/** Convert a date to a calendar instance */
//	def static toCalendar(Date date) {
//		Calendar.instance => [ time = date ]
//	}
	
	// DATE GETTERS ///////////////////////////////////////////////////////

//	@Deprecated
//	def static getCurrentMinute(Date date) { date.mins }
//	@Deprecated
//	def static getCurrentSecond(Date date) { date.secs }
//	@Deprecated
//	def static getHourOfDay(Date date) { date.hours24 }
//
//	def static int getMs(Date date) { date.toCalendar.get(MILLISECOND) }
//	def static int getSecs(Date date) { date.toCalendar.get(SECOND) }
//	def static int getMins(Date date) { date.toCalendar.get(MINUTE) }
//	def static int getHours24(Date date) { date.toCalendar.get(HOUR_OF_DAY) }
//	def static int getDays(Date date) { date.toCalendar.get(DAY_OF_MONTH) }
//	def static int getMonths(Date date) { date.toCalendar.get(MONTH) }
//	def static int getYearAD(Date date) { date.toCalendar.get(YEAR) }

	// DATE MANIPULATION ///////////////////////////////////////////////////

//	/** Update a date using a calendar object. See the moment(...) methods for example usage. */	
//	def static Date withCalendar(Date date, (Calendar)=>void updateFn) {
//		val calendar = date.toCalendar
//		updateFn.apply(calendar)
//		return calendar.time
//	}

	// DATE FORMATTING ////////////////////////////////////////////////////
	
	/** quickly format a date to the standard "yyyy-MM-dd'T'HH:mm:ss" format. */
	def static format(Instant instant) { instant.format(standardDateFormat) }
	
	/** 
	 * quickly format a date to a specified format. see all formatting options at 
	 * http://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html
	 */
	def static format(Instant instant, String format) { DateTimeFormatter.ofPattern(format).format(instant) } 

	// DATE COMPARISONS ///////////////////////////////////////////////////
	
	/** Return the most recent date */
	def static newest(Instant... instants) { instants.maxSafe }

	/** Return the oldest date */
	def static oldest(Instant... instants) { instants.minSafe }

	/** Return the date nearest to the specified {@code target}, or {@code null} if the iterable is empty. */
	def static nearest(Iterable<? extends Instant> instants, Instant target) { 
		instants.filterNull.reduce [ leading, contestant | 
			if (interval(target, contestant) < interval(target, leading)) contestant 
			else leading
		]
	}
	
	/** the date is more than [Duration] old */	
	def static > (Instant instant, Duration duration) { now - instant > duration }
	
	/** the date is more or equals than [Duration] old */	
	def static >= (Instant instant, Duration duration) { now - instant >= duration }
	
	/** the date is less than [Duration] old */	
	def static < (Instant instant, Duration duration) { now - instant < duration }
	
	/** the date is less or equals than [Duration] old */	
	def static <= (Instant instant, Duration duration) { now - instant <= duration }

	/** Difference between dates, largest first */
	def static - (Instant i1, Instant i2) { Duration.between(i1, i2) }
	
	/** Absolute difference between two dates. */
	def static interval(Instant i1, Instant i2) { Duration.between(i1, i2).abs }

	// DURATION CREATION ////////////////////////////////////////////////////
	
	def static ms(long value) { Duration.ofMillis(value) }
	def static secs(long value) { Duration.ofSeconds(value) }
	def static sec(long value) { value.secs }
	def static mins(long value) { Duration.ofMinutes(value) }
	def static min(long value) { value.mins }
	def static hours(long value) { Duration.ofHours(value) }
	def static hour(long value) { value.hours }
	def static days(long value) { Duration.ofDays(value) }
	def static day(long value) { value.days }
	//def static years(long value) { Duration.of(value, ChronoUnit.YEARS) }
	//def static year(long value) { value.years }

	def static ms(Duration duration) { duration.toMillis }
	def static secs(Duration duration) { duration.toMillis / 1000 }
	def static mins(Duration duration) { duration.toMinutes }
	def static hours(Duration duration) { duration.toHours }
	def static days(Duration duration) { duration.toDays }
	def static years(Duration duration) { duration.toDays / 365 }
	
	// DURATION MANIPULATION ////////////////////////////////////////////////

	def static + (Duration d1, Duration d2) { d1.plus(d2) }
	def static - (Duration d1, Duration d2) { d1.minus(d2) }
	def static / (Duration d1, Duration d2) { d1.toMillis / d2.toMillis }
	def static / (Duration d1, int n) { d1.dividedBy(n) }
	def static * (int n, Duration d1) { d1.multipliedBy(n) }
	def static * (Duration d1, int n) { n * d1 }

	// DURATION COMPARISON //////////////////////////////////////////////////

	def static > (Duration d1, Duration d2) { d1.compareTo(d2) > 0 }
	def static >= (Duration d1, Duration d2) { d1.compareTo(d2) >= 0 }
	def static < (Duration d1, Duration d2) { d1.compareTo(d2) < 0 }
	def static <= (Duration d1, Duration d2) { d1.compareTo(d2) <= 0 }
	def static min(Duration d1, Duration d2) { minSafe(d1, d2) }
	def static max(Duration d1, Duration d2) { maxSafe(d1, d2) }

	// DATE CHANGING USING DurationS ////////////////////////////////////////
	
	def static add(Instant instant, TemporalAmount amount) { instant.plus(amount) }
	def static subtract(Instant instant, TemporalAmount amount) { instant.minus(amount) }
	def static + (Instant instant, TemporalAmount amount) { add(instant, amount) }
	def static - (Instant instant, TemporalAmount amount) { subtract(instant, amount) }

}

// DURATION CLASSES //////////////////////////////////////////////////////////
