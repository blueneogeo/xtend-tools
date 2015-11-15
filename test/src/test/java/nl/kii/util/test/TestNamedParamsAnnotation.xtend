package nl.kii.util.test

import nl.kii.util.annotations.B
import nl.kii.util.annotations.I
import nl.kii.util.annotations.Lock
import nl.kii.util.annotations.NamedParams
import org.junit.Test

class TestNamedParamsAnnotation {
	
	/** A more mundane test */
	@NamedParams
	def void setUser(@Lock String user, @I(12) Integer age, @B(true) boolean happy) {
		println('hello I am ' + user + ' and I am ' + age + ' years old and ' + if(happy) 'happy' else 'sad')
	}

	@Test
	def void test() {
		setUser('christian') [ 
			age = 43
		]
	}

}
