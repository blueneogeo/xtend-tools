package nl.kii.util.annotations

import java.lang.annotation.Target
import java.util.List
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.RegisterGlobalsContext
import org.eclipse.xtend.lib.macro.RegisterGlobalsParticipant
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.TransformationParticipant
import org.eclipse.xtend.lib.macro.declaration.ConstructorDeclaration
import org.eclipse.xtend.lib.macro.declaration.ExecutableDeclaration
import org.eclipse.xtend.lib.macro.declaration.MethodDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableConstructorDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableMethodDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableNamedElement
import org.eclipse.xtend.lib.macro.declaration.NamedElement
import org.eclipse.xtend.lib.macro.declaration.ParameterDeclaration
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1

import static org.eclipse.xtend.lib.macro.declaration.Visibility.*

@Active(NamedParamsProcessor)
@Target(METHOD, CONSTRUCTOR)
annotation NamedParams {
}

@Target(PARAMETER)
annotation Lock {
}

@Target(PARAMETER)
annotation Null {
}

@Target(PARAMETER)
annotation S {
	String value
}

@Target(PARAMETER)
annotation I {
	int value
}

@Target(PARAMETER)
annotation L {
	long value
}

@Target(PARAMETER)
annotation D {
	double value
}

@Target(PARAMETER)
annotation B {
	boolean value
}

abstract class MethodParameterSetter<T extends MethodParameters> implements Procedure1<T> {
	
	def T call(T parameters) {
		apply(parameters)
		parameters.validate
		parameters
	}

}

// class NamedParamsProcessor extends AbstractMethodProcessor {

class NamedParamsProcessor implements RegisterGlobalsParticipant<NamedElement>, TransformationParticipant<MutableNamedElement> {

	override doRegisterGlobals(List<? extends NamedElement> elements, RegisterGlobalsContext context) {
		for (NamedElement element: elements) {
			switch element {
				MethodDeclaration: doRegisterGlobals(element, context)
				ConstructorDeclaration: doRegisterGlobals(element, context)
			}
		}
	}
	
	override doTransform(List<? extends MutableNamedElement> elements, extension TransformationContext context) {
		for (MutableNamedElement element: elements) {
			switch element {
				MutableMethodDeclaration: doTransform(element, context)
				MutableConstructorDeclaration: doTransform(element, context)
			}
		}
	}
	
	def doRegisterGlobals(ExecutableDeclaration method, extension RegisterGlobalsContext context) {
		// register our new parameters object class for the method
		registerClass(method.compilationUnit.packageName + '.' + method.parametersObjectName)
	}

	def doTransform(MutableConstructorDeclaration method, extension TransformationContext context) {
	}

	def doTransform(MutableMethodDeclaration method, extension TransformationContext context) {
		// generics are not allowed, since Xtend 2.9.X does not expose that information yet.
		if(!method.typeParameters.empty) method.addError('@NamedParam does not (yet) support generic type parameters for methods.')
		val allParameterTypes = method.parameters.map[type.actualTypeArguments].flatten
		if(!allParameterTypes.empty) method.addError('@NamedParam does not (yet) support generic type parameters in methods.')
		
		// create the params class
		val paramsClazz = findClass(method.compilationUnit.packageName + '.' + method.parametersObjectName) => [
			implementedInterfaces = #[MethodParameters.newTypeReference]
		]
		// as fields, use all unlocked parameters of the method
		val validationCode = new StringBuffer
		// as fields, use all unlocked parameters of the method
		for(parameter : method.parameters.filter [ !isLocked(context) ]) {
			// for each parameter in the method, create a field in the params class
			paramsClazz.addField(parameter.simpleName) [
				type = parameter.type
				visibility = PUBLIC
				// find a default value annotation of the correct type on the parameter
				val annotation = switch type {
					case String.newTypeReference: S
					case int.newTypeReference, case Integer.newTypeReference: I
					case long.newTypeReference, case Long.newTypeReference: L
					case double.newTypeReference, case Double.newTypeReference: D
					case boolean.newTypeReference, case Boolean.newTypeReference: B
					default: null
				}
				// if there is a default value annotation, write the default value into the params class field
				if(annotation != null) {
					docComment = annotation.typeName
					val annotationType = annotation.newTypeReference
					switch annotationType {
						// strings need to be enclosed with " "
						case S.newTypeReference: {
							val value = parameter.findAnnotation(annotationType.type)?.getStringValue('value')
							if(value != null) initializer = '''"«value»"'''
						}
						default: {
							val value = parameter.findAnnotation(annotationType.type)?.getValue('value')
							if(value != null) initializer = '''«value»'''
						}
					}
				}
				// add the field to the validation code
				if(!parameter.nullAllowed(context)) {
					validationCode.append('''
						if(«parameter.simpleName» == null) 
							throw new NullPointerException("«method.simpleName».«parameter.simpleName» may not be null. (annotate with @NULL if you want to allow null)");
					''')
				}
			]
		}
		paramsClazz.addMethod('validate') [
			body = '''«validationCode»'''
		]
		
		// create a new method that takes just the parameters object
		val clazz = method.declaringType
		clazz.addMethod(method.simpleName) [
			// copy all method properties
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
			// add the locked parameters
			for(param : method.parameters.filter [isLocked(context)]) {
				addParameter(param.simpleName, param.type)
			}
			// add the closure parameter
			val paramsType = paramsClazz.newTypeReference
			addParameter('parameters', paramsType)
			// check which parameters may not be null, which means they have no NULL annotation
			// create the body which creates the params object, calls the closure with the params and then calls the original method
			body = '''
				«IF returnType.simpleName != 'void'»return «ENDIF»
				«method.simpleName»(
					«FOR param : method.parameters SEPARATOR ', '»
						«IF !param.isLocked(context)»parameters.«ENDIF»«param.simpleName»
					«ENDFOR»
				);
			'''
		]

		// create the new method that calls the parameters object
		clazz.addMethod(method.simpleName) [
			// copy all method properties
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
			// add the locked parameters
			for(param : method.parameters.filter [isLocked(context)]) {
				addParameter(param.simpleName, param.type)
			}
			// add the closure parameter
			val paramsType = paramsClazz.newTypeReference
			addParameter('parametersFn', MethodParameterSetter.newTypeReference(paramsType))
			// check which parameters may not be null, which means they have no NULL annotation
			// create the body which creates the params object, calls the closure with the params and then calls the original method
			body = '''
				«FOR param : method.parameters.filter [!nullAllowed(context) && isLocked(context)]»
					if(«param.simpleName» == null) throw new NullPointerException("«method.simpleName».«param.simpleName» may not be null. (annotate with @NULL if you want to allow null)");
				«ENDFOR»
				«IF returnType.simpleName != 'void'»return «ENDIF»
				«method.simpleName»(
					«FOR param : method.parameters.filter[isLocked(context)] SEPARATOR ','»
						«param.simpleName»
					«ENDFOR»
					, parametersFn.call(new «paramsType»())
				);
			'''
		]
		
	}

	def getParametersObjectName(ExecutableDeclaration method) {
		// method.declaringType.simpleName + '_' + method.simpleName.toFirstUpper + 'Params'
		method.declaringType.simpleName + '.' + method.simpleName.toFirstUpper + 'Params'
	}

	def nullAllowed(ParameterDeclaration param, extension TransformationContext context) {
		param.type.primitive || param.findAnnotation(Null.newTypeReference.type) != null
	}
	
	def isLocked(ParameterDeclaration param, extension TransformationContext context) {
		param.findAnnotation(Lock.newTypeReference.type) != null
	}
		
}
