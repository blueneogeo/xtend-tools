package nl.kii.util

import org.eclipse.xtext.xbase.lib.Functions.Function0

abstract class Opt<T> implements Iterable<T> {
	def T value() throws NoneException
	def boolean hasSome()
	def boolean hasNone()
	def boolean hasError()
}

class None<T> extends Opt<T> {
	override value() { throw new NoneException }
	override hasSome() { false }
	override hasNone() { true }
	override hasError() { false }
	override iterator() { newLinkedList.iterator }
	override equals(Object obj) { obj instanceof None<?> }
	override hashCode() { 0 }
	override toString() '''None'''
}

class Err<T> extends Opt<T> implements Function0<Throwable> {
	val Throwable exception

	new() {	exception = new Exception }
	new(Throwable exception) { this.exception = exception }
	
	def getException() { exception }
	def getMessage() { exception.message }
	def getStackTrace() { exception.stackTrace }
	override apply() { exception }
	override value() { throw new NoneException }
	override hasSome() { false }
	override hasNone() { false }
	override hasError() { true }
	override iterator() { newLinkedList.iterator }
	override equals(Object obj) { obj instanceof Err<?> }
	override hashCode() { -1 }
	override toString() '''Error («exception.message»)'''
}

class Some<T> extends Opt<T> implements Function0<T> {
	var T value
	
	new(T value) {
		if(value == null) throw new NullPointerException('cannot create new Some(null)')
		this.value = value
	}
	override value() { value }
	override apply() { value }
	override hasSome() { true }
	override hasNone() { false }
	override hasError() { false }
	override iterator() { newLinkedList(value).iterator	}
	override hashCode() { value.hashCode }
	override equals(Object obj) { obj == value || (obj instanceof Some<?>) && (obj as Some<?>).value == value }
	override toString() '''Some(«value»)'''
	
}

class NoneException extends Exception { 
	new() { }
	new(String message) { super(message) }
}
