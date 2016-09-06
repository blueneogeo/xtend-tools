package nl.kii.util.annotations

import nl.kii.util.annotation.Default
import nl.kii.util.annotation.DefaultTrue
import nl.kii.util.annotation.DefaultValue
import nl.kii.util.annotation.Locked
import nl.kii.util.annotation.NamedParams
import org.junit.Test

import static org.junit.Assert.*

class TestNamedParamsAnnotation {
	
	/** A more mundane test */
	@NamedParams
	final def getGreeting(@Locked String user, @DefaultValue(12) Integer age, @DefaultTrue boolean happy) {
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
	new(@Default('christian') String name, @DefaultValue(12) int age, @DefaultTrue boolean happy) {
		this.name = name
		this.age = age
		this.happy = happy
	}

	final def getGreeting() {
		'hello I am ' + name + ' and I am ' + age + ' years old and ' + if(happy) 'happy' else 'sad'
	}
	
}
