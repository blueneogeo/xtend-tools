package nl.kii.util

import org.junit.Test

import static org.junit.Assert.*

import static extension nl.kii.util.IterableExtensions.*

class TestIterableExtensions {

	@Test
	def void testFilterAll() {
		val users = #[
			new User('Henk', 55),
			new User('Koos', 60),
			new User('Christian', 45),
			new User('Eli', 39)
		]
		
		val investors = users.filterAll(#['Henk', 'Koos']) [ name ]
		assertArrayEquals(#['Henk', 'Koos'], investors.map[name])
		val notInvestors = users.filterNone(#['Henk', 'Koos']) [ name ]
		assertArrayEquals(#['Christian', 'Eli'], notInvestors.map[name])
	}
	
}
