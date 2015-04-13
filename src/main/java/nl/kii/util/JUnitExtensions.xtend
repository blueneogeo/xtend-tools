package nl.kii.util

import static extension org.junit.Assert.*

class JUnitExtensions {
	
	def static <T> <=> (T value, T expected) {
		assertEquals(expected, value)
	}

}