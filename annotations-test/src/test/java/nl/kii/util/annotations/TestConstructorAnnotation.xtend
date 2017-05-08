package nl.kii.util.annotations

import nl.kii.util.annotation.Constructor
import org.junit.Test

import static org.junit.Assert.*
import java.util.List

class TestConstructorAnnotation {

	@Test
	def void test() {
		assertEquals(3, new Adder(1, 2).sum)
		assertEquals('12', new GenericConcatinator(1, 2).concat)
		assertArrayEquals(#[1, 2, 3, 4], new GenericConcatinator2(#[1, 2], #[3, 4]).concat)
	}
	
}

@Constructor
class Adder {

	val int a
	val int b
	
	def sum() {
		a + b
	}

}

@Constructor
class GenericConcatinator<T> {

	val T a
	val T b
	
	def concat() {
		a.toString + b.toString
	}

}

@Constructor
class GenericConcatinator2<T> {

	val List<T> a
	val List<T> b
	
	def concat() {
		newLinkedList => [
			addAll(a)
			addAll(b)
		]
	}

}
