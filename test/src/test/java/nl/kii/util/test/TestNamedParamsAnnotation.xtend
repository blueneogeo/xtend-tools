package nl.kii.util.test

import nl.kii.util.annotations.B
import nl.kii.util.annotations.I
import nl.kii.util.annotations.NamedParams
import nl.kii.util.annotations.Pin
import nl.kii.util.annotations.S
import org.junit.Test

import static org.junit.Assert.*

class TestNamedParamsAnnotation {
	
	/** A more mundane test */
	@NamedParams
	final def getGreeting(@Pin String user, @I(12) Integer age, @B(true) boolean happy) {
		'hello I am ' + user + ' and I am ' + age + ' years old and ' + if(happy) 'happy' else 'sad'
	}

	@Test
	def void testMethodWithDefaults() {
		assertEquals('hello I am christian and I am 43 years old and happy', 'christian'.getGreeting [ age = 43 ])
		assertEquals('hello I am christian and I am 20 years old and happy', 'christian'.getGreeting [ age = 20 ])
		assertEquals('hello I am christian and I am 43 years old and sad', 'christian'.getGreeting [ age = 43 happy = false ])
		assertEquals('hello I am christian and I am 12 years old and sad', 'christian'.getGreeting [ happy = false ])
	}

	@Test
	def void testConstructorWithDefaults() {
		assertEquals('hello I am christian and I am 43 years old and happy', new Tester[ age = 43 ].greeting)
		assertEquals('hello I am christian and I am 20 years old and happy', new Tester[ age = 20 ].greeting)
		assertEquals('hello I am christian and I am 43 years old and sad', new Tester[ age = 43 happy = false ].greeting)
		assertEquals('hello I am christian and I am 12 years old and sad', new Tester[ happy = false ].greeting)
	}

}

class Tester {
	
	String name
	int age
	boolean happy
	
	@NamedParams
	new(@S('christian') String name, @I(12) int age, @B(true) boolean happy) {
		this.name = name
		this.age = age
		this.happy = happy
	}

	final def getGreeting() {
		'hello I am ' + name + ' and I am ' + age + ' years old and ' + if(happy) 'happy' else 'sad'
	}
	
}
