package nl.kii.util;

import java.util.Iterator;
import java.util.LinkedList;
import nl.kii.util.NoneException;
import nl.kii.util.Opt;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Functions.Function0;

@SuppressWarnings("all")
public class Err<T extends Object> extends Opt<T> implements Function0<Throwable> {
  private final Throwable exception;
  
  public Err() {
    Exception _exception = new Exception();
    this.exception = _exception;
  }
  
  public Err(final Throwable exception) {
    this.exception = exception;
  }
  
  public Throwable getException() {
    return this.exception;
  }
  
  public String getMessage() {
    return this.exception.getMessage();
  }
  
  public StackTraceElement[] getStackTrace() {
    return this.exception.getStackTrace();
  }
  
  @Override
  public Throwable apply() {
    return this.exception;
  }
  
  @Override
  public T value() {
    try {
      throw new NoneException();
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Override
  public boolean hasSome() {
    return false;
  }
  
  @Override
  public boolean hasNone() {
    return false;
  }
  
  @Override
  public boolean hasError() {
    return true;
  }
  
  @Override
  public Iterator<T> iterator() {
    LinkedList<T> _newLinkedList = CollectionLiterals.<T>newLinkedList();
    return _newLinkedList.iterator();
  }
  
  @Override
  public boolean equals(final Object obj) {
    return (obj instanceof Err<?>);
  }
  
  @Override
  public int hashCode() {
    return (-1);
  }
  
  @Override
  public String toString() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("Error (");
    String _message = this.exception.getMessage();
    _builder.append(_message, "");
    _builder.append(")");
    return _builder.toString();
  }
}
