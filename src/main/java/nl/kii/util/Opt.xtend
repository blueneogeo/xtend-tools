package nl.kii.util

import static extension nl.kii.util.XtendTools.*;

abstract class Opt<T> implements Iterable<T> {
	def static <T> Opt<T> option(T value) { if(value.defined) some(value) else none }
	def static <T> Opt<T> of(T value) { value.option } // for Java
	def static <T> Some<T> some(T value) { new Some<T>(value) }
	def static <T> None<T> none() { new None<T> }
	def static <T> Err<T> error() { new Err<T> }
	def static <T> Err<T> error(Throwable t) { new Err<T>(t) }

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

class Err<T> extends Opt<T> {
	val Throwable exception

	new() {	try { throw new Exception } catch(Exception e) { exception = e } }
	new(Throwable exception) { this.exception = exception }
	
	def getException() { exception }
	def getMessage() { exception.message }
	def getStackTrace() { exception.stackTrace }
	override value() { throw new NoneException }
	override hasSome() { false }
	override hasNone() { false }
	override hasError() { true }
	override iterator() { newLinkedList.iterator }
	override equals(Object obj) { obj instanceof Err<?> }
	override hashCode() { -1 }
	override toString() '''Error («exception.message»)'''
}

class Some<T> extends Opt<T> {
	var T value
	
	new(T value) {
		if(value == null) throw new NullPointerException('cannot create new Some(null)')
		this.value = value
	}
	override value() { value }
	override hasSome() { true }
	override hasNone() { false }
	override hasError() { false }
	override iterator() { newLinkedList(value).iterator	}
	override hashCode() { value.hashCode }
	override equals(Object obj) { obj == value || (obj instanceof Some<?>) && (obj as Some<?>).value == value }
	override toString() '''Some(«value»)'''
}

class NoneException extends Exception { }
