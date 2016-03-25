package nl.kii.util

import com.google.common.util.concurrent.AtomicDouble
import java.util.List
import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.atomic.AtomicInteger
import java.util.concurrent.atomic.AtomicLong
import java.util.concurrent.atomic.AtomicReference
import org.junit.Assert

import static extension org.junit.Assert.*

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

	def static <T> <=> (AtomicReference<T> value, T expected) {
		assertEquals(expected, value.get)
	}

	def static <T> <=> (AtomicInteger value, T expected) {
		assertEquals(expected, value.get)
	}

	def static <T> <=> (AtomicDouble value, T expected) {
		assertEquals(expected, value.get)
	}
	
	def static <T> <=> (AtomicBoolean value, T expected) {
		assertEquals(expected, value.get)
	}

	def static <T> <=> (AtomicLong value, T expected) {
		assertEquals(expected, value.get)
	}

}