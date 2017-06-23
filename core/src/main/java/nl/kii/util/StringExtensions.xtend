package nl.kii.util

import com.google.common.base.CaseFormat

class StringExtensions {
	
	def static changeCase(String name, CaseFormat from, CaseFormat to) {
		from.to(to, name)
	}
	
	def static limit(String string, int maxLength) {
		if(string === null || string.length <= maxLength) return string
		string.substring(0, maxLength)
	}

	/** 
	 * Prints a string that replaces all {} in the string with the passed objects.
	 * You can also pass the parameter number in the string like this: {n}, where
	 * n starts from 1.
	 */
	def static println(String string, Object... objects) {
		println(string.fill(objects))
	}

	/** 
	 * Returns a string that replaces all {} in the string with the passed objects.
	 * You can also pass the parameter number in the string like this: {n}, where
	 * n starts from 1.
	 */
	def static fill(String string, Object... objects) {
		var result = string
		var i = 0
		for(o : objects) {
			i++
			if(result.contains('{' + i + '}')) {
				result = result.replace('{' + i + '}', o.toString)
			} else {
				result = result.replaceFirst('\\{\\}', o.toString)
			}
		}
		result
	}
	
}
