package nl.kii.util.annotation

import java.lang.annotation.Target
import nl.kii.util.annotation.processor.ConstructorProcessor
import org.eclipse.xtend.lib.macro.Active

/** 
 * Create a constructor based on all the final fields in the class.
 * <p>
 * For example, these are the same:
 * <p>
 * <pre>
 * class Foo {
 *    val int a
 *    val int b
 * 
 *    new(int a, int b) {
 *       this.a = a
 *       this.b = b
 *    }
 * }
 * </pre>
 * <p>
 * <pre>
 * \@Constructor
 * class Foo {
 *    val int a
 *    val int b
 * }
 * </pre>
 * 
 */
@Target(TYPE)
@Active(ConstructorProcessor)
annotation Constructor {
	
}
