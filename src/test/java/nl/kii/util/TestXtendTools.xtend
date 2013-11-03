package nl.kii.util

import java.io.Closeable
import java.io.IOException
import java.util.List
import org.junit.Test

import static nl.kii.util.CloseableExtensions.*

import static extension nl.kii.util.IterableExtensions.*
import static extension nl.kii.util.LogExtensions.*
import static extension nl.kii.util.OptExtensions.*
import static extension org.junit.Assert.*
import static extension org.slf4j.LoggerFactory.*

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
		ifSome(some('test')) ['hello'].assertSome('hello')
		ifSome(none) ['hello'].assertNone
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
			None.orThrow [ new Exception ]
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
	}
	
	@Test def void testFilters() {
		#{some(1), none, some(2), none, none}.filterEmpty.length.assertEquals(2)
		#{1, 2, 3, 1}.distinct.length.assertEquals(3)
	}
	
	@Test def void testConversions() {
		// toList
		#{1, 2, 3}.toList.length.assertEquals(3)
		// null.toList.length.assertEquals(0)
		// toSet
		#[1, 2, 3].toSet.length.assertEquals(3)
		// null.toSet.length.assertEquals(0)
		// toPairs
		#{'john'->23, 'mary'->45}.toPairs.get(1) => [
			key.assertEquals('mary')
			value.assertEquals(45)
		]
		// toMap
		#['john'->23, 'mary'->45].toMap.get('mary').assertEquals(45)
	}
	
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
		// index
		users
			.index [ age ]
			.get(45)
			.name.assertEquals('mary')
		// attemptToMap
		users
			.attemptMap [ 1 / (age - 45) ] // throws division by 0 at mary
			.filterEmpty // filter the empty result
			.length.assertEquals(2) // only two results left
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
		
	@Test def void testLogging() {
		val list = #[1, 2, 3]
		list.printEach
		list.printEach('got list:')
		list.info(logger)
	}
	
	@Test def void testMapTo() {
		val List<Object> list = newLinkedList
		list.add(4)
		list.add(9)
		val mappedList = list.mapTo(Integer)
		mappedList.get(0).assertEquals(new Integer(4))
		mappedList.get(1).assertEquals(new Integer(9))
	}
	
}

@Data class User {
	String name
	int age
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
