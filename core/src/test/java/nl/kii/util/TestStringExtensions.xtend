package nl.kii.util
import static extension nl.kii.util.StringExtensions.*
import org.junit.Test
import static extension org.junit.Assert.*

class TestStringExtensions {
	
	@Test
	def void testFill() {
		val message = 'Hello {}, this is your friendly {}.'.fill('Christian', 'xtend code')
		println(message)
		assertEquals('Hello Christian, this is your friendly xtend code.', message)
	}
	
	@Test
	def void testFillWithPositions() {
		val message = 'Hello {1}, this is your {} {2}.'.fill('Christian', 'xtend code', 'friendly')
		println(message)
		assertEquals('Hello Christian, this is your friendly xtend code.', message)
	}

}
