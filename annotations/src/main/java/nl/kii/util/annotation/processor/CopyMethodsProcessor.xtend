package nl.kii.util.annotation.processor

import nl.kii.util.annotation.ActiveAnnotationTools
import nl.kii.util.annotation.CopyMethods
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.AnnotationReference
import org.eclipse.xtend.lib.macro.declaration.MethodDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.TypeReference

class CopyMethodsProcessor extends AbstractClassProcessor {

	/** The annotation to search for */
	def Class<?> getAnnotationType() { CopyMethods }

	override doTransform(MutableClassDeclaration cls, extension TransformationContext context) {
		val extension tools = new ActiveAnnotationTools(context)
		val annotations = cls.annotations.filter [ annotationTypeDeclaration.qualifiedName == annotationType.name ]
		for(annotation : annotations) {
			val ignoredMethods = annotation.getStringArrayValue('ignoredMethods')
			val includeSuperTypes = annotation.getBooleanValue('includeSuperTypes')
			val createExtensionMethods = annotation.getBooleanValue('createExtensionMethods')

			val sourceCls = annotation.getClassValue('value')
			val sourceMethods = if(includeSuperTypes) sourceCls.allResolvedMethods else sourceCls.declaredResolvedMethods

			val copyMethods = sourceMethods
				.map [ declaration ]
				.filter [ !returnType.inferred ]
				.filter [ static || createExtensionMethods ]
				.filter [ method | !ignoredMethods?.contains(method.signature) ]
			
			for(method : copyMethods) {
				doCopyMethod(cls, sourceCls, method, annotation, context)
			}
		}
	}
	
	/** 
	 * Perform the copy operation
	 * @param targetClass the class to copy to
	 * @param originalCls the class to copy from
	 * @param originalMethod the method to copy
	 * @param annotation the annotation with settings for copying
	 * @param context the transformation context
	 */
	def doCopyMethod(MutableClassDeclaration targetClass, TypeReference originalCls, MethodDeclaration originalMethod, AnnotationReference annotation, extension TransformationContext context) {
		val extension tools = new ActiveAnnotationTools(context)
		targetClass.addMethodCopy(originalCls, originalMethod, null, true, true) [ extension newMethod, allTypeParameters |
			if(originalMethod.static) {
				body = ['''
					«IF !newMethod.returnType.isVoid»return «ENDIF»
					«originalCls.name».«newMethod.simpleName»(
						«FOR parameter : originalMethod.parameters SEPARATOR ', '»
							«parameter.simpleName»
						«ENDFOR»
					);
				''']
			} else {
				body = ['''
					«IF !newMethod.returnType.isVoid»return «ENDIF»
					«newMethod.parameters.head.simpleName».«newMethod.simpleName»(
						«FOR parameter : originalMethod.parameters SEPARATOR ', '»
							«parameter.simpleName»
						«ENDFOR»
					);
				''']
			}
		]
	}

}
