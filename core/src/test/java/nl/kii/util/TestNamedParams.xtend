package nl.kii.util

import static extension org.junit.Assert.*
import org.junit.Test
import nl.kii.util.annotations.NamedParams

class TestNamedParams {
	
	@Test
	def void testNamedParams() {
		assertEquals('hello chris of age 42, how are you?', getGreetingMessage('chris', 42, 'how are you?'))
		assertEquals('hello chris of age 42, how are you?', getGreetingMessage [
			name = 'chris'
			age = 42
			greeting = 'how are you?'
		])
	}

	@NamedParams	
	def String getGreetingMessage(String name, int age, String greeting) {
		'hello ' + name + ' of age ' + age + ', ' + greeting
	}
	
	
}
