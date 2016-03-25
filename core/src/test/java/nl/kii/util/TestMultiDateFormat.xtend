package nl.kii.util

import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone
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
		val originalTimeZone = TimeZone.^default
		TimeZone.^default = TimeZone.getTimeZone( 'UTC' )
		
		val date = 'Thu, 30 Oct 2014 15:35:13 +0100'.toDate('EEE, d MMM yyyy HH:mm:ss z')
		assertEquals('Thu Oct 30 14:35:13 UTC 2014', date.toString)
		
		TimeZone.^default = originalTimeZone	
	}
	
	
	def Date toDate(String s, String dateFormat) {
		new MultiDateFormat(dateFormat, Locale.ENGLISH).parse(s)
	}
}