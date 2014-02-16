package nl.kii.listen

import org.junit.Test

import static extension nl.kii.rx.StreamExtensions.*

class TestListenable {
	
	@Test
	def void testPublisher() {
		val p = new Publisher<String>
		
		p.onChange [
			println('got ' + it)
		]

		p.stream.each [ println('stream also works, got ' + it) ]
				
		p.publish('hoi')
		
	}

}
