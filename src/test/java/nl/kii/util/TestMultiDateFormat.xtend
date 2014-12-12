package nl.kii.util

import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import org.junit.Test

import static org.junit.Assert.*

class TestMultiDateFormat {
	val someDateStrings = #[ 
		'Thu, 30 Oct 2014 15:35:13 +01:00',
		'Thu, 30 Oct 2014 15:35:13 +0100',
		'Thu, 30 Oct 2014 15:35:13 CET'
	]
	
	@Test
	def void textMultipleInputs() {
		someDateStrings.forEach [ 
			val date = toDate('EEE, d MMM yyyy HH:mm:ss z; EEE, d MMM yyyy HH:mm:ss X')
			println(date)
			assertEquals(new SimpleDateFormat('dd-MM-yyyy').format(date), '30-10-2014')
		]
	}

	
	@Test
	def void testSingleInput() {
		val date = 'Thu, 30 Oct 2014 15:35:13 +0100'.toDate('EEE, d MMM yyyy HH:mm:ss z')
		println(date)
		assertEquals(date.toString, 'Thu Oct 30 15:35:13 CET 2014')		
	}
	
	
	def Date toDate(String s, String dateFormat) {
		new MultiDateFormat(dateFormat, Locale.ENGLISH).parse(s)
	}
}