package nl.kii.rx

import org.junit.Test

import static nl.kii.util.OptExtensions.*

import static extension nl.kii.rx.OptStreamExtensions.*
import static extension nl.kii.rx.StreamExtensions.*

class TestOptStreamExtensions {
	
	@Test
	def void testOptStream() {
		val stream = String.stream
		stream.options
			.onSome [ println('got ' + it) ]
			.onNone [ println('none') ]
			.onErr [ println('error') ]
		stream << 'hey' << 'hi'
		// stream.error(new Exception('error!'))
		stream.apply(none)
		stream.finish
	}
	
	@Test
	def void testConditionalOptStream() {
		val stream = Integer.stream
		stream.options [ it < 4 ]
			.or (10)
			.each [ println('greater than 5: ' + it) ]
			.onFinish[ println('done') ]
			.onError [ println('error: ' + it)]
		stream << 4 << 9 << 3 << 0 << 5
		stream.finish
	}
	
}