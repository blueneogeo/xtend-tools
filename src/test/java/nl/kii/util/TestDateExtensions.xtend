package nl.kii.util

import org.junit.Test

import static extension nl.kii.util.DateExtensions.*

class TestDateExtensions {
	
	@Test
	def void test() {
		
		val x = now - 5.mins - 3.years
		val y = now + 4.days
		
		val n = newest(x, y)
		println(n)
		
		println((y - x) > 3.days)
	}
	
	@Test
	def void testUTCZone() {
		println(now)
		println(now.toUTC)
	}
	
}