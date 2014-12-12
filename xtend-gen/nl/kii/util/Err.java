package nl.kii.util;

import nl.kii.util.NoneException;
import nl.kii.util.Opt;
import org.eclipse.xtext.xbase.lib.Exceptions;

@SuppressWarnings("all")
public class Err<T extends java.lang.Object> extends Opt<T> /* implements Function0<Throwable>  */{
  private final /* Throwable */Object exception;
  
  public Err() {
    throw new Error("Unresolved compilation problems:"
      + "\nException cannot be resolved.");
  }
  
  public Err(final /* Throwable */Object exception) {
    this.exception = exception;
  }
  
  public Throwable getException() {
    return this.exception;
  }
  
  public Object getMessage() {
    throw new Error("Unresolved compilation problems:"
      + "\nmessage cannot be resolved");
  }
  
  public Object getStackTrace() {
    throw new Error("Unresolved compilation problems:"
      + "\nstackTrace cannot be resolved");
  }
  
  public Throwable apply() {
    return this.exception;
  }
  
  public T value() {
    try {
      throw new NoneException();
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public boolean hasSome() {
    return false;
  }
  
  public boolean hasNone() {
    return false;
  }
  
  public boolean hasError() {
    return true;
  }
  
  public Object iterator() {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field newLinkedList is undefined for the type Err"
      + "\niterator cannot be resolved");
  }
  
  public boolean equals(final /* Object */Object obj) {
    return (obj instanceof Err<?>);
  }
  
  public Object hashCode() {
    throw new Error("Unresolved compilation problems:"
      + "\n- cannot be resolved.");
  }
  
  public java.lang.CharSequence toString() {
    throw new Error("Unresolved compilation problems:"
      + "\nmessage cannot be resolved");
  }
}
