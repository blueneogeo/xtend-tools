package nl.kii.util

import static extension org.junit.Assert.*
import static extension nl.kii.util.ThrowableExtensions.*
import org.junit.Test


class TestThrowableExtensions {
	
	@Test
	def void testCleanStacktrace() {
		try {
			throw new Exception			
		} catch(Throwable t) {
			try {
				throw new Exception(t)
			} catch(Exception e) {
				// clean all the junit and reflect stuff from the exception stacktrace
				val s = e.clean('.+junit.+', '.+reflect.+')
				// now just the thrown location is left in the trace
				assertEquals(1, s.stackTrace.length)
				assertEquals(1, s.cause.stackTrace.length)
				println(s.stackTrace.get(0).toString)
				println(s.cause.stackTrace.get(0).toString)
			}
		}
	}
	
}
