package nl.kii.util.annotation.processor

import java.util.List
import nl.kii.util.annotation.ActiveAnnotationTools
import nl.kii.util.annotation.Default
import nl.kii.util.annotation.DefaultFalse
import nl.kii.util.annotation.DefaultTrue
import nl.kii.util.annotation.DefaultValue
import nl.kii.util.annotation.Locked
import nl.kii.util.annotation.MethodParameterSetter
import nl.kii.util.annotation.MethodParameters
import nl.kii.util.annotation.Nullable
import org.eclipse.xtend.lib.macro.RegisterGlobalsContext
import org.eclipse.xtend.lib.macro.RegisterGlobalsParticipant
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.TransformationParticipant
import org.eclipse.xtend.lib.macro.declaration.ConstructorDeclaration
import org.eclipse.xtend.lib.macro.declaration.ExecutableDeclaration
import org.eclipse.xtend.lib.macro.declaration.MethodDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableConstructorDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableExecutableDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableMethodDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableNamedElement
import org.eclipse.xtend.lib.macro.declaration.NamedElement
import org.eclipse.xtend.lib.macro.declaration.ParameterDeclaration
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1

import static org.eclipse.xtend.lib.macro.declaration.Visibility.*

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

	def doTransform(MutableExecutableDeclaration member, extension TransformationContext context) {
		val extension tools = new ActiveAnnotationTools(context)
		
		// method generics are not allowed, since Xtend 2.9.X does not expose that information yet.
		if(!member.typeParameters.empty) member.addError('@NamedParam does not (yet) support generic type parameters for methods.')
		val allParameterTypes = member.parameters.map[type.actualTypeArguments].flatten
		if(!allParameterTypes.empty) member.addError('@NamedParam does not (yet) support generic type parameters in methods.')

		// create the params class
		val paramsClazz = findClass(member.compilationUnit.packageName + '.' + member.parametersObjectName) => [
			implementedInterfaces = #[MethodParameters.ref]
		]
		// as fields, use all unlocked parameters of the method
		val validationCode = new StringBuffer
		// as fields, use all unlocked parameters of the method
		for(parameter : member.parameters.filter [ !isLocked(context) ]) {
			// for each parameter in the method, create a field in the params class
			paramsClazz.addField(parameter.simpleName) [
				type = parameter.type
				visibility = PUBLIC
				// set the initializer based on default annotations
				switch type {
					case string: {
						val value = parameter.findAnnotation(Default.ref.type)?.getStringValue('value')
						if(value !== null) initializer = '''"«value»"'''
					}
					case int.ref, case Integer.ref: {
						val value = parameter.findAnnotation(DefaultValue.ref.type)?.getDoubleValue('value')
						initializer = '''new Double(«value»).intValue()'''
					}
					case long.ref, case Long.ref: {
						val value = parameter.findAnnotation(DefaultValue.ref.type)?.getDoubleValue('value')
						initializer = '''new Double(«value»).longValue()'''
					}
					case double.ref, case Double.ref: {
						val value = parameter.findAnnotation(DefaultValue.ref.type)?.getDoubleValue('value')
						initializer = '''«value»'''
					}
					case boolean.ref, case Boolean.ref: {
						if(parameter.findAnnotation(DefaultTrue.ref.type) !== null) {
							initializer = '''true'''
						} else if(parameter.findAnnotation(DefaultFalse.ref.type) !== null) {
							initializer = '''false'''
						}
					}
				}
				// add the field to the validation code
				if(!parameter.nullAllowed(context)) {
					validationCode.append('''
						if(«parameter.simpleName» == null) 
							throw new NullPointerException("«member.simpleName».«parameter.simpleName» may not be null. (annotate with @NULL if you want to allow null)");
					''')
				}
			]
		}
		paramsClazz.addMethod('validate') [
			body = '''«validationCode»'''
		]
		
		// create a new method that takes just the parameters object
		val clazz = member.declaringType
		val Procedure1<MutableExecutableDeclaration> addParametersMethod = [
			primarySourceElement = member
			copyAllMethodProperties(member, it)
			// add the locked parameters
			for(param : member.parameters.filter [isLocked(context)]) {
				addParameter(param.simpleName, param.type)
			}
			// add the parameters paramer
			val paramsType = paramsClazz.newTypeReference
			addParameter('parameters', paramsType)
			// create the body which creates the params object, calls the closure with the params and then calls the original method
			body = switch member {
				MutableMethodDeclaration: '''
					«IF member.returnType.simpleName != 'void'»return «ENDIF»
					«member.simpleName»(
						«FOR param : member.parameters SEPARATOR ', '»
							«IF !param.isLocked(context)»parameters.«ENDIF»«param.simpleName»
						«ENDFOR»
					);
				'''
				MutableConstructorDeclaration: '''
					this(
						«FOR param : member.parameters SEPARATOR ', '»
							«IF !param.isLocked(context)»parameters.«ENDIF»«param.simpleName»
						«ENDFOR»
					);
				'''				 
			}
		]

		// create the new method that calls the parameters object
		val Procedure1<MutableExecutableDeclaration> addParametersFunctionMethod = [
			primarySourceElement = member
			copyAllMethodProperties(member, it)
			// add the locked parameters
			for(param : member.parameters.filter [isLocked(context)]) {
				addParameter(param.simpleName, param.type)
			}
			// add the closure parameter
			val paramsType = paramsClazz.newTypeReference
			addParameter('parametersFn', MethodParameterSetter.ref(paramsType))
			// create the body which creates the params object, calls the closure with the params and then calls the original method
			body = switch member {
				MutableMethodDeclaration: '''
					«FOR param : member.parameters.filter [!nullAllowed(context) && isLocked(context)]»
						if(«param.simpleName» == null) throw new NullPointerException("«member.simpleName».«param.simpleName» may not be null. (annotate with @Nullable if you want to allow null)");
					«ENDFOR»
					«IF member.returnType.simpleName != 'void'»return «ENDIF»
					«member.simpleName»(
						«FOR param : member.parameters.filter[isLocked(context)]»
							«param.simpleName», 
						«ENDFOR»
						parametersFn.call(new «paramsType»())
					);
				'''
				MutableConstructorDeclaration: '''
					this(
						«FOR param : member.parameters.filter[isLocked(context)]»
							«param.simpleName», 
						«ENDFOR»
						parametersFn.call(new «paramsType»())
					);				'''				 
			}
		]
		
		switch member {
			MutableMethodDeclaration: {
				clazz.addMethod(member.simpleName) [ addParametersMethod.apply(it) ]
				clazz.addMethod(member.simpleName) [ addParametersFunctionMethod.apply(it) ]
			}
			MutableConstructorDeclaration: {
				clazz.addConstructor [ addParametersMethod.apply(it) ]
				clazz.addConstructor [ addParametersFunctionMethod.apply(it) ]
			}
		}
	}
	
	def static copyAllMethodProperties(MutableExecutableDeclaration member, MutableExecutableDeclaration it) {
		// copy all method properties
		deprecated = member.deprecated
		docComment = member.docComment
		exceptions = member.exceptions
		varArgs = member.varArgs
		visibility = member.visibility
		// these are only for methods, not for constructors
		if(member instanceof MutableMethodDeclaration) {
			if(it instanceof MutableMethodDeclaration) {
				abstract = member.abstract
				^default = member.^default
				final = member.final
				native = member.native
				returnType = member.returnType
				static = member.static
				strictFloatingPoint = member.strictFloatingPoint
				synchronized = member.synchronized
			}
		}
	}

	def static getParametersObjectName(ExecutableDeclaration method) {
		// method.declaringType.simpleName + '_' + method.simpleName.toFirstUpper + 'Params'
		method.declaringType.simpleName + '.' + method.simpleName.toFirstUpper + 'Params'
	}

	def static nullAllowed(ParameterDeclaration param, extension TransformationContext context) {
		param.type.primitive || param.findAnnotation(Nullable.newTypeReference.type) !== null
	}
	
	def static isLocked(ParameterDeclaration param, extension TransformationContext context) {
		param.findAnnotation(Locked.newTypeReference.type) !== null
	}
		
}
