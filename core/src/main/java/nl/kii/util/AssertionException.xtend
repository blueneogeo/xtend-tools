package nl.kii.util

/** 
 * Lets you place assertion points in your code, throw this to indicate a code assertion failed.
 * Unlike AssertionError, this should be caught.
 */
class AssertionException extends Exception {

	new(String message) {
		super(message)
	}

	new(String message, Throwable cause) {
		super(message, cause)
	}
	
}
