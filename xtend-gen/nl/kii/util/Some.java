package nl.kii.util;

import nl.kii.util.Opt;
import org.eclipse.xtend2.lib.StringConcatenation;

@SuppressWarnings("all")
public class Some<T extends java.lang.Object> extends Opt<T> /* implements Function0<T>  */{
  private T value;
  
  public Some(final T value) {
    throw new Error("Unresolved compilation problems:"
      + "\n== cannot be resolved."
      + "\nNullPointerException cannot be resolved.");
  }
  
  public T value() {
    return this.value;
  }
  
  public T apply() {
    return this.value;
  }
  
  public boolean hasSome() {
    return true;
  }
  
  public boolean hasNone() {
    return false;
  }
  
  public boolean hasError() {
    return false;
  }
  
  public Object iterator() {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method newLinkedList is undefined for the type Some"
      + "\niterator cannot be resolved");
  }
  
  public Object hashCode() {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method hashCode is undefined for the type Some");
  }
  
  public Object equals(final /* Object */Object obj) {
    throw new Error("Unresolved compilation problems:"
      + "\n&& cannot be resolved."
      + "\n== cannot be resolved"
      + "\n|| cannot be resolved"
      + "\n== cannot be resolved");
  }
  
  public java.lang.CharSequence toString() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("Some(");
    _builder.append(this.value, "");
    _builder.append(")");
    return _builder;
  }
}
