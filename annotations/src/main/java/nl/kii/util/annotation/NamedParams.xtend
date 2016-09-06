package nl.kii.util.annotation

import java.lang.annotation.Target
import nl.kii.util.annotation.processor.NamedParamsProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1

@Active(NamedParamsProcessor)
@Target(METHOD, CONSTRUCTOR)
annotation NamedParams {
}

/**
 * Pin a named parameter in the method. This means a parameter will not become settable with the closure, 
 * and instead will stay part of the method signature.
 */
@Target(PARAMETER)
annotation Locked {
}

/**
 * Indicate that this parameter may be null. If you leave a parameter empty when it may not be null,
 * calling the method will throw a nullpointer exception from the start.
 */
@Target(PARAMETER)
annotation Nullable {
}

/**
 * Set the default string value of a named parameter. 
 * For number values, use DefaultValue instead. 
 */
@Target(PARAMETER)
annotation Default {
	String value
}

/** Set the default number value of a named parameter. */
@Target(PARAMETER)
annotation DefaultValue {
	double value
}

/** Set the default value of a named parameter to true */
@Target(PARAMETER)
annotation DefaultTrue {
}

/** Set the default value of a named parameter to false */
@Target(PARAMETER)
annotation DefaultFalse {
}

/**
 * This interface gets used and implemented by the NamedParams active annotation, so set up parameters
 * and implement the validation of the passed parameters.
 */
interface MethodParameters {
	
	def void validate() throws NullPointerException
	
}

abstract class MethodParameterSetter<T extends MethodParameters> implements Procedure1<T> {
	
	def T call(T parameters) {
		apply(parameters)
		parameters.validate
		parameters
	}

}
