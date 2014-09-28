package nl.kii.util
import static extension nl.kii.util.URL.*
import static extension org.junit.Assert.*
import org.junit.Test

class TestURL {
	
	@Test
	def void testURLParsing() {
		val text = 'http://www.test.com/somepath/to/nowhere?p1=10&p2=hello#somehash:somewhere'
		val url = new URL(text)
		assertEquals(text, url.toString)
		assertEquals('10', url.parameters.get('p1'))
		assertEquals('hello', url.parameters.get('p2'))
		assertTrue(text.valid)
	}
	
	@Test
	def void testBadURL() {
		val text = 'just a test'
		assertFalse(text.valid)
	}

}