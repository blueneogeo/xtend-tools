package nl.kii.util

import org.junit.Test

import static extension nl.kii.rx.ObservableExtensions.*
import static extension nl.kii.rx.ObserveExtensions.*
import static extension nl.kii.rx.PromiseExtensions.*
import static extension nl.kii.rx.StreamExtensions.*
import static extension org.junit.Assert.*
import nl.kii.rx.Countdown
import nl.kii.rx.Collector

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
			finish
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

	@Test
	def void testConnectables() {
		val stream = Integer.stream
		// stream.split.each [ println('a: ' + it) ].connect
		stream.split.map [ 'got value ' + it ].each [ println('b: ' + it) ]
		stream.apply(2)
	}
	
	@Test
	def void testOptStream() {
		val stream = String.stream
		stream.options
			.onSome [ println('got ' + it) ]
			.onNone [ println('none') ]
			.onErr [ println('error') ]
		stream.apply('hey')
		stream.apply('hi')
		stream.apply('error')
	}
	
	@Test
	def void testObservable() {
		// create a counter that starts at 0
		val counter = 0.observe
		counter.apply.assertEquals(0)
		// observe any changes
		counter.each [ println('counter was changed! << will be called twice') ]
		// put in a new value
		counter.apply(5)
		// now check the new value
		counter.apply.assertEquals(5)
	}
	
	@Test
	def void testComputedObservable() {
		// create two values
		val v1 = 10.observe
		val v2 = 40.observe
		// create a computed value
		val v3 = [| v1.apply + v2.apply ].observe(v1, v2)
		// now if either changes, v3 should also update
		v1.apply(30)
		v3.apply.assertEquals(30 + 40)
		// listen to the changes of v3
		v3.each [ println('v3 changed to ' + it) ]
		v2.apply(90)
		v3.apply.assertEquals(30 + 90)
	}
	
}
