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

	// there create Adder(int a, int b)
	val int a
	val int b
	
//	val int c = 2 // not added to the constructor, has a value
//	val static int x = 1 // not added to the constructor, is static
	
	def sum() {
		a + b
	}

}

@Constructor
class OverriddenConstructor {

	val int a
	val int b
	
	// the annotation does not break upon you overriding the constructor it wanted to create
	new(int a, int b) {
		this.a = a
		this.b = b
	}
	
	def sum() {
		a + b
	}

}


@Constructor
class GenericConcatinator<T> {

	val T a // generic types work
	val T b
	
	def concat() {
		a.toString + b.toString
	}

}

@Constructor
class GenericConcatinator2<T> {

	val List<T> a // generic type parameters types work
	val List<T> b
	
	def concat() {
		newLinkedList => [
			addAll(a)
			addAll(b)
		]
	}

}
