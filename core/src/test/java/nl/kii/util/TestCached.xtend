package nl.kii.util

import org.eclipse.xtend.lib.annotations.Data
import org.junit.Test

import static org.junit.Assert.*

import static extension nl.kii.util.DateExtensions.*

class TestCached {

	val cache = new Cached<User>(1.min) [ fetchUser ]
	int fetches = 0

	@Test
	def void testCached() {
		cache.apply
		cache.apply
		cache.apply
		assertEquals(1, fetches)
	}
	
	def fetchUser() {
		fetches++
		new User('emre', 24)
	}
	
}

@Data
class User {
	String name
	int age
} 
