package nl.kii.util.test

import java.io.Closeable
import java.io.IOException
import java.util.Date
import nl.kii.util.Log
import nl.kii.util.None
import nl.kii.util.Opt
import nl.kii.util.annotation.NamedParams
import org.eclipse.xtend.lib.annotations.Data
import org.junit.Test

import static nl.kii.util.CloseableExtensions.*

import static extension nl.kii.util.IterableExtensions.*
import static extension nl.kii.util.JUnitExtensions.*
import static extension nl.kii.util.LogExtensions.*
import static extension nl.kii.util.OptExtensions.*
import static extension nl.kii.util.SetOperationExtensions.*
import static extension org.junit.Assert.*
import static extension org.slf4j.LoggerFactory.*
import nl.kii.util.annotation.Default

interface Greeter {
    def void sayGreeting(String name)
}

class TestXtendTools {
	
	extension Log logger = class.logger.wrapper
	
	def loadUser(long userId, (String)=>void onLoad) {
		Thread.sleep(3000)
		onLoad.apply('''user-«userId»'''.toString)
	}
	
	@Test def void testAttempt() {
		attempt [ none ].assertNone
		attempt [ throw new Exception ].assertNone
		attempt [ 'hello'].assertSome('hello')
	}
	
	@Test def void testIfValue() {
		// if that returns an optional value
		ifTrue(true) ['hello'].assertSome('hello')
		ifTrue(false) ['hello'].assertNone
	}
	
	@Test def void testOr() {
		// direct ors
		some('hi')
			.or('hello')
			.assertEquals('hi')
		none
			.or('hello')
			.assertEquals('hello')
		// ors with a function for getting the result
		some('hi')
			.or [ 'a' + 'b']
			.assertEquals('hi')
		none
			.or [ 'a' + 'b']
			.assertEquals('ab')
		// ors that throw an exception via a function
		try {
			some('hi').orThrow [ new Exception ]
		} catch(Exception c) {
			some('hello')
		}.assertSome('hi')
		// same for none
		try {
			(new None).orThrow [ new Exception ]
		} catch(Exception c) {
			some('hello')
		}.assertSome('hello')
	}	

	@Test def void testIn() {
		2.in(#[1, 2, 3]).assertTrue
		2.in(1, 2, 3).assertTrue
		6.in(#[1, 2, 3]).assertFalse
		6.in(1, 2, 3).assertFalse
		null.in(1, 2, 3).assertFalse
		false.in(false).assertTrue
		val u1 = new User('a', 12)
		val u2 = new User('a', 12)
		val u3 = new User('b', 13)
		u2.in(#[u1, u3] as Iterable<User>).assertTrue
	}
	
//	@Test def void testFilters() {
//		#{some(1), none, some(2), none, none}.filterEmpty.length.assertEquals(2)
//		#{1, 2, 3, 1}.distinct.length.assertEquals(3)
//	}
	
//	@Test def void testConversions() {
//		// toList
//		#{1, 2, 3}.toList.length.assertEquals(3)
//		// null.toList.length.assertEquals(0)
//		// toSet
//		#[1, 2, 3].toSet.length.assertEquals(3)
//		// null.toSet.length.assertEquals(0)
//		// toPairs
//		#{'john'->23, 'mary'->45}.toPairs.get(1) => [
//			key.assertEquals('mary')
//			value.assertEquals(45)
//		]
//		// toMap
//		#['john'->23, 'mary'->45].toMap.get('mary').assertEquals(45)
//	}
	
	@Test def void iteratorFunctions() {
		val users = #[new User('john', 23), new User('mary', 45), new User('jim', 23)]
		 
		// groupBy
		users
			.groupBy [ age ]
			.get(23)
			.length
			.assertEquals(2) // two people of age 23
		// countBy
		users
			.countBy [ age ]
			.get(users.findFirst[ age == 23 ])
			.assertEquals(2) // shortcut of above, same result
		// count
		#[1, 3, 3, 3, 3, 4]
			.count
			.get(3)
			.assertEquals(4)
		
		// distinct
		#[ 1,2,3,3,3,4 ]
			.distinct
			.assertEquals(#[ 1,2,3,4 ])

		// distinctBy
		users
			.distinctBy [ age ]
			.length
			.assertEquals(2)

		// index
		users
			.index [ age ]
			.get(45)
			.name.assertEquals('mary')
		// attemptToMap
//		users
//			.attemptMap [ 1 / (age - 45) ] // throws division by 0 at mary
//			.filterEmpty // filter the empty result
//			.length.assertEquals(2) // only two results left
	}
	
	@Test
	def void testSetOperations() {
		val testingSet = #[ #[ 1, 2, 3 ], #[ 2, 3, 4 ] ]
		
		assertEquals(
			#[ 1, 2, 3, 4 ], 
			testingSet.union
		)

		assertEquals(
			#[ 2, 3 ], 
			testingSet.intersection
		)

		assertEquals(
			#[ 1 ], 
			testingSet.subtraction
		)

		assertEquals(
			#[ 1, 4 ], 
			testingSet.difference
		)
	}	
	
	@Test def void testUsing() {
		val closeable = new Readable
		// it should give back the result of the function
		closeable.open
		attemptUsing(closeable) [ hello ].assertSome('hello, I am open!')
		closeable.isClosed.assertTrue
		// if there is an error, it should still close the closeable
		closeable.open
		attemptUsing(closeable) [
			closeable.isClosed.assertFalse
			throw new Exception
		]
		closeable.isClosed.assertTrue
	}
	
	@Test def void testSum() {
		#[1, 3, 2, 5, 7].sum.assertEquals(18, 0)
	}

	@Test def void testAvg() {
		#[1, 2, 3, 4].average.assertEquals(2.5, 0)
	}
	
	@Test def void testMedian() {
		#[1D, 2D, 3D, 4D].median.assertEquals(2.5, 0)
		#[1D, 2D, 3D].median.assertEquals(2D, 0)
		#[1D, 2D, 3D, 3.5D, 4D, 4D, 300D].median.assertEquals(3.5, 0)
		#[3D, 21D, 1D].median.assertEquals(3D, 0)
	}
	
	@Test def void testLastN() {
		#[1, 2, 3, 4, 5].last(3).list.assertEquals(#[3, 4, 5])
		#[1, 2, 3, 4].last(6).list.assertEquals(#[1, 2, 3, 4])
		#[1, 2, 3].last(0).list.assertEquals(#[ ])
		#[ ].last(1).list.assertEquals(#[ ])
	}
			
	@Test def void testLogging() {
		error('hello error!', new Exception('ooo!'))
	}
	
	@Test
	def void testFlatten() {
		// test simple value opt unwrapping
		val x = 5.option.option
		x.flatten.hasSome.assertTrue
		// errors should be propagated when flattening
		val Opt<Opt<String>> e = err(new Exception('test')).option
		// println(e)
		e.flatten.hasError.assertTrue
	}

	@NamedParams
	def String addSomeThings(String username, @Default('Hey') String message, int age, Date birthday) '''
		hello «username», «message». You are «age» years old and your birthday is at «birthday».
	'''

	@Test
	def void testNamedParams() {
		val message = addSomeThings [
			username = 'Johnny'
			age = 30
			birthday = new Date
		]
		println(message)
	}
	
}

@Data class User {
	
	new(String name, int age) {
		this.name = name
		this.age = age
	}
	
	public String name
	public int age
}

class Readable implements Closeable {
	
	public var boolean isClosed = true
	
	def open() {
		isClosed = false
	}
	
	def hello() {
		if(isClosed) throw new Exception('cannot hello when closed')
		'hello, I am open!'
	}
	
	override close() throws IOException {
		isClosed = true
	}
	
}
