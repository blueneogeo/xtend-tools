package nl.kii.util.annotation.processor

import nl.kii.util.annotation.CopyMethods
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration

class ConstructorProcessor extends AbstractClassProcessor {

	/** The annotation to search for */
	def Class<?> getAnnotationType() { CopyMethods }

	override doTransform(MutableClassDeclaration cls, extension TransformationContext context) {
		// val extension tools = new ActiveAnnotationTools(context)
		
		// find all fields that are final
		val finalFields = cls.declaredFields.filter[ final ]
		
		// create a constructor with these fields as parameters that sets these fields
		cls.addConstructor [
			for(field : finalFields) {
				addParameter(field.simpleName, field.type)
			}
			body = '''
				«FOR field : finalFields»
					this.«field.simpleName» = «field.simpleName»; 
				«ENDFOR»
			'''
		]
		
	}

}
