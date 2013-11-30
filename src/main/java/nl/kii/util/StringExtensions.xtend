package nl.kii.util

import com.google.common.base.CaseFormat

class StringExtensions {
	
	def static changeCase(String name, CaseFormat from, CaseFormat to) {
		from.to(to, name)
	}
	
}
