package nl.kii.rx

import org.junit.Test

import static extension nl.kii.rx.StreamExtensions.*
import static extension org.junit.Assert.*

class TestStreamExtensions {
	
	@Test
	def void testRXStream() {
		
		val stream = Integer.stream

		stream
			.take(6)
			.map [ 'got number ' + it ]
			.each [ println('a: ' + it) ]
			.onFinish [ println('we are done!') ]
			.onError [ println('caught: ' + it)]
			.start

		stream => [
			apply(2)
			apply(5)
			apply(3)
			error(new Exception('this error is intentional'))
			finish
		]
	}
	
	@Test
	def void testConnectedStream() {
		#[1, 2, 3].streamTo(handler)
	}
	
	val handler = Integer.stream => [
		each [ println('handler got number: ' + it)].start
	]
	
	@Test
	def void testCollector() {
		val s = Integer.stream
		val bucket = s.collect
		s << 3 << 4
		bucket.get.length.assertEquals(2)
		s << 2 << 9
		bucket.get.length.assertEquals(4)
		bucket.clear
		bucket.get.length.assertEquals(0)
	}

}
