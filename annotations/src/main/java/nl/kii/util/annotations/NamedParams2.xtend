package nl.kii.util.annotations

import java.lang.annotation.Target
import java.util.List
import org.eclipse.xtend.lib.macro.AbstractMethodProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.CodeGenerationContext
import org.eclipse.xtend.lib.macro.RegisterGlobalsContext
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MethodDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableMethodDeclaration
import org.eclipse.xtend.lib.macro.declaration.ParameterDeclaration
import org.eclipse.xtend.lib.macro.declaration.TypeDeclaration

@Active(NamedParamsProcessor2)
@Target(METHOD)
annotation NamedParams2 {
}

class NamedParamsProcessor2 extends AbstractMethodProcessor {

	override doRegisterGlobals(MethodDeclaration method, extension RegisterGlobalsContext context) {
		registerClass(method.parametersObjectName)
	}
	
	override doTransform(MutableMethodDeclaration method, extension TransformationContext context) {
		val clazz = method.declaringType
		clazz.addMethod(method.simpleName) [
			abstract = method.abstract
			^default = method.^default
			deprecated = method.deprecated
			docComment = method.docComment
			exceptions = method.exceptions
			final = method.final
			native = method.native
			primarySourceElement = method
			returnType = method.returnType
			static = method.static
			strictFloatingPoint = method.strictFloatingPoint
			synchronized = method.synchronized
			varArgs = method.varArgs
			visibility = method.visibility
		]
	}

	override doGenerateCode(List<? extends MethodDeclaration> methods, extension CodeGenerationContext context) {
		val clazz = methods.head.declaringType
		val filePath = clazz.compilationUnit.filePath
		
		// find the source and remove the end } from the class so we can add our own method
		val sourceFileName = clazz.qualifiedName.replace('.', '/') + '.java'
		val sourceFile = filePath.targetFolder.append(sourceFileName)
		val currentSource = sourceFile.contents
		val trimmedSource = currentSource.toString.trim
		if(!trimmedSource.endsWith('}')) throw new Exception('NamedParamsProcessor expected end of class { sign but could not find it. In ' + sourceFileName)
		val source = trimmedSource.substring(0, trimmedSource.length - 1) // remove the } at the end so we can add our own methods

		// create a new file from the source		
		val buffer = new StringBuffer(source)
		for (MethodDeclaration method: methods) {

			// create the parameters class source file for the method
			val parametersFileName = (method.packageName + '.' + method.parametersObjectName).replace('.', '/') + '.java'
			val parametersFile = filePath.targetFolder.append(parametersFileName)
			parametersFile.contents = method.getParametersClassSource(context)

			// add the method that uses the parameters class, as the alternative that calls the original
			buffer.append(method.getNewMethodSource(context))
		}

		// re-close the class and write the code to the source file
		buffer.append('''
			
			}
		''')
		sourceFile.contents = buffer.toString
	}
	
	def getNewMethodSource(MethodDeclaration method, CodeGenerationContext context) {
		'''
			
			«method.javaMethodDescriptionSource»(org.eclipse.xtext.xbase.lib.Procedures.Procedure1<«method.parametersObjectName»> parametersFn) {
				// code here!
			}
		'''
	}
	
	def getParametersClassSource(MethodDeclaration method, CodeGenerationContext context)  '''
		package «method.packageName»;
		
		«FOR importCmd : method.declaringType.getImports(context)»
			«importCmd»;
		«ENDFOR»
		
		/** 
		 * NamedParams Active Annotation generated parameters for the method «method.declaringType.simpleName».«method.simpleName»()
		 * <p>
		 * Method description: «method.docComment»
		 * <p>
		 «FOR param : method.parameters»
		 	* @Param «param.simpleName»
		 «ENDFOR»
		 */
		class «method.parametersObjectName»«IF !method.typeParameters.empty»<«FOR typeParam : method.typeParameters SEPARATOR ','»«typeParam.simpleName»«ENDFOR»>«ENDIF» {
			«FOR param : method.parameters»
				«param.type» «param.simpleName»;
			«ENDFOR»
		}
	'''
	
	def getJavaMethodDescriptionSource(MethodDeclaration method) {
		'''«method.javaMethodModifiersSource» «method.javaMethodTypeSource» «IF method.returnType != null»«method.returnType»«ELSE»void«ENDIF» «method.simpleName»'''
	}

	def getJavaMethodParametersSource(MethodDeclaration method) {
		method.parameters.map [ javaMethodParameterSource ].join(', ')
	}
	
	def getJavaMethodParameterSource(ParameterDeclaration parameter) {
		'''«parameter.type.simpleName» «parameter.simpleName»'''
	}
	
	def getJavaMethodTypeSource(MethodDeclaration method) {
		'''«IF !method.typeParameters.empty»<«FOR genericType : method.typeParameters SEPARATOR ', '»«genericType.simpleName»«ENDFOR»>«ENDIF»'''
	}

	def getJavaMethodModifiersSource(MethodDeclaration method) {
		val javaModifiers = method.modifiers
			.map [
				switch it {
					case PRIVATE: 'private'
					case PROTECTED: 'protected'
					case FINAL: 'final'
					case ABSTRACT: 'abstract'
					case PACKAGE: ''
					default: null
				}
			]
			.filterNull
			.toList
		val isPublic = !javaModifiers.contains('private') && !javaModifiers.contains('protected') && !javaModifiers.contains('')
		if(isPublic) javaModifiers.add('public')
		javaModifiers.join(' ')
	}

	def getImports(TypeDeclaration type, extension CodeGenerationContext context) {
		type.compilationUnit.filePath.contents.toString.split('\n').filter[trim.startsWith('import')]
	}

	def getClassName(MethodDeclaration method) {
		method.declaringType.simpleName
	}

	def getPackageName(MethodDeclaration method) {
		method.declaringType.compilationUnit.packageName
	// method.declaringType.qualifiedName.replace('.' + method.className, '')
	}

	def getParametersObjectName(MethodDeclaration method) {
		method.className + '_' + method.simpleName.toFirstUpper + 'Params'
	}
}
