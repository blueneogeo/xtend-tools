package nl.kii.util

import org.junit.Test

import static extension nl.kii.util.DateExtensions.*
import static org.junit.Assert.*

class TestDateExtensions {
	
	@Test
	def void test() {
		val x = now - 5.mins - 3.years
		val y = now + 4.days
		assertTrue((y - x) > 3.days)
	}
	
	@Test
	def void testUTCZone() {
		assertEquals(1, (now - now.toUTC).hours)
		assertEquals(0, (now - now.toTimeZone('GMT+1')).hours)
	}
	
	@Test
	def void testPeriodToString() {
		val period = 3.years + 2.days + 7.hours + 9.mins + 20.secs + 1.ms
		assertEquals('3 years, 2 days, 7 hours, 9 minutes, 20 seconds, 1 milliseconds', period.toString)
	}
	
}
