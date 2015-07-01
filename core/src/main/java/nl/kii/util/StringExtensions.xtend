package nl.kii.util

import com.google.common.base.CaseFormat

class StringExtensions {
	
	def static changeCase(String name, CaseFormat from, CaseFormat to) {
		from.to(to, name)
	}
	
	def static limit(String string, int maxLength) {
		if(string == null || string.length <= maxLength) return string
		string.substring(0, maxLength)
	}
	
}
