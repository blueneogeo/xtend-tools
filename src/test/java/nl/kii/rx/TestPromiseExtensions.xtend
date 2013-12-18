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
		promise.apply('Hello!')
		
	}
	
	@Test
	def void testAsyncThen() {
		String.promise.apply('Christian')
			.then$ [ return toGreeting$ ]
			.then [	assertEquals('Welcome Christian')
				println('done!')
			]
	}
	
	@Test
	def void testCatchErrors() {
		val promise = String.promise
		promise.map [
			if(it=='error') new Exception('this should be caught in the stream')
			else it
		].then [
			println('this will never arrive')
		].onError [
			println('works correctly!')
		]
		promise << 'error'
	}
	
	def toGreeting$(String test) {
		String.promise.apply(test).map [ 'Welcome ' + it ]
	}

}
