package nl.kii.util.annotation

import java.lang.annotation.Repeatable
import java.lang.annotation.Target
import nl.kii.util.annotation.processor.CopyMethodsProcessor
import org.eclipse.xtend.lib.macro.Active

/** 
 * Create a wrapper extension class that converts methods with async handlers and handlers to promises.
 */
@Target(TYPE)
@Repeatable(CopyStaticMethodsValues)
@Active(CopyMethodsProcessor)
annotation CopyMethods {
	
	/** The class to copy methods from */
	Class<?> value
	
	/** Do we also pick up methods from supertypes? */
	boolean includeSuperTypes = false

	/** Do we create extension methods for instance methods? */
	boolean createExtensionMethods = true
	
	/** 
	 * Method signatures to ignore.
	 * Use the format "[methodname]([fulltypename],...)" (from MethodSignature.toString())
	 * For example: "equals(java.lang.Object)"
	 */
	 String[] ignoredMethods = #[]
}

@Target(TYPE)
annotation CopyStaticMethodsValues {
	
	CopyMethods[] value
	
}
