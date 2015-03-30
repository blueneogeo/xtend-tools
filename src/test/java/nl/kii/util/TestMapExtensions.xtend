package nl.kii.util
import static extension org.junit.Assert.*
import static extension nl.kii.util.MapExtensions.*
import org.junit.Test

class TestMapExtensions {
	
	@Test
	def void testMapMapping() {
		#{1->5, 2->6}
			.map [ k, v | k+1 -> v+1]
			.assertEquals(#{2->6, 3->7})
	}
	
}
