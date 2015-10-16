package nl.kii.util

import org.junit.Test

import static extension nl.kii.util.MapExtensions.*
import static extension org.junit.Assert.*

class TestMapExtensions {
	
	@Test
	def void testMapMapping() {
		#{1->5, 2->6}
			.map [ k, v | k+1 -> v+1]
			.assertEquals(#{2->6, 3->7})
	}
	
	@Test
	def void testImmutableMapOperations() {
		val map = #{ 'key1' -> 'value1', 'key2' -> 'value2' }
		val pair = 'key3' -> 'value3'
		
		/** Addition should succeed */
		assertEquals(map + pair, #{ 'key1' -> 'value1', 'key2' -> 'value2', 'key3' -> 'value3' })
		
		/** Old map should be untouched after addition */
		assertEquals(map, #{ 'key1' -> 'value1', 'key2' -> 'value2' })
	}
	
}
