package nl.kii.rx

import nl.kii.rx.Collector
import nl.kii.rx.Countdown
import org.junit.Test

import static extension nl.kii.rx.StreamExtensions.*

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
		each [ println('handler got number: ' + it)]
	]
	
	@Test
	def void testCountDown() {
		val countdown = new Countdown
		val c1 = countdown.await
		val c2 = countdown.await
		val c3 = countdown.await
		countdown.stream
			.each [ println('counting...') ]
			.onFinish [ println('countdown done. success:' + countdown.success) ]
		c2.apply(true)
		c1.apply(true)
		c3.apply(true)
	}
	
	@Test
	def void testCollector() {
		val collector = new Collector<String>
		val cuser = collector.await('user')
		val cname = collector.await('name')
		val cage = collector.await('age')
		
		collector.stream
			.each [ println('got ' + it.key + ' has value ' + it.value)]
			.onFinish [
				val it = collector.result
				println('found user ' + get('user'))
				println('found name ' + get('name'))
				println('found age ' + get('age'))
			]

		cage.apply('12')
		cname.apply('John')
		cuser.apply('Christian')
	}

}
