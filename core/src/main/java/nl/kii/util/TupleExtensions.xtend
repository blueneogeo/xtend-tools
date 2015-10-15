package nl.kii.util

import org.eclipse.xtend.lib.annotations.Data
import java.util.List

class TupleExtensions {
	
	def static <A> tuple(A first) {
		new Tuple1(first)
	}

	def static <A, B> tuple(A first, B second) {
		new Tuple2(first, second)
	}

	def static <A, B, C> tuple(A first, B second, C third) {
		new Tuple3(first, second, third)
	}

	def static <A, B, C, D> tuple(A first, B second, C third, D fourth) {
		new Tuple4(first, second, third, fourth)
	}

}

interface Tuple {
	def List<Object> getEntries()
}

@Data class Tuple1<A> implements Tuple {
	A first
	
	def $0() { first }
	
	override getEntries() {
		#[ $0 ]
	}
	
	override toString() '''«entries»'''
}

@Data class Tuple2<A, B> implements Tuple {
	A first
	B second
	
	def $0() { first }
	def $1() { second }

	override getEntries() {
		#[ $0, $1 ]
	}

	override toString() '''«entries»'''
}

@Data class Tuple3<A, B, C> implements Tuple {
	A first
	B second
	C third
	
	def $0() { first }
	def $1() { second }
	def $2() { third }

	override getEntries() {
		#[ $0, $1, $2 ]
	}

	override toString() '''«entries»'''
}

@Data class Tuple4<A, B, C, D> implements Tuple {
	A first
	B second
	C third
	D fourth
	
	def $0() { first }
	def $1() { second }
	def $2() { third }
	def $3() { fourth }

	override getEntries() {
		#[ $0, $1, $2, $3 ]
	}

	override toString() '''«entries»'''
}
