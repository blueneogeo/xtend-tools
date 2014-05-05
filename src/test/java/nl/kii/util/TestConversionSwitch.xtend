package nl.kii.util

import org.junit.Test

import static org.junit.Assert.*

import static extension nl.kii.util.IterableExtensions.*

class TestConversionSwitch {
	
	@Test
	def void testSwitch() {
	
		val list = #[1, 2, 3]
		val map = #{ 1->'A', 2->'B' }
		
		switch list {
			case list.isListOf(Integer): println('list ok')
			case list.isListOf(String): fail('not a list of a string')
			default: fail('no match found for list')
		}
		
		switch map {
			case map.isMapOf(Integer, String): println('map ok')
			case map.isMapOf(String, String): fail('not map of string->string')
			default: fail('no match found for map')
		}
		
	}

}