package nl.kii.rx

import org.junit.Test

import static extension nl.kii.rx.StreamExtensions.*

class TestCollector {
	
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
	def void testGatherer() {
		val collector = new Gatherer<String>
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
