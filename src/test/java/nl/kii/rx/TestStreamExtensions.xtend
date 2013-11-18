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
			.map ['got number ' + it]
			.each [println(it)]
			.each [println('printing again: ' + it)]
			.onFinish [println('we are done!')]
			.onError [println('caught: ' + it)]
			.start

		stream << 2 << 5 << 3 << new Exception('intentional error') << finish

		// Identical to:
		//		stream => [
		//			apply(2)
		//			apply(5)
		//			apply(3)
		//			error(new Exception('this error is intentional'))
		//			finish
		//		]
	}

	@Test
	def void testConnectedStream() {
		#[1, 2, 3].streamTo(handler)
	}

	val handler = Integer.stream => [
		each [println('handler got number: ' + it)].start
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

	@Test
	def void testUntil() {
		val stream = Integer.stream
		stream.until[it>10].map[toString].toList >> [println(join(', '))]
		stream << 4 << 8 << 10 << 11 << 5 << finish
	}

	@Test
	def void testWhile() {
		val stream = Integer.stream
		stream.while_[it<=10].map[toString].toList >> [println(join(', '))]
		stream << 4 << 8 << 10 << 11 << 5 << finish
	}

}