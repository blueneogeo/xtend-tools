package nl.kii.util

import static extension nl.kii.util.IterableExtensions.*

class SetOperationExtensions {
	
	/** Union – A ∪ B */
	def static <T> unionBy(Iterable<? extends Iterable<T>> sets, (T, T)=>boolean match) {
		sets.reduce [ total, incoming | 
			val filtered = incoming.filter [ entry | !total.exists [ match.apply(entry, it) ] ].list
			total.concat(filtered)
		]
	}
	
	/** Intersection – A ∩ B */
	def static <T> intersectionBy(Iterable<? extends Iterable<T>> sets, (T, T)=>boolean match) {
		sets.reduce [ total, incoming | 
			total.filter [ entry | incoming.exists [ match.apply(entry, it) ] ].list
		]
	}

	/** Difference – A \ B */
	def static <T> subtractionBy(Iterable<? extends Iterable<T>> sets, (T, T)=>boolean match) {
		sets.reduce [ total, incoming | 
			total.filter [ entry | !incoming.exists [ match.apply(entry, it) ] ].list
		]
	}

	/** Symmetric difference – A △ B */
	def static <T> differenceBy(Iterable<? extends Iterable<T>> sets, (T, T)=>boolean match) {
		#[ sets.unionBy(match), sets.intersectionBy(match) ].subtractionBy(match)
	}
	
	// EQUALS SHORTCUTS /////////////////////////////////////////////////////////////////////////////////
	
	/** Union – A ∪ B – unionBy shortcut that applies a.equals(b) */
	def static <T> union(Iterable<? extends Iterable<T>> sets) {
		sets.unionBy [ a, b | a == b ]
	}
	
	/** Intersection – A ∩ B – intersectionBy shortcut that applies a.equals(b) */
	def static <T> intersection(Iterable<? extends Iterable<T>> sets) {
		sets.intersectionBy [ a, b | a == b ]
	}

	/** Difference – A \ B – subtractionBy shortcut that applies a.equals(b) */
	def static <T> subtraction(Iterable<? extends Iterable<T>> sets) {
		sets.subtractionBy [ a, b | a == b ]
	}

	/** Symmetric difference – A △ B – differenceBy shortcut that applies a.equals(b) */
	def static <T> difference(Iterable<? extends Iterable<T>> sets) {
		sets.differenceBy [ a, b | a == b ]
	}

}