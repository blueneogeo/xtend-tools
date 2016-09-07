package nl.kii.util.annotations

import java.util.List
import nl.kii.util.annotation.CopyMethods
import org.junit.Test

import static org.junit.Assert.*

class TestCopyMethodsAnnotation {

	@Test
	def void test() {
		assertEquals(Source.add(1, 2), Destination.add(1, 2))
		assertEquals(Source.add(1, 2, 3), Destination.add(1, 2, 3))
		assertEquals(Source.add(1, 2, 3), Destination.add(1, 2, 3))
		Source.print(10, #[11])
		Destination.print(10, #[11])
	}
	
}

class Source {
	
	def static int add(int a, int b) {
		a + b
	}
	
	def static int add(int a, int b, int c) {
		a + b + c
	}
	
	def static <T> T print(T value, List<T> justForTestingGenerics) {
		println(value)
		value
	}

	def int add2(int a, int b) {
		a + b
	}
	
	def int add2(int a, int b, int c) {
		a + b + c
	}
	
	def <T> T print2(T value, List<T> justForTestingGenerics) {
		println(value)
		value
	}

}

@CopyMethods(value=Source, createExtensionMethods=true)
class Destination {
	
}
