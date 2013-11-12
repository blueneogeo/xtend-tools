package nl.kii.rx

import org.junit.Test

import static extension nl.kii.rx.PromiseExtensions.*
import static extension nl.kii.rx.StreamExtensions.*
import static extension org.junit.Assert.*

class TestPromiseStreamExtensions {
	
	@Test
	def void testRXPromise() {
		
		val promise = String.promise
		
		promise
			.map [ toLowerCase ]
			.map [ 'Hey cool I got this text: ' + it ]
			.each [ println(it) ]
			.onFinish [ println('we are done!') ]
			.onError [ println('caught: ' + it)]
		
		promise.apply('Hello!')
		
	}

	@Test
	def void testRXPromiseOperators() {
		
		val promise = String.promise
		
		promise
			-> [ toLowerCase ]
			-> [ 'Hey cool I got this text: ' + it ]
			>> [ println(it) ]
			.. [ println('we are done!') ]
			?: [ println('caught: ' + it)]
		
		promise.apply('Hello!')
		
	}
	
	@Test
	def void testThen() {
		String.promise.apply('Christian')
			.then [ toGreetingAsync ]
			.then [ assertEquals('Welcome Christian') ]
	}
	
	def toGreetingAsync(String test) {
		String.promise.apply(test).map [ 'Welcome ' + it ]
	}

}
