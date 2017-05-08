package nl.kii.util.annotation.processor

import nl.kii.util.annotation.ActiveAnnotationTools
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration

class ConstructorProcessor extends AbstractClassProcessor {

	override doTransform(MutableClassDeclaration cls, extension TransformationContext context) {
		val extension tools = new ActiveAnnotationTools(context)
		
		// find all fields that are final, not static and not already initialised
		val finalFields = cls.declaredFields.filter[ !static && final && initializer === null ]
		
		// create a constructor with these fields as parameters that sets these fields
		cls.addConstructorSafely [
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
