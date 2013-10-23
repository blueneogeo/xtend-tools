package nl.kii.util

import org.eclipse.xtext.xbase.lib.Functions.Function1
import org.eclipse.xtext.xbase.lib.Functions.Function0
import org.eclipse.xtext.xbase.lib.Functions.Function2

class FunctionExtensions {
	
	/** Negate the result of a function */
	def static Function0<Boolean> operator_not(Function0<Boolean> fn) {
		[| !fn.apply ]
	}
	
	/** Negate the result of a function */
	def static <P1> Function1<? super P1, Boolean> operator_not(Function1<? super P1, Boolean> fn) {
		[ !fn.apply(it) ]
	}

	/** Negate the result of a function */
	def static <P1, P2> Function2<? super P1, ? super P2, Boolean> operator_not(Function2<? super P1, ? super P2, Boolean> fn) {
		[ a, b | !fn.apply(a, b) ]
	}

}
