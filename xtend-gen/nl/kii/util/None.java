package nl.kii.util;

import nl.kii.util.NoneException;
import nl.kii.util.Opt;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Exceptions;

@SuppressWarnings("all")
public class None<T extends java.lang.Object> extends Opt<T> {
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
    return true;
  }
  
  public boolean hasError() {
    return false;
  }
  
  public Object iterator() {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field newLinkedList is undefined for the type None"
      + "\niterator cannot be resolved");
  }
  
  public boolean equals(final /* Object */Object obj) {
    return (obj instanceof None<?>);
  }
  
  public int hashCode() {
    return 0;
  }
  
  public java.lang.CharSequence toString() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("None");
    return _builder;
  }
}
