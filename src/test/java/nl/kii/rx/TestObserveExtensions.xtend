package nl.kii.rx

import org.junit.Test

import static extension nl.kii.rx.ObserveExtensions.*
import static extension nl.kii.rx.StreamExtensions.*
import static extension org.junit.Assert.*

class TestObserveExtensions {
	
	@Test
	def void testObserved() {
		// create a counter that starts at 0
		val counter = 0.observe
		counter.apply.assertEquals(0)
		// observe any changes
		counter.each [ println('counter was changed! << will be called twice') ]
		// put in a new value
		counter << 5
		// now check the new value
		counter.get.assertEquals(5)
	}
	
	@Test
	def void testComputedObserved() {
		// create two values
		val v1 = 10.observe
		val v2 = 40.observe
		// create a computed value
		val v3 = [| v1.get + v2.get ].observe(v1, v2)
		// now if either changes, v3 should also update
		v1 << 30
		v3.get.assertEquals(30 + 40)
		// listen to the changes of v3
		v3.each [ println('v3 changed to ' + it) ]
		v2 << 90
		v3.get.assertEquals(30 + 90)
	}
	
}
