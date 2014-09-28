package nl.kii.util

import org.eclipse.xtend.lib.annotations.Accessors

import static java.util.regex.Pattern.*

import static extension nl.kii.util.IterableExtensions.*

/**
 * This URL implementation is more flexible than the standard Java URL, it allows for incomplete URLs
 * to be parsed and constructed. This is useful for matching these partial urls especially, or for
 * creating relative urls.
 */
@Accessors
class URL {
	
	val static pattern = compile("^(?=[^&])(?:(?<scheme>[^:/?#]+):)?(?://(?<authority>[^/?#]*))?(?<path>[^?#]*)(?:\\?(?<query>[^#]*))?(?:#(?<fragment>.*))?")
	val static validate = compile('^(https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]')
	
	String protocol
	String domain
	String path
	String query
	String hash
	
	new(String url) {
		val matcher = pattern.matcher(url)
		if(matcher.matches) {
			protocol = matcher.group('scheme')
			domain = matcher.group('authority')
			path = matcher.group('path')
			query = matcher.group('query')
			hash = matcher.group('fragment')
		}
	}

	def getParameters() {
		query
			?.split('&')
			?.map [ split('=') ]
			?.map [ get(0) -> get(1) ]
			.toMap
	}
	
	def static isValid(String url) {
		validate.matcher(url).matches
	}

	def static isValid(URL url) {
		validate.matcher(url.toString).matches
	}

	override toString()
	'''«IF protocol!=null»«protocol»://«ENDIF»«IF domain!=null»«domain»«ENDIF»«IF path!=null»«path»«ENDIF»«IF query!=null»?«query»«ENDIF»«IF hash!=null»#«hash»«ENDIF»'''
		
}