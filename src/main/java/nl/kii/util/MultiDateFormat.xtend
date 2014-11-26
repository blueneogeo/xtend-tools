package nl.kii.util

import java.util.List
import java.util.Locale
import java.text.SimpleDateFormat
import java.util.Date
import static extension nl.kii.util.IterableExtensions.*
import java.text.DateFormat
import java.text.ParseException

class MultiDateFormat {
	val List<DateFormat> dateFormats
	val Locale locale
	
	new (String dateFormat, Locale locale) {
		this.dateFormats = dateFormat.split('\\;\\s').map [ new SimpleDateFormat(it, Locale.ENGLISH) ]
		this.locale = locale
	}
	
	def parse(String string) {
		dateFormats
			.findFirst [ string.matches(it) ]
			.parse(string)
	}
	
	def format(Date date) {
		dateFormats
			.findFirst [ date.matches(it) ]
			.format(date)		
	}
	
	def matches(Object input, DateFormat format) {
		try {
			switch it : input {
				String: format.parse(it)
				Date: format.format(it)
			}
			true
		} catch(ParseException e) {
			false
		}
	}
	
}