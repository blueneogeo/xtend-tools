package nl.kii.util

class NumericExtensions {
	
	def static thousand(int n) { n * 1000L }
	def static k(int n) { n.thousand }
	
	def static million(int n) { n * 1_000_000L }
	def static m(int n) { n.million }	
	
	def static billion(int n) { n * 1_000_000_000L }
	def static b(int n) { n.billion }
	
	def static times(int n, (int)=>void action) {
		(1..n).forEach(action)
	}
	
	/** 
	 * Wrapper for Long.parseLong(string) to be compatible with the Xtend null-safe call ({@code ?.})
	 */
	def static Long parseLong(String string) {
		 Long.parseLong(string)
	}

	/** 
	 * Wrapper for Integer.parseInt(string) to be compatible with the Xtend null-safe call ({@code ?.})
	 */
	def static Integer parseInt(String string) {
		Integer.parseInt(string)
	}
	
	/** 
	 * Wrapper for Double.parseDouble(string) to be compatible with the Xtend null-safe call ({@code ?.})
	 */
	def static Double parseDouble(String string) {
		Double.parseDouble(string)
	}

	/** 
	 * Wrapper for Float.parseFloat(string) to be compatible with the Xtend null-safe call ({@code ?.})
	 */
	def static Float parseFloat(String string) {
		Float.parseFloat(string)
	}

	/** 
	 * Wrapper for Boolean.parseBoolean(string) to be compatible with the Xtend null-safe call ({@code ?.})
	 */
	def static Boolean parseBoolean(String string) {
		Boolean.parseBoolean(string)
	}

}