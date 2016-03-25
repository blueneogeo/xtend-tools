package nl.kii.util

import static extension org.junit.Assert.*
import org.junit.Assert
import java.util.List

class JUnitExtensions {
	
	def static <T> <=> (T value, T expected) {
		assertEquals(expected, value)
	}

	def static <T> <=> (List<T> value, List<T> expected) {
		assertArrayEquals(expected, value)
	}

	def static <T> void assertNone(Opt<T> option) {
		option.hasSome.assertFalse
	}
	
	def static <T> void assertSome(Opt<T> option) {
		option.hasSome.assertTrue
	}

	def static <T> void assertSome(Opt<T> option, T value) {
		option.assertSome
		value.assertEquals(option.value)
	}

	def static fail(String message) {
		Assert.fail(message)
	}
	
}