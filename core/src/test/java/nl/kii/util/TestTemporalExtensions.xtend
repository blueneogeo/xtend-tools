package nl.kii.util

import org.junit.Test

import static org.junit.Assert.*

import static extension nl.kii.util.TemporalExtensions.*

class TestTemporalExtensions {
	
	@Test
	def void test() {
		val d1 = 2.days + 10.mins + 30.secs
		val d2 = 48.hours + 600.secs + 30_000.ms
		assertEquals(d1, d2)
	}
	
//	@Test
//	def void testUTCZone() {
//		val originalTimeZone = TimeZone.^default
//		TimeZone.^default = TimeZone.getTimeZone( 'UTC' )
//		
//		assertEquals(0, (now - now.toUTC).hours)
//		assertEquals(-1, (now - now.toTimeZone('GMT+1')).hours)
//		
//		TimeZone.^default = originalTimeZone
//	}
	
//	@Test
//	def void testPeriodToString() {
//		val period = 2.days + 7.hours + 9.mins + 20.secs + 1.ms
//		println(period)
//		assertEquals('3 years, 2 days, 7 hours, 9 minutes, 20 seconds, 1 milliseconds', period.toString)
//	}
	
	@Test
	def void testComparability() {
		val periods = #[ 1.day, 10.ms, 100.secs, 1.min ]
		
		assertEquals(
			#[ 10.ms, 1.min, 100.secs, 1.day ],
			periods.sort
		)
	}
	
	@Test
	def void testNearest() {
		val now = now
		
		val d1 = now
		val d2 = now - 10.mins
		val d3 = now - 20.mins
		val d4 = now - 30.mins
		val d5 = now - 40.mins
		
		val target = now - 22.mins
		
		val dates = #[ d1, d5, d2, d3, d4 ]
		
		assertEquals(dates.nearest(target), d3)
		
		
		assertEquals(#[].nearest(target), null)
	}
}
