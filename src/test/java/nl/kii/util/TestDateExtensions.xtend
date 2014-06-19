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
		assertEquals(2, (now - now.toUTC).hours)
	}
	
}
