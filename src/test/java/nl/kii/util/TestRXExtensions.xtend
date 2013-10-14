package nl.kii.util

import org.junit.Test

import static nl.kii.util.OptExtensions.*

import static extension nl.kii.util.RxExtensions.*

class TestRXExtensions {
	
	@Test
	def void testRXStream() {
		
		val stream = Integer.stream

		stream
			.take(3)
			.map [ 'got number ' + it ]
			// .reduce [ a, b | a + ', ' + b ]
			.each [ println('a: ' + it) ]
			.onFinish [ println('we are done!') ]
			.onError [ println('caught: ' + it)]

		stream => [
			apply(2)
			apply(5)
			apply(3)
			complete
			// apply(error)
		]
	}
	
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
	def void testConnectedStream() {
		#[1, 2, 3].each(handler)
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
		countdown.stream.onFinish [ println('countdown done. success:' + countdown.success) ]
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
		
		collector.stream.each [ println('got ' + it.key + ' has value ' + it.value)]
		collector.stream.onFinish [
			val it = collector.result
			println('found user ' + get('user'))
			println('found name ' + get('name'))
			println('found age ' + get('age'))
		]

		cage.apply('12')
		cname.apply('John')
		cuser.apply('Christian')
	}

	@Test
	def void testConnectables() {
		val stream = Integer.stream
		stream.split.each [ println('a: ' + it) ]
		stream.split.map [ 'got value ' + it ].each [ println('b: ' + it) ]
		stream.apply(2)
	}
	
	@Test
	def void testOperators() {
		// test connectables example
		val stream = Integer.stream
		stream >> [ println('a: ' + it) ]
		stream.split >> [ println('a: ' + it) ]
		stream.split * [ 'got value ' + it ] >> [ println('b: ' + it) ]
		stream << 2
	}
	
	@Test
	def void testOperators2() {
		val stream = Integer.stream
		stream 
			/ [ it > 2 ] 
			* ['got number ' + it] 
			>> [ println('got ' + it)] .. [ println('we are done') ] 
			?: [ println('caught ' + message) ]

		stream << 2 << 5 << 3 << none << error
	}
	
}
