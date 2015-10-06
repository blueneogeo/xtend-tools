package nl.kii.util
import static extension org.junit.Assert.*
import org.junit.Test
import static extension nl.kii.util.PartialURL.*

class TestPartialURL {
	
	@Test
	def void testURLBuilding() {
		val url = new PartialURL => [
			protocol = 'http'
			assertFalse(valid)
			domain = 'cnn.com'
			assertTrue(valid)
			path = '/index.html'
			hash = 'test'
		]
		assertEquals('http://cnn.com/index.html#test', url.toString)
	}
	
	@Test
	def void testURLParsing() {
		val text = 'http://www.test.com/somepath/to/nowhere?p1=10&p2=hello#somehash:somewhere'
		val url = new PartialURL(text)
		assertEquals(text, url.toString)
		assertEquals('10', url.parameters.get('p1'))
		assertEquals('hello', url.parameters.get('p2'))
		assertTrue(url.valid)
	}
	
	@Test
	def void testBadURL() {
		val text = 'just a test'
		assertFalse(text.valid)
	}
	
	@Test
	def void testSupportsNoValueParameters() {
		val url = new PartialURL('/twitter/timeline?telegraaf')
		assertFalse(url.parameters.empty)
		assertEquals('telegraaf', url.parameters.keySet.head)
	}
	
	@Test
	def void testFullPath() {
		val url = new PartialURL('https://api.twitter.com/1/statuses/update.json?include_entities=true')
		assertEquals('https://api.twitter.com/1/statuses/update.json', url.fullPath)
	}

}
